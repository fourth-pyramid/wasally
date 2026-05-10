import 'package:wassaly/core/imports/imports.dart';

import '../entities/category_detail_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryDetailUseCase {
  final CategoryRepository repository;

  GetCategoryDetailUseCase(this.repository);

  Future<Either<Failure, CategoryDetailEntity>> call(int categoryId,
      {int page = 1}) async {
    return await repository.getCategoryDetail(categoryId, page: page);
  }
}
