import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/search/data/datasources/search_remote_datasource.dart';
import 'package:wassaly/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  const SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> searchProducts({
    required String query,
    int page = 1,
  }) async {
    try {
      final remoteProductsResponse = await _remoteDataSource.searchProducts(
        query: query,
        page: page,
      );

      return Right(remoteProductsResponse.map((model) => model as ProductEntity));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
