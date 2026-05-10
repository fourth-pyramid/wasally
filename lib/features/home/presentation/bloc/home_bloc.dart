import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_popular_services_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetBannersUseCase getBannersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetPopularServicesUseCase getPopularServicesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeBloc({
    required this.getBannersUseCase,
    required this.getCategoriesUseCase,
    required this.getPopularServicesUseCase,
    required this.getProductsUseCase,
  }) : super(const HomeState()) {
    on<GetBannersEvent>(_onGetBanners);
    on<GetCategoriesEvent>(_onGetCategories);
    on<GetPopularServicesEvent>(_onGetPopularServices);
    on<GetProductsEvent>(_onGetProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  Future<void> _onGetBanners(
      GetBannersEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      bannersStatus: HomeStatus.loading,
      errorMessage: '',
    ));

    final result = await getBannersUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          bannersStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (banners) {
        emit(state.copyWith(
          bannersStatus: HomeStatus.success,
          banners: banners,
        ));
      },
    );
  }

  Future<void> _onGetPopularServices(
      GetPopularServicesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      popularServicesStatus: HomeStatus.loading,
      popularServices: const <SubCategoryEntity>[], // Clear old data to show skeleton
      errorMessage: '',
    ));

    final result = await getPopularServicesUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          popularServicesStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (services) {
        emit(state.copyWith(
          popularServicesStatus: HomeStatus.success,
          popularServices: services,
        ));
      },
    );
  }

  Future<void> _onGetCategories(
      GetCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      categoriesStatus: HomeStatus.loading,
      categories: const <CategoryEntity>[], // Clear old data to show skeleton
      errorMessage: '',
    ));

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          categoriesStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (categories) {
        emit(state.copyWith(
          categoriesStatus: HomeStatus.success,
          categories: categories,
        ));
      },
    );
  }

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      productsStatus: HomeStatus.loading,
      products: const PaginatedResponse<ProductEntity>(
          data: []), // Clear old data to show skeleton
      errorMessage: '',
    ));

    final result = await getProductsUseCase(page: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(
          productsStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (paginatedResponse) {
        emit(state.copyWith(
          productsStatus: HomeStatus.success,
          products: paginatedResponse,
        ));
      },
    );
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProductsEvent event, Emitter<HomeState> emit) async {
    if (state.productsStatus == HomeStatus.loading || !state.products.hasMore) {
      return;
    }

    final nextPage = state.products.currentPage + 1;

    final result = await getProductsUseCase(page: nextPage);

    result.fold(
      (failure) {
        // We don't change productsStatus to failure here to keep showing current products
        // Maybe show a snackbar or just ignore
      },
      (paginatedResponse) {
        emit(state.copyWith(
          products: paginatedResponse.copyWith(
            data: [...state.products.data, ...paginatedResponse.data],
          ),
        ));
      },
    );
  }
}
