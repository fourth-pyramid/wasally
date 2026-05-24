import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/sub_category_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus bannersStatus;
  final List<BannerEntity> banners;
  final HomeStatus categoriesStatus;
  final List<CategoryEntity> categories;
  final HomeStatus popularServicesStatus;
  final PaginatedResponse<SubCategoryEntity> popularServices;
  final bool isPopularServicesLoadingMore;
  final HomeStatus productsStatus;
  final PaginatedResponse<ProductEntity> products;
  final bool isProductsLoadingMore;
  final Failure? failure;

  const HomeState({
    this.bannersStatus = HomeStatus.initial,
    this.banners = const [],
    this.categoriesStatus = HomeStatus.initial,
    this.categories = const [],
    this.popularServicesStatus = HomeStatus.initial,
    this.popularServices = const PaginatedResponse(data: []),
    this.isPopularServicesLoadingMore = false,
    this.productsStatus = HomeStatus.initial,
    this.products = const PaginatedResponse(data: []),
    this.isProductsLoadingMore = false,
    this.failure,
  });

  HomeState copyWith({
    HomeStatus? bannersStatus,
    List<BannerEntity>? banners,
    HomeStatus? categoriesStatus,
    List<CategoryEntity>? categories,
    HomeStatus? popularServicesStatus,
    PaginatedResponse<SubCategoryEntity>? popularServices,
    bool? isPopularServicesLoadingMore,
    HomeStatus? productsStatus,
    PaginatedResponse<ProductEntity>? products,
    bool? isProductsLoadingMore,
    Failure? failure,
  }) {
    return HomeState(
      bannersStatus: bannersStatus ?? this.bannersStatus,
      banners: banners ?? this.banners,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      popularServicesStatus:
          popularServicesStatus ?? this.popularServicesStatus,
      popularServices: popularServices ?? this.popularServices,
      isPopularServicesLoadingMore:
          isPopularServicesLoadingMore ?? this.isPopularServicesLoadingMore,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      isProductsLoadingMore:
          isProductsLoadingMore ?? this.isProductsLoadingMore,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
        bannersStatus,
        banners,
        categoriesStatus,
        categories,
        popularServicesStatus,
        popularServices,
        isPopularServicesLoadingMore,
        productsStatus,
        products,
        isProductsLoadingMore,
        failure,
      ];

  /// Check if all sections failed (likely due to network error)
  bool get allSectionsFailed {
    return bannersStatus == HomeStatus.failure &&
        categoriesStatus == HomeStatus.failure &&
        popularServicesStatus == HomeStatus.failure &&
        productsStatus == HomeStatus.failure;
  }

  /// Check if any section is still loading
  bool get anySectionLoading {
    return bannersStatus == HomeStatus.loading ||
        categoriesStatus == HomeStatus.loading ||
        popularServicesStatus == HomeStatus.loading ||
        productsStatus == HomeStatus.loading;
  }

  /// Get error message for backward compatibility
  String get errorMessage => failure?.message ?? '';
}
