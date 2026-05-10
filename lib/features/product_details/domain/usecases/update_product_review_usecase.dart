import 'package:wassaly/core/imports/imports.dart';

import '../repositories/product_details_repository.dart';

class UpdateProductReviewUseCase {
  final ProductDetailsRepository _repository;

  const UpdateProductReviewUseCase(this._repository);

  Future<Either<Failure, Unit>> call(UpdateProductReviewParams params) {
    return _repository.updateProductReview(
      reviewId: params.reviewId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateProductReviewParams extends Equatable {
  final int reviewId;
  final int rating;
  final String comment;

  const UpdateProductReviewParams({
    required this.reviewId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment];
}
