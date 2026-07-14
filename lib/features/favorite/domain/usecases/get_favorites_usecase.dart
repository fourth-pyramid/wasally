import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  const GetFavoritesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<ProductEntity>>> call(
      {int page = 1,}) => repository.getFavorites(page: page);
}
