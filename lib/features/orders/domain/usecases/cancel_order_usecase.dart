import 'package:wassaly/core/imports/imports.dart';
import '../repositories/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository _repository;

  const CancelOrderUseCase(this._repository);

  Future<Either<Failure, void>> call(int orderId) async {
    return await _repository.cancelOrder(orderId);
  }
}
