import 'package:wassaly/core/imports/packages_imports.dart';

import 'package:wassaly/features/cart/domain/entities/offer_entity.dart';

class CartItemEntity extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final String price;
  final String? productDescription;
  final List<OfferEntity>? offers;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity, this.productDescription,
    this.offers,
    this.unitPrice = 0.0,
    this.totalPrice = 0.0,
  });

  CartItemEntity copyWith({
    int? id,
    int? productId,
    String? productName,
    String? productImage,
    String? price,
    String? productDescription,
    List<OfferEntity>? offers,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) => CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      productDescription: productDescription ?? this.productDescription,
      offers: offers ?? this.offers,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productImage,
        price,
        productDescription,
        offers,
        quantity,
        unitPrice,
        totalPrice,
      ];
}
