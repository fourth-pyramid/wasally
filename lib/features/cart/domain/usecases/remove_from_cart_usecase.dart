import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  const RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(int cartItemId) {
    return repository.removeFromCart(cartItemId);
  }
}
