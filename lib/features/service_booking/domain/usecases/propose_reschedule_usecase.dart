import 'package:wassaly/core/imports/imports.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class ProposeRescheduleUseCase {
  final BookingRepository _repository;

  const ProposeRescheduleUseCase(this._repository);

  Future<Either<Failure, void>> call(ProposeRescheduleParams params) async {
    return await _repository.proposeReschedule(params);
  }
}
