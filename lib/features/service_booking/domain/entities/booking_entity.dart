import 'package:intl/intl.dart';
import 'package:wassaly/core/imports/imports.dart';

class RescheduleDetailsEntity extends Equatable {
  final int? suggestedDayId;
  final String? suggestedDayAr;
  final String? suggestedDayEn;
  final int? suggestedTimeId;
  final String? suggestedTime;
  final String? rescheduleNote;

  const RescheduleDetailsEntity({
    this.suggestedDayId,
    this.suggestedDayAr,
    this.suggestedDayEn,
    this.suggestedTimeId,
    this.suggestedTime,
    this.rescheduleNote,
  });

  String get suggestedDay =>
      Intl.getCurrentLocale() == 'ar'
          ? (suggestedDayAr ?? '')
          : (suggestedDayEn ?? '');

  @override
  List<Object?> get props => [
        suggestedDayId,
        suggestedDayAr,
        suggestedDayEn,
        suggestedTimeId,
        suggestedTime,
        rescheduleNote,
      ];
}

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
  final RescheduleDetailsEntity? rescheduleDetails;

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
    this.rescheduleDetails,
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
        rescheduleDetails,
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

class UpdateBookingParams extends Equatable {
  final int bookingId;
  final String problemDescription;
  final String customerPhone;

  const UpdateBookingParams({
    required this.bookingId,
    required this.problemDescription,
    required this.customerPhone,
  });

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId,
        'problem_description': problemDescription,
        'customer_phone': customerPhone,
      };

  @override
  List<Object?> get props => [bookingId, problemDescription, customerPhone];
}

class AcceptRescheduleParams extends Equatable {
  final int bookingId;

  const AcceptRescheduleParams({required this.bookingId});

  Map<String, dynamic> toJson() => {'booking_id': bookingId};

  @override
  List<Object?> get props => [bookingId];
}

class ProposeRescheduleParams extends Equatable {
  final int bookingId;
  final int suggestedDayId;
  final int suggestedTimeId;
  final String rescheduleNote;

  const ProposeRescheduleParams({
    required this.bookingId,
    required this.suggestedDayId,
    required this.suggestedTimeId,
    required this.rescheduleNote,
  });

  Map<String, dynamic> toJson() => {
        'booking_id': bookingId,
        'suggested_day_id': suggestedDayId,
        'suggested_time': suggestedTimeId,
        'reschedule_note': rescheduleNote,
      };

  @override
  List<Object?> get props =>
      [bookingId, suggestedDayId, suggestedTimeId, rescheduleNote];
}
