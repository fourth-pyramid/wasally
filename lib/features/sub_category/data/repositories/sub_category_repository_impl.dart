import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/sub_category_detail_entity.dart';
import '../../domain/repositories/sub_category_repository.dart';
import '../datasources/sub_category_remote_datasource.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final SubCategoryRemoteDataSource _remoteDataSource;

  const SubCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SubCategoryDetailEntity>> getSubCategoryDetail(
      int subCategoryId,
      {int page = 1}) async {
    try {
      final result = await _remoteDataSource.getSubCategoryDetail(subCategoryId,
          page: page);
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
