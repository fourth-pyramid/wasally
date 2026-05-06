import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:fpdart/fpdart.dart' hide State;

class AddToFavoritesUseCase {
  final FavoriteRepository repository;

  const AddToFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) {
    return repository.addToFavorites(productId);
  }
}
