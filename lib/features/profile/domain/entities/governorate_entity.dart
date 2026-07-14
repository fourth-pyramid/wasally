import 'package:wassaly/core/imports/packages_imports.dart';

class GovernorateEntity extends Equatable {
  final String id;
  final String name;
  final double shippingCost;

  const GovernorateEntity({
    required this.id,
    required this.name,
    required this.shippingCost,
  });

  @override
  List<Object?> get props => [id, name, shippingCost];
}
