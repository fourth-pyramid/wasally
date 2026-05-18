import 'package:wassaly/core/imports/imports.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository _repository;

  const CancelBookingUseCase(this._repository);

  Future<Either<Failure, void>> call(int bookingId) async {
    return await _repository.cancelBooking(bookingId);
  }
}
