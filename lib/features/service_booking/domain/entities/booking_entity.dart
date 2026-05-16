import 'package:intl/intl.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

class BookingProviderEntity extends Equatable {
  final int id;
  final String name;
  final String? avatar;
  final String? description;
  final double? rating;
  final int? reviewsCount;

  const BookingProviderEntity({
    required this.id,
    required this.name,
    this.avatar,
    this.description,
    this.rating,
    this.reviewsCount,
  });

  @override
  List<Object?> get props =>
      [id, name, avatar, description, rating, reviewsCount];
}

class BookingServiceEntity extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String? description;
  final num price;

  const BookingServiceEntity({
    required this.id,
    required this.name,
    this.image,
    this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, description, price];
}

class BookingEntity extends Equatable {
  final int id;
  final String status;
  final String problemDescription;
  final BookingServiceEntity service;
  final BookingProviderEntity provider;
  final String dayAr;
  final String dayEn;
  final String time;
  final String createdAt;
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final String? governorate;
  final String? center;

  const BookingEntity({
    required this.id,
    required this.status,
    required this.problemDescription,
    required this.service,
    required this.provider,
    required this.dayAr,
    required this.dayEn,
    required this.time,
    required this.createdAt,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    this.governorate,
    this.center,
  });

  String get day => Intl.getCurrentLocale() == 'ar' ? dayAr : dayEn;

  @override
  List<Object?> get props => [
        id,
        status,
        problemDescription,
        service,
        provider,
        dayAr,
        dayEn,
        time,
        createdAt,
        customerName,
        customerPhone,
        customerEmail,
        governorate,
        center,
      ];
}

class BookingParams extends Equatable {
  final int serviceId;
  final int availableDayId;
  final int availableTimeId;
  final String problemDescription;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String governorateId;
  final String centerId;

  const BookingParams({
    required this.serviceId,
    required this.availableDayId,
    required this.availableTimeId,
    required this.problemDescription,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.governorateId,
    required this.centerId,
  });

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'available_day_id': availableDayId,
        'available_time_id': availableTimeId,
        'problem_description': problemDescription,
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail,
        'governorate_id': governorateId,
        'center_id': centerId,
      };

  @override
  List<Object?> get props => [
        serviceId,
        availableDayId,
        availableTimeId,
        problemDescription,
        customerName,
        customerPhone,
        customerEmail,
        governorateId,
        centerId,
      ];
}
