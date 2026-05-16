import '../../domain/entities/cart_item_entity.dart';
import 'offer_model.dart';

class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final String price;
  final String? productDescription;
  final List<OfferModel>? offers;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.productDescription,
    this.offers,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      price: entity.price,
      productDescription: entity.productDescription,
      offers:
          entity.offers?.map((offer) => OfferModel.fromEntity(offer)).toList(),
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    final offersList = product?['offers'] as List<dynamic>?;

    return CartItemModel(
      id: json['id'] as int,
      productId: product?['id'] as int? ?? 0,
      productName: product?['name'] as String? ?? '',
      productImage: product?['image'] as String? ?? '',
      price: product?['price']?.toString() ?? '0',
      productDescription: product?['description'] as String?,
      offers: offersList
          ?.map((offer) => OfferModel.fromJson(offer as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      productDescription: productDescription,
      offers: offers?.map((offer) => offer.toEntity()).toList(),
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
    );
  }
}
