import 'package:fpdart/fpdart.dart' hide State;
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/favorite/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, PaginatedResponse<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(int productId);
  Future<Either<Failure, void>> removeFromFavorites(int productId);
}
