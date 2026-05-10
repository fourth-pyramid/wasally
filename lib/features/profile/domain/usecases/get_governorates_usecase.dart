import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class GetGovernoratesUseCase {
  final ProfileRepository _repository;

  const GetGovernoratesUseCase(this._repository);

  FutureEither<List<GovernorateEntity>> call() {
    return _repository.getGovernorates();
  }
}
