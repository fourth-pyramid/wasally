import '../../../../core/imports/imports.dart';

class ReviewEntity extends Equatable {
  final int id;
  final int rating;
  final String comment;
  final String createdAt;

  const ReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, rating, comment, createdAt];
}
