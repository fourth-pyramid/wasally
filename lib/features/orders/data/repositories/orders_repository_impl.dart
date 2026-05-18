import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  const OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<OrderEntity>>> getOrders({
    int page = 1,
  }) async {
    try {
      final remoteOrdersResponse =
          await _remoteDataSource.getOrders(page: page);

      return Right(remoteOrdersResponse.map((model) => model as OrderEntity));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(int orderId) async {
    try {
      final orderModel = await _remoteDataSource.getOrderDetails(orderId);
      return Right(orderModel);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(int orderId) async {
    try {
      await _remoteDataSource.cancelOrder(orderId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrder(int orderId, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updateOrder(orderId, data);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(int orderId) async {
    try {
      await _remoteDataSource.deleteOrder(orderId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

