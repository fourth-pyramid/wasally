import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../repositories/brands_repository.dart';

class GetBrandProductsUseCase {
  final BrandsRepository repository;

  GetBrandProductsUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<ProductEntity>>> call({
    required int brandId,
    int page = 1,
  }) {
    return repository.getBrandProducts(brandId: brandId, page: page);
  }
}
