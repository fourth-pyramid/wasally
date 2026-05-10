import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, void>> addToCart(int productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(int cartItemId);
  Future<Either<Failure, void>> updateQuantity(int cartItemId, int quantity);
}
