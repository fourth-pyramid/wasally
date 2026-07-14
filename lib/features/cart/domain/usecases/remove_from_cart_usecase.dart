import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  const RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(int cartItemId) =>
      repository.removeFromCart(cartItemId);
}
