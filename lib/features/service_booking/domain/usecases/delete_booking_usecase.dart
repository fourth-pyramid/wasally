import 'package:wassaly/core/imports/imports.dart';
import '../repositories/booking_repository.dart';

class DeleteBookingUseCase {
  final BookingRepository _repository;

  const DeleteBookingUseCase(this._repository);

  Future<Either<Failure, void>> call(int bookingId) async {
    return await _repository.deleteBooking(bookingId);
  }
}
