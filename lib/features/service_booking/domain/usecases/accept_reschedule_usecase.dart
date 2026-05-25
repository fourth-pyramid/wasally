import 'package:wassaly/core/imports/imports.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class AcceptRescheduleUseCase {
  final BookingRepository _repository;

  const AcceptRescheduleUseCase(this._repository);

  Future<Either<Failure, void>> call(AcceptRescheduleParams params) async {
    return await _repository.acceptReschedule(params);
  }
}
