import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_remote_datasource.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_local_datasource.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource localDataSource;

  const FavoriteRepositoryImpl(
      this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> getFavorites() async {
    try {
      final response = await remoteDataSource.getFavorites();
      await localDataSource.cacheProductFavorites(response.data);
      return Right(response);
    } on NetworkFailure {
      final localData = localDataSource.getCachedProductFavorites();
      return Right(PaginatedResponse(
          data: localData, currentPage: 1, lastPage: 1, total: localData.length));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<ServiceEntity>>> getServiceFavorites() async {
    try {
      final response = await remoteDataSource.getServiceFavorites();
      await localDataSource.cacheServiceFavorites(response.data);
      return Right(response);
    } on NetworkFailure {
      final localData = localDataSource.getCachedServiceFavorites();
      return Right(PaginatedResponse(
          data: localData, currentPage: 1, lastPage: 1, total: localData.length));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(int productId) async {
    try {
      await remoteDataSource.addToFavorites(productId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(int productId) async {
    try {
      await remoteDataSource.removeFromFavorites(productId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addServiceToFavorites(int serviceId) async {
    try {
      await remoteDataSource.addServiceToFavorites(serviceId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeServiceFromFavorites(int serviceId) async {
    try {
      await remoteDataSource.removeServiceFromFavorites(serviceId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
