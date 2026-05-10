import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(int cartItemId, int quantity) {
    return repository.updateQuantity(cartItemId, quantity);
  }
}
