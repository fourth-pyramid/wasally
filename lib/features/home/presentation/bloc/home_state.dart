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
  final List<SubCategoryEntity> popularServices;
  final HomeStatus productsStatus;
  final PaginatedResponse<ProductEntity> products;
  final String errorMessage;

  const HomeState({
    this.bannersStatus = HomeStatus.initial,
    this.banners = const [],
    this.categoriesStatus = HomeStatus.initial,
    this.categories = const [],
    this.popularServicesStatus = HomeStatus.initial,
    this.popularServices = const [],
    this.productsStatus = HomeStatus.initial,
    this.products = const PaginatedResponse(data: []),
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? bannersStatus,
    List<BannerEntity>? banners,
    HomeStatus? categoriesStatus,
    List<CategoryEntity>? categories,
    HomeStatus? popularServicesStatus,
    List<SubCategoryEntity>? popularServices,
    HomeStatus? productsStatus,
    PaginatedResponse<ProductEntity>? products,
    String? errorMessage,
  }) {
    return HomeState(
      bannersStatus: bannersStatus ?? this.bannersStatus,
      banners: banners ?? this.banners,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      categories: categories ?? this.categories,
      popularServicesStatus:
          popularServicesStatus ?? this.popularServicesStatus,
      popularServices: popularServices ?? this.popularServices,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
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
        productsStatus,
        products,
        errorMessage,
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
}
