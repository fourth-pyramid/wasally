import 'package:wassaly/core/imports/imports.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class UpdateBookingUseCase {
  final BookingRepository _repository;

  const UpdateBookingUseCase(this._repository);

  Future<Either<Failure, BookingEntity>> call(UpdateBookingParams params) async {
    return await _repository.updateBooking(params);
  }
}
