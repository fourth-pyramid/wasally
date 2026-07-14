import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(int cartItemId, int quantity) =>
      repository.updateQuantity(cartItemId, quantity);
}
