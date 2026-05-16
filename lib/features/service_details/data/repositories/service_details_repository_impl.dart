import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/service_detail_entity.dart';
import '../../domain/repositories/service_details_repository.dart';
import '../datasources/service_details_remote_datasource.dart';

class ServiceDetailsRepositoryImpl implements ServiceDetailsRepository {
  final ServiceDetailsRemoteDataSource _remoteDataSource;

  const ServiceDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ServiceDetailEntity>> getServiceDetails(
      int serviceId) async {
    try {
      final service = await _remoteDataSource.getServiceDetails(serviceId);
      return Right(service);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleServiceFavorite(
      int serviceId, bool isCurrentlyFavorite) async {
    try {
      if (isCurrentlyFavorite) {
        await _remoteDataSource.removeServiceFromFavorites(serviceId);
        return const Right(false);
      } else {
        await _remoteDataSource.addServiceToFavorites(serviceId);
        return const Right(true);
      }
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
