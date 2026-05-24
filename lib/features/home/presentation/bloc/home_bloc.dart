import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/entities/banner_entity.dart';
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
    on<LoadMorePopularServicesEvent>(_onLoadMorePopularServices);
    on<GetProductsEvent>(_onGetProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<HomeInitializeEvent>(_onHomeInitialize);
  }

  Future<void> _onGetBanners(
      GetBannersEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      bannersStatus: HomeStatus.loading,
      failure: null,
    ));

    final result = await getBannersUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          bannersStatus: HomeStatus.failure,
          failure: failure,
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
      popularServices: const PaginatedResponse(data: []),
      failure: null,
    ));

    final result = await getPopularServicesUseCase(page: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(
          popularServicesStatus: HomeStatus.failure,
          failure: failure,
        ));
      },
      (paginatedResponse) {
        emit(state.copyWith(
          popularServicesStatus: HomeStatus.success,
          popularServices: paginatedResponse,
        ));
      },
    );
  }

  Future<void> _onLoadMorePopularServices(
      LoadMorePopularServicesEvent event, Emitter<HomeState> emit) async {
    if (state.popularServicesStatus == HomeStatus.loading ||
        state.isPopularServicesLoadingMore ||
        !state.popularServices.hasMore) {
      return;
    }

    emit(state.copyWith(isPopularServicesLoadingMore: true));

    final nextPage = state.popularServices.currentPage + 1;

    final result = await getPopularServicesUseCase(page: nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isPopularServicesLoadingMore: false));
      },
      (paginatedResponse) {
        emit(state.copyWith(
          isPopularServicesLoadingMore: false,
          popularServices: paginatedResponse.copyWith(
            data: [...state.popularServices.data, ...paginatedResponse.data],
          ),
        ));
      },
    );
  }

  Future<void> _onGetCategories(
      GetCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      categoriesStatus: HomeStatus.loading,
      categories: const <CategoryEntity>[],
      failure: null,
    ));

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          categoriesStatus: HomeStatus.failure,
          failure: failure,
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
      products: const PaginatedResponse<ProductEntity>(data: []),
      failure: null,
    ));

    final result = await getProductsUseCase(page: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(
          productsStatus: HomeStatus.failure,
          failure: failure,
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
    if (state.productsStatus == HomeStatus.loading ||
        state.isProductsLoadingMore ||
        !state.products.hasMore) {
      return;
    }

    emit(state.copyWith(isProductsLoadingMore: true));

    final nextPage = state.products.currentPage + 1;

    final result = await getProductsUseCase(page: nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isProductsLoadingMore: false));
      },
      (paginatedResponse) {
        emit(state.copyWith(
          isProductsLoadingMore: false,
          products: paginatedResponse.copyWith(
            data: [...state.products.data, ...paginatedResponse.data],
          ),
        ));
      },
    );
  }

  Future<void> _onHomeInitialize(
      HomeInitializeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      bannersStatus: HomeStatus.loading,
      categoriesStatus: HomeStatus.loading,
      popularServicesStatus: HomeStatus.loading,
      productsStatus: HomeStatus.loading,
      banners: const [],
      categories: const [],
      popularServices: const PaginatedResponse(data: []),
      products: const PaginatedResponse(data: []),
      failure: null,
    ));

    final results = await Future.wait([
      getBannersUseCase(),
      getCategoriesUseCase(),
      getPopularServicesUseCase(page: 1),
      getProductsUseCase(page: 1),
    ]);

    final bannersResult = results[0] as Either<Failure, List<BannerEntity>>;
    final categoriesResult =
        results[1] as Either<Failure, List<CategoryEntity>>;
    final servicesResult =
        results[2] as Either<Failure, PaginatedResponse<SubCategoryEntity>>;
    final productsResult =
        results[3] as Either<Failure, PaginatedResponse<ProductEntity>>;

    HomeStatus bannersStatus = HomeStatus.success;
    List<BannerEntity> banners = const [];
    bannersResult.fold(
      (_) => bannersStatus = HomeStatus.failure,
      (data) => banners = data,
    );

    HomeStatus categoriesStatus = HomeStatus.success;
    List<CategoryEntity> categories = const [];
    categoriesResult.fold(
      (_) => categoriesStatus = HomeStatus.failure,
      (data) => categories = data,
    );

    HomeStatus servicesStatus = HomeStatus.success;
    PaginatedResponse<SubCategoryEntity> services =
        const PaginatedResponse(data: []);
    servicesResult.fold(
      (_) => servicesStatus = HomeStatus.failure,
      (data) => services = data,
    );

    HomeStatus productsStatus = HomeStatus.success;
    PaginatedResponse<ProductEntity> products =
        const PaginatedResponse(data: []);
    productsResult.fold(
      (_) => productsStatus = HomeStatus.failure,
      (data) => products = data,
    );

    Failure? firstFailure;
    bannersResult.fold((f) => firstFailure ??= f, (_) {});
    categoriesResult.fold((f) => firstFailure ??= f, (_) {});
    servicesResult.fold((f) => firstFailure ??= f, (_) {});
    productsResult.fold((f) => firstFailure ??= f, (_) {});

    emit(state.copyWith(
      bannersStatus: bannersStatus,
      banners: banners,
      categoriesStatus: categoriesStatus,
      categories: categories,
      popularServicesStatus: servicesStatus,
      popularServices: services,
      productsStatus: productsStatus,
      products: products,
      failure: firstFailure,
    ));
  }
}
