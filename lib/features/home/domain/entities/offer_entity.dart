import '../../../../core/imports/imports.dart';

class OfferEntity extends Equatable {
  final int id;
  final int discountPercentage;

  const OfferEntity({
    required this.id,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props => [id, discountPercentage];
}
