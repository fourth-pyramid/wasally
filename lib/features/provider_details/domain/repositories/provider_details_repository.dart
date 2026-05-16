import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import '../entities/provider_detail_entity.dart';

abstract class ProviderDetailsRepository {
  Future<Either<Failure, ProviderDetailEntity>> getProviderDetails(
      int providerId);
}
