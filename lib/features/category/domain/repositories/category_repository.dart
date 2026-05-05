import 'package:wassaly/core/imports/imports.dart';

import '../entities/category_detail_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoryDetailEntity>> getCategoryDetail(
    int categoryId, {
    int page = 1,
  });
}
