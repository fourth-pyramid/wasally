import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_brand_products_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import 'brands_event.dart';
import 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  final GetBrandsUseCase _getBrandsUseCase;
  final GetBrandProductsUseCase _getBrandProductsUseCase;

  BrandsBloc(
    this._getBrandsUseCase,
    this._getBrandProductsUseCase,
  ) : super(const BrandsState()) {
    on<GetBrandsEvent>(_onGetBrands);
    on<GetBrandProductsEvent>(_onGetBrandProducts);
    on<LoadMoreBrandProductsEvent>(_onLoadMoreBrandProducts);
  }

  Future<void> _onGetBrands(
    GetBrandsEvent event,
    Emitter<BrandsState> emit,
  ) async {
    emit(state.copyWith(status: BrandsStatus.loading));

    final result = await _getBrandsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BrandsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (brands) => emit(
        state.copyWith(
          status: BrandsStatus.success,
          brands: brands,
        ),
      ),
    );
  }

  Future<void> _onGetBrandProducts(
    GetBrandProductsEvent event,
    Emitter<BrandsState> emit,
  ) async {
    emit(state.copyWith(
      productsStatus: BrandProductsStatus.loading,
      currentPage: 1,
      hasReachedMax: false,
      products: event.isRefresh ? const [] : state.products,
    ));

    final result = await _getBrandProductsUseCase(
      brandId: event.brandId,
      page: 1,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          productsStatus: BrandProductsStatus.failure,
          productsErrorMessage: failure.message,
        ),
      ),
      (paginatedResponse) => emit(
        state.copyWith(
          productsStatus: BrandProductsStatus.success,
          products: paginatedResponse.data,
          currentPage: paginatedResponse.currentPage,
          hasReachedMax:
              paginatedResponse.currentPage >= paginatedResponse.lastPage,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreBrandProducts(
    LoadMoreBrandProductsEvent event,
    Emitter<BrandsState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.productsStatus == BrandProductsStatus.loading) {
      return;
    }

    final nextPage = state.currentPage + 1;

    final result = await _getBrandProductsUseCase(
      brandId: event.brandId,
      page: nextPage,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          productsStatus: BrandProductsStatus.failure,
          productsErrorMessage: failure.message,
        ),
      ),
      (paginatedResponse) => emit(
        state.copyWith(
          productsStatus: BrandProductsStatus.success,
          products: List.of(state.products)..addAll(paginatedResponse.data),
          currentPage: paginatedResponse.currentPage,
          hasReachedMax:
              paginatedResponse.currentPage >= paginatedResponse.lastPage,
        ),
      ),
    );
  }
}
