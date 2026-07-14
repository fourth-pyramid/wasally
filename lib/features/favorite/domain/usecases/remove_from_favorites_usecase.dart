import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';

class RemoveFromFavoritesUseCase {
  final FavoriteRepository repository;

  const RemoveFromFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) => repository.removeFromFavorites(productId);
}
