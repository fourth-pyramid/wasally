import 'package:wassaly/core/imports/packages_imports.dart';

class OfferEntity extends Equatable {
  final int id;
  final double discountPercentage;

  const OfferEntity({
    required this.id,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props => [id, discountPercentage];
}
