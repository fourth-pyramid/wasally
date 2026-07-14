import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/orders/data/models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<Either<Failure, void>> cacheOrders(
    List<OrderModel> orders, {
    int page = 1,
  });
  List<OrderModel> getCachedOrders({int page = 1});
  Future<Either<Failure, void>> clearCache();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final Box<OrderModel> _ordersBox;

  OrdersLocalDataSourceImpl()
      : _ordersBox = Hive.box<OrderModel>(HiveService.ordersBox);

  @override
  Future<Either<Failure, void>> cacheOrders(
    List<OrderModel> orders, {
    int page = 1,
  }) async {
    try {
      if (page == 1) {
        await _ordersBox.clear();
      }

      final map = <int, OrderModel>{for (final o in orders) o.id: o};
      await _ordersBox.putAll(map);

      return right(null);
    } on Object catch (e) {
      return left(CacheFailure('Failed to cache orders: $e'));
    }
  }

  @override
  List<OrderModel> getCachedOrders({int page = 1}) =>
      _ordersBox.values.toList()..sort((a, b) => b.id.compareTo(a.id));

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _ordersBox.clear();
      return right(null);
    } on Object catch (e) {
      return left(
        CacheFailure('Failed to clear orders cache: $e'),
      );
    }
  }
}
