import 'package:wassaly/core/imports/imports.dart';
import '../entities/banner_entity.dart';
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';
import '../entities/sub_category_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<SubCategoryEntity>>> getPopularServices();
  Future<Either<Failure, PaginatedResponse<ProductEntity>>> getProducts(
      {int page = 1});
}
