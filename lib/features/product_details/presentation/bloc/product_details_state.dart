import 'package:wassaly/core/imports/imports.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

enum RelatedProductsStatus { initial, loading, success, failure }

enum ReviewActionStatus { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final RelatedProductsStatus relatedProductsStatus;
  final ReviewActionStatus reviewActionStatus;
  final ProductDetailEntity? product;
  final List<ProductEntity> relatedProducts;
  final String errorMessage;
  final String reviewActionMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.relatedProductsStatus = RelatedProductsStatus.initial,
    this.reviewActionStatus = ReviewActionStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.errorMessage = '',
    this.reviewActionMessage = '',
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    RelatedProductsStatus? relatedProductsStatus,
    ReviewActionStatus? reviewActionStatus,
    ProductDetailEntity? product,
    List<ProductEntity>? relatedProducts,
    String? errorMessage,
    String? reviewActionMessage,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      relatedProductsStatus:
          relatedProductsStatus ?? this.relatedProductsStatus,
      reviewActionStatus: reviewActionStatus ?? this.reviewActionStatus,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      errorMessage: errorMessage ?? this.errorMessage,
      reviewActionMessage: reviewActionMessage ?? this.reviewActionMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        relatedProductsStatus,
        reviewActionStatus,
        product,
        relatedProducts,
        errorMessage,
        reviewActionMessage,
      ];
}
