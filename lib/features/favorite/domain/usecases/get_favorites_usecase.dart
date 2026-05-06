import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/favorite/domain/entities/favorite_entity.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:fpdart/fpdart.dart' hide State;

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  const GetFavoritesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<FavoriteEntity>>> call() {
    return repository.getFavorites();
  }
}
