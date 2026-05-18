import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:wassaly/features/service_booking/domain/usecases/delete_booking_usecase.dart';
import 'package:wassaly/features/service_booking/domain/usecases/update_booking_usecase.dart';
import 'booking_detail_event.dart';
import 'booking_detail_state.dart';

class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  final CancelBookingUseCase _cancelBookingUseCase;
  final UpdateBookingUseCase _updateBookingUseCase;
  final DeleteBookingUseCase _deleteBookingUseCase;
  final OrdersBloc _ordersBloc;

  BookingDetailBloc({
    required CancelBookingUseCase cancelBookingUseCase,
    required UpdateBookingUseCase updateBookingUseCase,
    required DeleteBookingUseCase deleteBookingUseCase,
    required OrdersBloc ordersBloc,
  })  : _cancelBookingUseCase = cancelBookingUseCase,
        _updateBookingUseCase = updateBookingUseCase,
        _deleteBookingUseCase = deleteBookingUseCase,
        _ordersBloc = ordersBloc,
        super(const BookingDetailState()) {
    on<InitializeBookingDetailEvent>(_onInitialize);
    on<CancelBookingEvent>(_onCancelBooking);
    on<UpdateBookingEvent>(_onUpdateBooking);
    on<DeleteBookingEvent>(_onDeleteBooking);
  }

  void _onInitialize(
    InitializeBookingDetailEvent event,
    Emitter<BookingDetailState> emit,
  ) {
    emit(state.copyWith(
      status: BookingDetailStatus.success,
      booking: event.booking,
    ));
  }

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingDetailState> emit,
  ) async {
    emit(state.copyWith(
      actionStatus: BookingActionStatus.loading,
      actionErrorMessage: '',
    ));

    final result = await _cancelBookingUseCase(event.bookingId);

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: BookingActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) {
        // Refresh bookings in OrdersBloc
        _ordersBloc.add(const GetServiceBookingsEvent());

        // Update local status to cancelled
        if (state.booking != null) {
          final updatedBooking = BookingEntity(
            id: state.booking!.id,
            status: 'cancelled',
            problemDescription: state.booking!.problemDescription,
            service: state.booking!.service,
            provider: state.booking!.provider,
            dayAr: state.booking!.dayAr,
            dayEn: state.booking!.dayEn,
            time: state.booking!.time,
            createdAt: state.booking!.createdAt,
            customerName: state.booking!.customerName,
            customerPhone: state.booking!.customerPhone,
            customerEmail: state.booking!.customerEmail,
            governorate: state.booking!.governorate,
            center: state.booking!.center,
          );
          emit(state.copyWith(
            booking: updatedBooking,
            actionStatus: BookingActionStatus.success,
          ));
        } else {
          emit(state.copyWith(actionStatus: BookingActionStatus.success));
        }
      },
    );
  }

  Future<void> _onUpdateBooking(
    UpdateBookingEvent event,
    Emitter<BookingDetailState> emit,
  ) async {
    emit(state.copyWith(
      actionStatus: BookingActionStatus.loading,
      actionErrorMessage: '',
    ));

    final result = await _updateBookingUseCase(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: BookingActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (updatedBooking) {
        // Refresh bookings in OrdersBloc
        _ordersBloc.add(const GetServiceBookingsEvent());

        emit(state.copyWith(
          booking: updatedBooking,
          actionStatus: BookingActionStatus.success,
        ));
      },
    );
  }

  Future<void> _onDeleteBooking(
    DeleteBookingEvent event,
    Emitter<BookingDetailState> emit,
  ) async {
    emit(state.copyWith(
      actionStatus: BookingActionStatus.loading,
      actionErrorMessage: '',
    ));

    final result = await _deleteBookingUseCase(event.bookingId);

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: BookingActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) {
        // Refresh bookings in OrdersBloc
        _ordersBloc.add(const GetServiceBookingsEvent());

        emit(state.copyWith(actionStatus: BookingActionStatus.success));
      },
    );
  }
}
