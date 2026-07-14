import 'package:wassaly/core/imports/packages_imports.dart';

import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  const AddToCartUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity) => repository.addToCart(productId, quantity);
}
