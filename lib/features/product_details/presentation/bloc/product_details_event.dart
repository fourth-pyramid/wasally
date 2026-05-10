import 'package:wassaly/core/imports/imports.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetailsEvent extends ProductDetailsEvent {
  final int productId;

  const FetchProductDetailsEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class FetchRelatedProductsEvent extends ProductDetailsEvent {
  final int subCategoryId;
  final int currentProductId;

  const FetchRelatedProductsEvent({
    required this.subCategoryId,
    required this.currentProductId,
  });

  @override
  List<Object?> get props => [subCategoryId, currentProductId];
}

class CreateProductReviewEvent extends ProductDetailsEvent {
  final int productId;
  final int rating;
  final String comment;

  const CreateProductReviewEvent({
    required this.productId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, rating, comment];
}

class UpdateProductReviewEvent extends ProductDetailsEvent {
  final int productId;
  final int reviewId;
  final int rating;
  final String comment;

  const UpdateProductReviewEvent({
    required this.productId,
    required this.reviewId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, reviewId, rating, comment];
}
