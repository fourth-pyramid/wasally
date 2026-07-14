import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartLocalDataSource {
  Future<Either<Failure, void>> saveCartItemsLocally(
    List<CartItemEntity> items,
  );
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
    List<CartItemEntity> items,
  ) async {
    try {
      await _cartBox.clear();
      final map = <int, CartItemEntity>{
        for (final item in items) item.id: item,
      };
      await _cartBox.putAll(map);
      return right(null);
    } on Exception catch (e) {
      return left(CacheFailure('Failed to save cart items: $e'));
    }
  }

  @override
  List<CartItemEntity> getCartItemsLocally() => _cartBox.values.toList();

  @override
  bool isProductInCartLocally(int productId) =>
      _cartBox.values.any((item) => item.productId == productId);

  @override
  int getCartCountLocally() => _cartBox.length;

  @override
  Future<Either<Failure, void>> clearCartLocally() async {
    try {
      await _cartBox.clear();
      return right(null);
    } on Exception catch (e) {
      return left(CacheFailure('Failed to clear cart: $e'));
    }
  }
}
