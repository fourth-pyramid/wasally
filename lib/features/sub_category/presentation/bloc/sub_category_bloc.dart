
import '../../../../core/imports/imports.dart';
import '../../domain/usecases/get_sub_category_detail_usecase.dart';
import 'sub_category_event.dart';
import 'sub_category_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final GetSubCategoryDetailUseCase _getSubCategoryDetailUseCase;

  SubCategoryBloc({
    required GetSubCategoryDetailUseCase getSubCategoryDetailUseCase,
  })  : _getSubCategoryDetailUseCase = getSubCategoryDetailUseCase,
        super(const SubCategoryState()) {
    on<FetchSubCategoryDetailEvent>(_onFetchSubCategoryDetail);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  Future<void> _onFetchSubCategoryDetail(
    FetchSubCategoryDetailEvent event,
    Emitter<SubCategoryState> emit,
  ) async {
    emit(state.copyWith(status: SubCategoryStatus.loading));

    final result =
        await _getSubCategoryDetailUseCase(event.subCategoryId, page: 1);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SubCategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (subCategory) => emit(state.copyWith(
        status: SubCategoryStatus.success,
        subCategory: subCategory,
        products: subCategory.products,
      )),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<SubCategoryState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMoreProducts) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result =
        await _getSubCategoryDetailUseCase(event.subCategoryId, page: nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (subCategory) {
        emit(state.copyWith(
          isLoadingMore: false,
          products: subCategory.products.copyWith(
            data: [...state.products.data, ...subCategory.products.data],
          ),
        ));
      },
    );
  }
}
