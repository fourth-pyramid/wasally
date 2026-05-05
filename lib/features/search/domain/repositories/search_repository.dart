import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> searchProducts({
    required String query,
    int page = 1,
  });
}
