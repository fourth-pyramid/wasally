import '../../domain/entities/product_detail_entity.dart';

class ProductSpecificationModel extends ProductSpecificationEntity {
  const ProductSpecificationModel({
    required super.id,
    required super.key,
    required super.value,
    required super.icon,
  });

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecificationModel(
      id: json['id'] as int? ?? 0,
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

class ProductDetailImageModel extends ProductDetailImageEntity {
  const ProductDetailImageModel({
    required super.id,
    required super.image,
  });

  factory ProductDetailImageModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailImageModel(
      id: json['id'] as int? ?? 0,
      image: json['image'] as String? ?? '',
    );
  }
}

class ProductReviewUserModel extends ProductReviewUserEntity {
  const ProductReviewUserModel({
    required super.id,
    required super.name,
    required super.avatar,
  });

  factory ProductReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }
}

class ProductDetailReviewModel extends ProductDetailReviewEntity {
  const ProductDetailReviewModel({
    required super.id,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.user,
  });

  factory ProductDetailReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailReviewModel(
      id: json['id'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      user: ProductReviewUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ProductMetaModel extends ProductMetaEntity {
  const ProductMetaModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory ProductMetaModel.fromJson(Map<String, dynamic> json) {
    return ProductMetaModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class ProductDetailModel extends ProductDetailEntity {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.description,
    required super.specifications,
    required super.images,
    required super.subCategory,
    required super.brand,
    required super.reviews,
    required super.offerPercentages,
    required super.isFavorite,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price']?.toString() ?? '0',
      description: json['description'] as String? ?? '',
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => ProductSpecificationModel.fromJson(e))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductDetailImageModel.fromJson(e))
              .toList() ??
          [],
      subCategory: json['sub_category'] == null
          ? null
          : ProductMetaModel.fromJson(
              json['sub_category'] as Map<String, dynamic>,
            ),
      brand: json['brand'] == null
          ? null
          : ProductMetaModel.fromJson(
              json['brand'] as Map<String, dynamic>,
            ),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ProductDetailReviewModel.fromJson(e))
              .toList() ??
          [],
      offerPercentages: (json['offers'] as List<dynamic>?)
              ?.map((e) =>
                  int.tryParse(
                    ((e as Map<String, dynamic>)['discount_percentage'])
                            ?.toString() ??
                        '',
                  ) ??
                  0)
              .where((e) => e > 0)
              .toList() ??
          [],
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }
}
