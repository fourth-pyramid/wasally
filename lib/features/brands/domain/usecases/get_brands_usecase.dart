import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../entities/brand_entity.dart';
import '../repositories/brands_repository.dart';

class GetBrandsUseCase {
  final BrandsRepository repository;

  GetBrandsUseCase(this.repository);

  Future<Either<Failure, List<BrandEntity>>> call() {
    return repository.getBrands();
  }
}
