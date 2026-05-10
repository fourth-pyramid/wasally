import '../../domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
