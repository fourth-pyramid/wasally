import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/entities/order_entity.dart';
import 'package:wassaly/features/cart/domain/entities/place_order_params.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class PlaceOrderUseCase {
  final CartRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) =>
      _repository.placeOrder(params);
}
