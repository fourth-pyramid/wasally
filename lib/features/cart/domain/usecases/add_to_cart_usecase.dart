import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  const AddToCartUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity) {
    return repository.addToCart(productId, quantity);
  }
}
