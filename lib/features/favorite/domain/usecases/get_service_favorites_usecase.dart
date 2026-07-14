import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class GetServiceFavoritesUseCase {
  final FavoriteRepository repository;

  GetServiceFavoritesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<ServiceEntity>>> call(
      {int page = 1,}) => repository.getServiceFavorites(page: page);
}
