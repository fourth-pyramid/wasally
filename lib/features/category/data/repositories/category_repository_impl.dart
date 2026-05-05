import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/category_detail_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  const CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CategoryDetailEntity>> getCategoryDetail(
    int categoryId, {
    int page = 1,
  }) async {
    try {
      final result =
          await _remoteDataSource.getCategoryDetail(categoryId, page: page);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
