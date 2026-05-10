import 'package:wassaly/core/imports/imports.dart';

import '../entities/product_detail_entity.dart';
import '../repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository _repository;

  const GetProductDetailsUseCase(this._repository);

  Future<Either<Failure, ProductDetailEntity>> call(int productId) {
    return _repository.getProductDetails(productId);
  }
}
