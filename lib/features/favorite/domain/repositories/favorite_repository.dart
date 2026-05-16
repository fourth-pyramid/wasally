import 'package:fpdart/fpdart.dart' hide State;
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> getFavorites();
  Future<Either<Failure, PaginatedResponse<ServiceEntity>>>
      getServiceFavorites();
  Future<Either<Failure, void>> addToFavorites(int productId);
  Future<Either<Failure, void>> removeFromFavorites(int productId);
  Future<Either<Failure, void>> addServiceToFavorites(int serviceId);
  Future<Either<Failure, void>> removeServiceFromFavorites(int serviceId);
}
