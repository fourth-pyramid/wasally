import 'package:wassaly/core/imports/packages_imports.dart';

import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';

class PlaceOrderParams extends Equatable {
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String governorateId;
  final String region;
  final String centerId;
  final String? couponCode;
  final List<CartItemEntity> items;

  const PlaceOrderParams({
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.governorateId,
    required this.region,
    required this.centerId,
    required this.items, this.couponCode,
  });

  @override
  List<Object?> get props => [
        customerName,
        customerPhone,
        customerAddress,
        governorateId,
        region,
        centerId,
        couponCode,
        items,
      ];
}
