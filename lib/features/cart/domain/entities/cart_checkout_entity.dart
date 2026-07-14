import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';

class CartCheckoutEntity extends Equatable {
  final UserEntity? user;
  final AddressEntity? selectedAddress;
  final GovernorateEntity? governorate;
  final double shippingCost;
  final double subtotal;
  final double total;

  const CartCheckoutEntity({
    this.user,
    this.selectedAddress,
    this.governorate,
    this.shippingCost = 0.0,
    this.subtotal = 0.0,
    this.total = 0.0,
  });

  CartCheckoutEntity copyWith({
    UserEntity? user,
    AddressEntity? selectedAddress,
    GovernorateEntity? governorate,
    double? shippingCost,
    double? subtotal,
    double? total,
  }) => CartCheckoutEntity(
      user: user ?? this.user,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      governorate: governorate ?? this.governorate,
      shippingCost: shippingCost ?? this.shippingCost,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
    );

  @override
  List<Object?> get props => [
        user,
        selectedAddress,
        governorate,
        shippingCost,
        subtotal,
        total,
      ];
}
