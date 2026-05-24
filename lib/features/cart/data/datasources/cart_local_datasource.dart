import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/imports/core_imports.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class CartLocalDataSource {
  Future<Either<Failure, void>> saveCartItemsLocally(
      List<CartItemEntity> items);
  List<CartItemEntity> getCartItemsLocally();
  bool isProductInCartLocally(int productId);
  int getCartCountLocally();
  Future<Either<Failure, void>> clearCartLocally();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<CartItemEntity> _cartBox;

  CartLocalDataSourceImpl()
      : _cartBox = Hive.box<CartItemEntity>(HiveService.cartBox);

  @override
  Future<Either<Failure, void>> saveCartItemsLocally(
      List<CartItemEntity> items) async {
    try {
      await _cartBox.clear();
      final Map<int, CartItemEntity> map = {
        for (final item in items) item.id: item
      };
      await _cartBox.putAll(map);
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to save cart items: ${e.toString()}'));
    }
  }

  @override
  List<CartItemEntity> getCartItemsLocally() {
    return _cartBox.values.toList();
  }

  @override
  bool isProductInCartLocally(int productId) {
    return _cartBox.values.any((item) => item.productId == productId);
  }

  @override
  int getCartCountLocally() {
    return _cartBox.length;
  }

  @override
  Future<Either<Failure, void>> clearCartLocally() async {
    try {
      await _cartBox.clear();
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to clear cart: ${e.toString()}'));
    }
  }
}
