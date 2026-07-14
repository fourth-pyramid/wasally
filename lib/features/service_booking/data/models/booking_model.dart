import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class BookingProviderModel extends BookingProviderEntity {
  const BookingProviderModel({
    required super.id,
    required super.name,
    super.avatar,
    super.description,
    super.rating,
    super.reviewsCount,
  });

  factory BookingProviderModel.fromJson(Map<String, dynamic> json) =>
      BookingProviderModel(
        id: json['id'] as int,
        name: (json['title'] ?? json['name'] ?? '') as String,
        avatar: (json['cover'] ?? json['avatar']) as String?,
        description: json['service_description'] as String?,
        rating: (json['average_rating'] as num?)?.toDouble(),
        reviewsCount: json['reviews_count'] as int?,
      );
}

class BookingServiceModel extends BookingServiceEntity {
  const BookingServiceModel({
    required super.id,
    required super.name,
    required super.price, super.image,
    super.description,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) =>
      BookingServiceModel(
        id: json['id'] as int,
        name: (json['service'] ?? json['name'] ?? '') as String,
        image: (json['image'] ?? json['cover']) as String?,
        description: json['description'] as String?,
        price: json['price'] as num,
      );
}

class RescheduleDetailsModel extends RescheduleDetailsEntity {
  const RescheduleDetailsModel({
    super.suggestedDayId,
    super.suggestedDayAr,
    super.suggestedDayEn,
    super.suggestedTimeId,
    super.suggestedTime,
    super.rescheduleNote,
  });

  factory RescheduleDetailsModel.fromJson(Map<String, dynamic> json) {
    final dayMap = json['suggested_day'] as Map<String, dynamic>?;
    final timeMap = json['suggested_time'] as Map<String, dynamic>?;
    return RescheduleDetailsModel(
      suggestedDayId: dayMap?['id'] as int?,
      suggestedDayAr: dayMap?['name_ar'] as String?,
      suggestedDayEn: dayMap?['name_en'] as String?,
      suggestedTimeId: timeMap?['id'] as int?,
      suggestedTime: timeMap?['time'] as String?,
      rescheduleNote: json['reschedule_note'] as String?,
    );
  }
}

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.status,
    required super.problemDescription,
    required super.service,
    required super.provider,
    required super.dayAr,
    required super.dayEn,
    required super.time,
    required super.createdAt,
    required super.customerName,
    required super.customerPhone,
    super.customerEmail,
    super.governorate,
    super.center,
    super.rescheduleDetails,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Handle available_day object
    var dayAr = '';
    var dayEn = '';
    if (json['available_day'] is Map) {
      final dayMap = json['available_day'] as Map<String, dynamic>;
      dayAr = (dayMap['name_ar'] ?? '') as String;
      dayEn = (dayMap['name_en'] ?? '') as String;
    } else if (json['day'] is String) {
      final dayStr = json['day'] as String;
      final parsedDate = dayStr.toLocalDateTime();
      if (parsedDate != null) {
        dayAr = DateFormat('EEEE, d MMMM yyyy', 'ar').format(parsedDate);
        dayEn = DateFormat('EEEE, d MMMM yyyy', 'en').format(parsedDate);
      } else {
        // If it's a weekday name, translate/map it
        final lowerInput = dayStr.trim().toLowerCase();
        const weekdayEnToAr = {
          'monday': 'الإثنين',
          'tuesday': 'الثلاثاء',
          'wednesday': 'الأربعاء',
          'thursday': 'الخميس',
          'friday': 'الجمعة',
          'saturday': 'السبت',
          'sunday': 'الأحد',
        };
        const weekdayArToEn = {
          'الإثنين': 'Monday',
          'الاثنين': 'Monday',
          'الثلاثاء': 'Tuesday',
          'الأربعاء': 'Wednesday',
          'الاربعاء': 'Wednesday',
          'الخميس': 'Thursday',
          'الجمعة': 'Friday',
          'السبت': 'Saturday',
          'الأحد': 'Sunday',
          'الاحد': 'Sunday',
        };

        if (weekdayEnToAr.containsKey(lowerInput)) {
          dayAr = weekdayEnToAr[lowerInput]!;
          dayEn = dayStr.isNotEmpty
              ? '${dayStr[0].toUpperCase()}${dayStr.substring(1).toLowerCase()}'
              : '';
        } else if (weekdayArToEn.containsKey(dayStr.trim())) {
          dayAr = dayStr;
          dayEn = weekdayArToEn[dayStr.trim()]!;
        } else {
          dayAr = dayStr;
          dayEn = dayStr;
        }
      }
    }

    // Handle available_time object
    var timeStr = '';
    if (json['available_time'] is Map) {
      final timeMap = json['available_time'] as Map<String, dynamic>;
      timeStr = (timeMap['time'] ?? '') as String;
    } else if (json['time'] is String) {
      timeStr = json['time'] as String;
    }

    final rescheduleJson = json['reschedule_details'] as Map<String, dynamic>?;

    return BookingModel(
      id: json['id'] as int,
      status: (json['status'] ?? 'pending') as String,
      problemDescription: json['problem_description'] as String? ?? '',
      service:
          BookingServiceModel.fromJson(json['service'] as Map<String, dynamic>),
      provider: BookingProviderModel.fromJson(
          json['provider'] as Map<String, dynamic>,),
      dayAr: dayAr,
      dayEn: dayEn,
      time: timeStr,
      createdAt: (json['created_at'] ?? '') as String,
      customerName: (json['customer_name'] ?? '') as String,
      customerPhone: (json['customer_phone'] ?? '') as String,
      customerEmail: json['customer_email'] as String?,
      governorate: json['governorate'] != null
          ? (json['governorate'] as Map<String, dynamic>)['name'] as String?
          : null,
      center: json['center'] != null
          ? (json['center'] as Map<String, dynamic>)['name'] as String?
          : null,
      rescheduleDetails: rescheduleJson != null
          ? RescheduleDetailsModel.fromJson(rescheduleJson)
          : null,
    );
  }
}
