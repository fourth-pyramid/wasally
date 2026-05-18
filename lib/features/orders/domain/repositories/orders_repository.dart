import 'package:wassaly/core/imports/imports.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, PaginatedResponse<OrderEntity>>> getOrders(
      {int page = 1});
  Future<Either<Failure, OrderEntity>> getOrderDetails(int orderId);
  Future<Either<Failure, void>> cancelOrder(int orderId);
  Future<Either<Failure, void>> updateOrder(int orderId, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteOrder(int orderId);
}

