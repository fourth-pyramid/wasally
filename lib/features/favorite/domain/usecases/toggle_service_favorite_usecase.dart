import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';

/// Encapsulates the business logic of toggling a service's favorite status.
class ToggleServiceFavoriteUseCase {
  final FavoriteRepository repository;

  const ToggleServiceFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int serviceId,
    required bool isCurrentlyFavorite,
  }) {
    if (isCurrentlyFavorite) {
      return repository.removeServiceFromFavorites(serviceId);
    } else {
      return repository.addServiceToFavorites(serviceId);
    }
  }
}
