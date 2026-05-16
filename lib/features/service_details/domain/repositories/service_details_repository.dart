import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../entities/service_detail_entity.dart';

abstract class ServiceDetailsRepository {
  Future<Either<Failure, ServiceDetailEntity>> getServiceDetails(int serviceId);
  Future<Either<Failure, bool>> toggleServiceFavorite(
      int serviceId, bool isCurrentlyFavorite);
}
