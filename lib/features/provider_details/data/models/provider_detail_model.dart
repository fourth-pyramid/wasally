import 'package:wassaly/features/home/data/models/product_model.dart';
import 'package:wassaly/features/provider_details/domain/entities/provider_detail_entity.dart';
import 'package:wassaly/features/sub_category/data/models/service_model.dart';

class ProviderDetailReviewModel extends ProviderDetailReviewEntity {
  const ProviderDetailReviewModel({
    required super.rating,
    required super.comment,
    super.id,
    super.createdAt,
  });

  factory ProviderDetailReviewModel.fromJson(Map<String, dynamic> json) =>
      ProviderDetailReviewModel(
        id: json['id'] as int?,
        rating: (json['rating'] as num).toInt(),
        comment: json['comment'] as String? ?? '',
        createdAt: json['created_at'] as String?,
      );
}

class ProviderDetailUserModel extends ProviderDetailUserEntity {
  const ProviderDetailUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.type,
    required super.isActive,
    required super.createdAt,
    super.avatar,
  });

  factory ProviderDetailUserModel.fromJson(Map<String, dynamic> json) =>
      ProviderDetailUserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        avatar: json['avatar'] as String?,
        type: json['type'] as String,
        isActive: json['is_active'] as int,
        createdAt: json['created_at'] as String,
      );
}

class ProviderDetailModel extends ProviderDetailEntity {
  const ProviderDetailModel({
    required super.id,
    required super.user,
    required super.title,
    required super.serviceDescription,
    required super.priceFrom,
    required super.fromDay,
    required super.toDay,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.cover,
    required super.averageRating,
    required super.reviewsCount,
    required super.successfulOrdersCount,
    required super.reviews,
    required super.services,
    required super.products,
  });

  factory ProviderDetailModel.fromJson(Map<String, dynamic> json) =>
      ProviderDetailModel(
        id: json['id'] as int,
        user: ProviderDetailUserModel.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
        title: json['title'] as String,
        serviceDescription: json['service_description'] as String,
        priceFrom: json['price_from'] as String,
        fromDay: json['from_day'] as String,
        toDay: json['to_day'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        status: json['status'] as String,
        cover: json['cover'] as String,
        averageRating: (json['average_rating'] as num).toDouble(),
        reviewsCount: json['reviews_count'] as int,
        successfulOrdersCount: json['successful_orders_count'] as int,
        reviews: (json['reviews'] as List<dynamic>?)
                ?.map(
                  (e) => ProviderDetailReviewModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        services: (json['services'] as List<dynamic>?)
                ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        products: (json['products'] as List<dynamic>?)
                ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
