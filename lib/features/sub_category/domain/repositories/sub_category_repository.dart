import 'package:wassaly/core/imports/imports.dart';

import '../entities/sub_category_detail_entity.dart';

abstract class SubCategoryRepository {
  Future<Either<Failure, SubCategoryDetailEntity>> getSubCategoryDetail(
      int subCategoryId,
      {int page = 1});
}
