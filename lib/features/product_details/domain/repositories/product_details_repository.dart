import 'package:wassaly/core/imports/imports.dart';

import '../entities/product_detail_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(int productId);
  Future<Either<Failure, Unit>> createProductReview({
    required int productId,
    required int rating,
    required String comment,
  });
  Future<Either<Failure, Unit>> updateProductReview({
    required int reviewId,
    required int rating,
    required String comment,
  });
}
