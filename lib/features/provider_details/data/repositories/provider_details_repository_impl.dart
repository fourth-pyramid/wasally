import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/provider_detail_entity.dart';
import '../../domain/repositories/provider_details_repository.dart';
import '../datasources/provider_details_remote_datasource.dart';

class ProviderDetailsRepositoryImpl implements ProviderDetailsRepository {
  final ProviderDetailsRemoteDataSource _remoteDataSource;

  const ProviderDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ProviderDetailEntity>> getProviderDetails(
      int providerId) async {
    try {
      final provider = await _remoteDataSource.getProviderDetails(providerId);
      return Right(provider);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
