import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/entities/center_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class GetCentersParams {
  final String governorateId;

  const GetCentersParams(this.governorateId);
}

class GetCentersUseCase {
  final ProfileRepository _repository;

  const GetCentersUseCase(this._repository);

  FutureEither<List<CenterEntity>> call(GetCentersParams params) {
    return _repository.getCenters(governorateId: params.governorateId);
  }
}
