import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';

class CategoryDetailEntity extends Equatable {
  final CategoryEntity category;
  final PaginatedResponse<SubCategoryEntity> subCategories;

  const CategoryDetailEntity({
    required this.category,
    required this.subCategories,
  });

  @override
  List<Object?> get props => [category, subCategories];
}
