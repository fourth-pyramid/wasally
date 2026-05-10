import 'package:wassaly/core/imports/imports.dart';

class ProductSpecificationEntity extends Equatable {
  final int id;
  final String key;
  final String value;
  final String icon;

  const ProductSpecificationEntity({
    required this.id,
    required this.key,
    required this.value,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, key, value, icon];
}

class ProductDetailImageEntity extends Equatable {
  final int id;
  final String image;

  const ProductDetailImageEntity({
    required this.id,
    required this.image,
  });

  @override
  List<Object?> get props => [id, image];
}

class ProductReviewUserEntity extends Equatable {
  final int id;
  final String name;
  final String? avatar;

  const ProductReviewUserEntity({
    required this.id,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object?> get props => [id, name, avatar];
}

class ProductDetailReviewEntity extends Equatable {
  final int id;
  final int rating;
  final String comment;
  final String createdAt;
  final ProductReviewUserEntity user;

  const ProductDetailReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.user,
  });

  @override
  List<Object?> get props => [id, rating, comment, createdAt, user];
}

class ProductMetaEntity extends Equatable {
  final int id;
  final String name;
  final String image;

  const ProductMetaEntity({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}

class ProductDetailEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String price;
  final String description;
  final List<ProductSpecificationEntity> specifications;
  final List<ProductDetailImageEntity> images;
  final ProductMetaEntity? subCategory;
  final ProductMetaEntity? brand;
  final List<ProductDetailReviewEntity> reviews;
  final List<int> offerPercentages;
  final bool isFavorite;

  const ProductDetailEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.specifications,
    required this.images,
    required this.subCategory,
    required this.brand,
    required this.reviews,
    required this.offerPercentages,
    required this.isFavorite,
  });

  int get discountPercentage =>
      offerPercentages.isNotEmpty ? offerPercentages.first : 0;

  bool get hasOffer => discountPercentage > 0;

  double get discountedPrice {
    final originalPrice = double.tryParse(price) ?? 0;
    if (!hasOffer) return originalPrice;
    return originalPrice - (originalPrice * discountPercentage / 100);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        price,
        description,
        specifications,
        images,
        subCategory,
        brand,
        reviews,
        offerPercentages,
        isFavorite,
      ];
}
