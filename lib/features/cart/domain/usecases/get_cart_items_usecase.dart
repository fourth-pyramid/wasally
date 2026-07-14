import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  const GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() =>
      repository.getCartItems();
}
