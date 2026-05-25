import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/booking_entity.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(BookingParams params);
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> updateBooking(UpdateBookingParams params);
  Future<void> cancelBooking(int bookingId);
  Future<void> deleteBooking(int bookingId);
  Future<void> acceptReschedule(AcceptRescheduleParams params);
  Future<void> proposeReschedule(ProposeRescheduleParams params);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioService _dioService;

  const BookingRemoteDataSourceImpl(this._dioService);

  @override
  Future<BookingModel> createBooking(BookingParams params) async {
    final result = await _dioService.post(
      '/api/booking',
      data: params.toJson(),
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return BookingModel.fromJson(data);
      },
    );
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    final result = await _dioService.get('/api/my-bookings');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'] as List<dynamic>? ?? [];
        return data
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<BookingModel> updateBooking(UpdateBookingParams params) async {
    final result = await _dioService.put(
      '/api/booking/update',
      data: params.toJson(),
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return BookingModel.fromJson(data);
      },
    );
  }

  @override
  Future<void> cancelBooking(int bookingId) async {
    final result = await _dioService.post(
      '/api/booking/cancel',
      data: {'booking_id': bookingId},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> deleteBooking(int bookingId) async {
    final result = await _dioService.delete(
      '/api/booking/delete',
      data: {'booking_id': bookingId},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> acceptReschedule(AcceptRescheduleParams params) async {
    final result = await _dioService.post(
      '/api/customer/booking/reschedule/accept',
      data: params.toJson(),
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> proposeReschedule(ProposeRescheduleParams params) async {
    final result = await _dioService.post(
      '/api/customer/booking/reschedule/propose',
      data: params.toJson(),
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }
}
