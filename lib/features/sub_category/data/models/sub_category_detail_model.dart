import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/data/models/product_model.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

import '../../domain/entities/sub_category_detail_entity.dart';
import 'service_model.dart';

class SubCategoryDetailModel extends SubCategoryDetailEntity {
  const SubCategoryDetailModel({
    required super.id,
    required super.name,
    required super.image,
    required super.services,
    required super.products,
  });

  factory SubCategoryDetailModel.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? pagination,
  }) {
    final productsList = (json['products'] as List<dynamic>?)
            ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SubCategoryDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      products: PaginatedResponse<ProductEntity>(
        data: productsList,
        currentPage: pagination?['current_page'] as int? ?? 1,
        lastPage: pagination?['last_page'] as int? ?? 1,
        total: pagination?['total'] as int? ?? productsList.length,
      ),
    );
  }
}
