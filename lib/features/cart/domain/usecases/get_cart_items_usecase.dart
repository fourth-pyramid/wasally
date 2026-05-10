import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  const GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() {
    return repository.getCartItems();
  }
}
