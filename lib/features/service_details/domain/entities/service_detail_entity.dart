import 'package:wassaly/core/imports/imports.dart';

class ServiceReviewUserEntity extends Equatable {
  final int id;
  final String name;
  final String? avatar;
  final String type;

  const ServiceReviewUserEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, avatar, type];
}

class ServiceDetailReviewEntity extends Equatable {
  final int id;
  final int rating;
  final String comment;
  final String createdAt;
  final ServiceReviewUserEntity user;

  const ServiceDetailReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.user,
  });

  @override
  List<Object?> get props => [id, rating, comment, createdAt, user];
}

class ServiceAvailableTimeEntity extends Equatable {
  final int id;
  final String time;

  const ServiceAvailableTimeEntity({
    required this.id,
    required this.time,
  });

  String get displayTime => time.to12HourFormat();

  @override
  List<Object?> get props => [id, time];
}

class ServiceAvailableDayEntity extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final List<ServiceAvailableTimeEntity> availableTimes;

  const ServiceAvailableDayEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.availableTimes,
  });

  @override
  List<Object?> get props => [id, nameAr, nameEn, availableTimes];
}

class ServiceProviderUserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String type;
  final int isActive;

  const ServiceProviderUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.type,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar, type, isActive];
}

class ServiceProviderEntity extends Equatable {
  final int id;
  final ServiceProviderUserEntity user;
  final String title;
  final String serviceDescription;
  final String cover;
  final double averageRating;
  final int reviewsCount;
  final int successfulOrdersCount;

  const ServiceProviderEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.serviceDescription,
    required this.cover,
    required this.averageRating,
    required this.reviewsCount,
    required this.successfulOrdersCount,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        title,
        serviceDescription,
        cover,
        averageRating,
        reviewsCount,
        successfulOrdersCount,
      ];
}

class ServiceDetailEntity extends Equatable {
  final int id;
  final String service;
  final String description;
  final String? category;
  final String image;
  final List<String> images;
  final num price;
  final ServiceProviderEntity provider;
  final List<ServiceAvailableDayEntity> availableDays;
  final List<ServiceDetailReviewEntity> reviews;
  final bool isFavorite;

  const ServiceDetailEntity({
    required this.id,
    required this.service,
    required this.description,
    required this.category,
    required this.image,
    required this.images,
    required this.price,
    required this.provider,
    required this.availableDays,
    required this.reviews,
    required this.isFavorite,
  });

  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
  }

  ServiceDetailEntity copyWith({
    int? id,
    String? service,
    String? description,
    String? category,
    String? image,
    List<String>? images,
    num? price,
    ServiceProviderEntity? provider,
    List<ServiceAvailableDayEntity>? availableDays,
    List<ServiceDetailReviewEntity>? reviews,
    bool? isFavorite,
  }) {
    return ServiceDetailEntity(
      id: id ?? this.id,
      service: service ?? this.service,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      images: images ?? this.images,
      price: price ?? this.price,
      provider: provider ?? this.provider,
      availableDays: availableDays ?? this.availableDays,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        service,
        description,
        category,
        image,
        images,
        price,
        provider,
        availableDays,
        reviews,
        isFavorite,
      ];
}
