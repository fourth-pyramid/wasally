import 'package:wassaly/core/imports/imports.dart';
import '../repositories/orders_repository.dart';

class DeleteOrderUseCase {
  final OrdersRepository _repository;

  const DeleteOrderUseCase(this._repository);

  Future<Either<Failure, void>> call(int orderId) async {
    return await _repository.deleteOrder(orderId);
  }
}
