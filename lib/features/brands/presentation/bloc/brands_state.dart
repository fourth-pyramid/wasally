import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/brand_entity.dart';

enum BrandsStatus { initial, loading, success, failure }

enum BrandProductsStatus { initial, loading, loadingMore, success, failure }

class BrandsState extends Equatable {
  final BrandsStatus status;
  final List<BrandEntity> brands;
  final String errorMessage;

  final BrandProductsStatus productsStatus;
  final List<ProductEntity> products;
  final String productsErrorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const BrandsState({
    this.status = BrandsStatus.initial,
    this.brands = const [],
    this.errorMessage = '',
    this.productsStatus = BrandProductsStatus.initial,
    this.products = const [],
    this.productsErrorMessage = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  BrandsState copyWith({
    BrandsStatus? status,
    List<BrandEntity>? brands,
    String? errorMessage,
    BrandProductsStatus? productsStatus,
    List<ProductEntity>? products,
    String? productsErrorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return BrandsState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      errorMessage: errorMessage ?? this.errorMessage,
      productsStatus: productsStatus ?? this.productsStatus,
      products: products ?? this.products,
      productsErrorMessage: productsErrorMessage ?? this.productsErrorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        brands,
        errorMessage,
        productsStatus,
        products,
        productsErrorMessage,
        currentPage,
        hasReachedMax,
      ];
}
