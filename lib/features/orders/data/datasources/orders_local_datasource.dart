import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/imports/core_imports.dart';
import '../models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<Either<Failure, void>> cacheOrders(List<OrderModel> orders,
      {int page = 1});
  List<OrderModel> getCachedOrders({int page = 1});
  Future<Either<Failure, void>> clearCache();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final Box<OrderModel> _ordersBox;

  OrdersLocalDataSourceImpl()
      : _ordersBox = Hive.box<OrderModel>(HiveService.ordersBox);

  @override
  Future<Either<Failure, void>> cacheOrders(List<OrderModel> orders,
      {int page = 1}) async {
    try {
      if (page == 1) {
        await _ordersBox.clear();
      }

      final Map<int, OrderModel> map = {for (final o in orders) o.id: o};
      await _ordersBox.putAll(map);

      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to cache orders: ${e.toString()}'));
    }
  }

  @override
  List<OrderModel> getCachedOrders({int page = 1}) {
    final list = _ordersBox.values.toList();
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _ordersBox.clear();
      return right(null);
    } catch (e) {
      return left(
          CacheFailure('Failed to clear orders cache: ${e.toString()}'));
    }
  }
}
