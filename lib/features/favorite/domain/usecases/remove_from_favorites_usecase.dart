import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:fpdart/fpdart.dart' hide State;

class RemoveFromFavoritesUseCase {
  final FavoriteRepository repository;

  const RemoveFromFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) {
    return repository.removeFromFavorites(productId);
  }
}
