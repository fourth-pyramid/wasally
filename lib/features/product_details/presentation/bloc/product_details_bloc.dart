import 'package:wassaly/core/imports/imports.dart';

import '../../../sub_category/domain/usecases/get_sub_category_detail_usecase.dart';
import '../../domain/usecases/create_product_review_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/update_product_review_usecase.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;
  final GetSubCategoryDetailUseCase _getSubCategoryDetailUseCase;
  final CreateProductReviewUseCase _createProductReviewUseCase;
  final UpdateProductReviewUseCase _updateProductReviewUseCase;

  ProductDetailsBloc({
    required GetProductDetailsUseCase getProductDetailsUseCase,
    required GetSubCategoryDetailUseCase getSubCategoryDetailUseCase,
    required CreateProductReviewUseCase createProductReviewUseCase,
    required UpdateProductReviewUseCase updateProductReviewUseCase,
  })  : _getProductDetailsUseCase = getProductDetailsUseCase,
        _getSubCategoryDetailUseCase = getSubCategoryDetailUseCase,
        _createProductReviewUseCase = createProductReviewUseCase,
        _updateProductReviewUseCase = updateProductReviewUseCase,
        super(const ProductDetailsState()) {
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
    on<FetchRelatedProductsEvent>(_onFetchRelatedProducts);
    on<CreateProductReviewEvent>(_onCreateProductReview);
    on<UpdateProductReviewEvent>(_onUpdateProductReview);
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductDetailsStatus.loading,
        relatedProductsStatus: RelatedProductsStatus.initial,
        relatedProducts: const [],
        errorMessage: '',
      ),
    );

    final result = await _getProductDetailsUseCase(event.productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (product) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
          ),
        );

        final subCategoryId = product.subCategory?.id ?? 0;
        if (subCategoryId > 0) {
          add(
            FetchRelatedProductsEvent(
              subCategoryId: subCategoryId,
              currentProductId: product.id,
            ),
          );
        }
      },
    );
  }

  Future<void> _onFetchRelatedProducts(
    FetchRelatedProductsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        relatedProductsStatus: RelatedProductsStatus.loading,
        relatedProducts: const [],
      ),
    );

    final result = await _getSubCategoryDetailUseCase(event.subCategoryId);

    result.fold(
      (_) => emit(
        state.copyWith(
          relatedProductsStatus: RelatedProductsStatus.failure,
          relatedProducts: const [],
        ),
      ),
      (subCategory) => emit(
        state.copyWith(
          relatedProductsStatus: RelatedProductsStatus.success,
          relatedProducts: subCategory.products.data
              .where((product) => product.id != event.currentProductId)
              .toList(),
        ),
      ),
    );
  }

  Future<void> _onCreateProductReview(
    CreateProductReviewEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewActionStatus: ReviewActionStatus.loading,
        reviewActionMessage: '',
      ),
    );

    final result = await _createProductReviewUseCase(
      CreateProductReviewParams(
        productId: event.productId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            reviewActionStatus: ReviewActionStatus.failure,
            reviewActionMessage: failure.message,
          ),
        );
      },
      (_) async {
        await _refreshProductAfterReviewAction(
          productId: event.productId,
          emit: emit,
          successMessage: 'product_details.review_created'.tr(),
        );
      },
    );
  }

  Future<void> _onUpdateProductReview(
    UpdateProductReviewEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewActionStatus: ReviewActionStatus.loading,
        reviewActionMessage: '',
      ),
    );

    final result = await _updateProductReviewUseCase(
      UpdateProductReviewParams(
        reviewId: event.reviewId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            reviewActionStatus: ReviewActionStatus.failure,
            reviewActionMessage: failure.message,
          ),
        );
      },
      (_) async {
        await _refreshProductAfterReviewAction(
          productId: event.productId,
          emit: emit,
          successMessage: 'product_details.review_updated'.tr(),
        );
      },
    );
  }

  Future<void> _refreshProductAfterReviewAction({
    required int productId,
    required Emitter<ProductDetailsState> emit,
    required String successMessage,
  }) async {
    final refreshed = await _getProductDetailsUseCase(productId);

    refreshed.fold(
      (failure) => emit(
        state.copyWith(
          reviewActionStatus: ReviewActionStatus.failure,
          reviewActionMessage: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: ProductDetailsStatus.success,
          product: product,
          reviewActionStatus: ReviewActionStatus.success,
          reviewActionMessage: successMessage,
        ),
      ),
    );
  }
}
