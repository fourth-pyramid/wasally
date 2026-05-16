import 'package:wassaly/core/imports/imports.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, PaginatedResponse<OrderEntity>>> getOrders(
      {int page = 1});
}
