import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final remoteBanners = await _remoteDataSource.getBanners();
      return Right(remoteBanners);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final remoteCategories = await _remoteDataSource.getCategories();
      return Right(remoteCategories.map((e) => e as CategoryEntity).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<SubCategoryEntity>>>
      getPopularServices({int page = 1}) async {
    try {
      final remoteServicesResponse =
          await _remoteDataSource.getPopularServices(page: page);
      return Right(
          remoteServicesResponse.map((model) => model as SubCategoryEntity));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> getProducts({
    int page = 1,
  }) async {
    try {
      final remoteProductsResponse =
          await _remoteDataSource.getProducts(page: page);

      return Right(
          remoteProductsResponse.map((model) => model as ProductEntity));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
