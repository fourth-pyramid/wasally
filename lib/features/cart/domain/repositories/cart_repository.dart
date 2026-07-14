import 'package:wassaly/core/imports/packages_imports.dart';

import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wassaly/features/cart/domain/entities/coupon_entity.dart';
import 'package:wassaly/features/cart/domain/entities/order_entity.dart';
import 'package:wassaly/features/cart/domain/entities/place_order_params.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, void>> addToCart(int productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(int cartItemId);
  Future<Either<Failure, void>> updateQuantity(int cartItemId, int quantity);
  Future<Either<Failure, CouponEntity>> applyCoupon(String code);
  Future<Either<Failure, OrderEntity>> placeOrder(PlaceOrderParams params);

  // Local storage methods
  Future<Either<Failure, void>> saveCartItemsLocally(
      List<CartItemEntity> items,);
  List<CartItemEntity> getCartItemsLocally();
  bool isProductInCartLocally(int productId);
  int getCartCountLocally();
  Future<Either<Failure, void>> clearCartLocally();
}
