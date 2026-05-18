import 'package:wassaly/core/imports/imports.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderParams {
  final int orderId;
  final Map<String, dynamic> data;

  const UpdateOrderParams({
    required this.orderId,
    required this.data,
  });
}

class UpdateOrderUseCase {
  final OrdersRepository _repository;

  const UpdateOrderUseCase(this._repository);

  Future<Either<Failure, void>> call(UpdateOrderParams params) async {
    return await _repository.updateOrder(params.orderId, params.data);
  }
}
