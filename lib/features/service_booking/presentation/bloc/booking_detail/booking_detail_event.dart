import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';


abstract class BookingDetailEvent extends Equatable {
  const BookingDetailEvent();

  @override
  List<Object?> get props => [];
}

class InitializeBookingDetailEvent extends BookingDetailEvent {
  final BookingEntity booking;

  const InitializeBookingDetailEvent(this.booking);

  @override
  List<Object?> get props => [booking];
}

class CancelBookingEvent extends BookingDetailEvent {
  final int bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class UpdateBookingEvent extends BookingDetailEvent {
  final UpdateBookingParams params;

  const UpdateBookingEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class DeleteBookingEvent extends BookingDetailEvent {
  final int bookingId;

  const DeleteBookingEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
