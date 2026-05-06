import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_remote_datasource.dart';
import 'package:wassaly/features/favorite/domain/entities/favorite_entity.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  const FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<FavoriteEntity>>>
      getFavorites() async {
    try {
      final response = await remoteDataSource.getFavorites();
      return Right(response.map((model) => model.toEntity()));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(int productId) async {
    try {
      await remoteDataSource.addToFavorites(productId);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
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
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
