import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';

/// Encapsulates the business logic of toggling a product's favorite status.
///
/// Given a [productId] and the [isCurrentlyFavorite] flag, delegates to the
/// appropriate repository method (add or remove) and returns the result.
/// This keeps the decision-making inside the domain layer rather than
/// spreading it across the UI.
class ToggleFavoriteUseCase {
  final FavoriteRepository repository;

  const ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int productId,
    required bool isCurrentlyFavorite,
  }) {
    if (isCurrentlyFavorite) {
      return repository.removeFromFavorites(productId);
    } else {
      return repository.addToFavorites(productId);
    }
  }
}
