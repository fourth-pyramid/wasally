import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../entities/brand_entity.dart';

abstract class BrandsRepository {
  Future<Either<Failure, List<BrandEntity>>> getBrands();
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> getBrandProducts({
    required int brandId,
    int page = 1,
  });
}
