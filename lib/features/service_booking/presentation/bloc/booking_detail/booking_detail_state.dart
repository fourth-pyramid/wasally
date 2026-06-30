import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';

enum BookingDetailStatus { initial, loading, success, failure }

enum BookingActionStatus { initial, loading, success, failure }

class BookingDetailState extends Equatable {
  final BookingDetailStatus status;
  final BookingActionStatus actionStatus;
  final BookingEntity? booking;
  final String errorMessage;
  final String actionErrorMessage;
  final List<ServiceAvailableDayEntity> availableDays;
  final bool isLoadingDays;
  final String loadDaysError;

  const BookingDetailState({
    this.status = BookingDetailStatus.initial,
    this.actionStatus = BookingActionStatus.initial,
    this.booking,
    this.errorMessage = '',
    this.actionErrorMessage = '',
    this.availableDays = const [],
    this.isLoadingDays = false,
    this.loadDaysError = '',
  });

  BookingDetailState copyWith({
    BookingDetailStatus? status,
    BookingActionStatus? actionStatus,
    BookingEntity? booking,
    String? errorMessage,
    String? actionErrorMessage,
    List<ServiceAvailableDayEntity>? availableDays,
    bool? isLoadingDays,
    String? loadDaysError,
  }) => BookingDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      availableDays: availableDays ?? this.availableDays,
      isLoadingDays: isLoadingDays ?? this.isLoadingDays,
      loadDaysError: loadDaysError ?? this.loadDaysError,
    );

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        booking,
        errorMessage,
        actionErrorMessage,
        availableDays,
        isLoadingDays,
        loadDaysError,
      ];
}
