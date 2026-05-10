import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class CreateAddressParams {
  final String title;
  final String address;
  final String governorateId;
  final String centerId;

  const CreateAddressParams({
    required this.title,
    required this.address,
    required this.governorateId,
    required this.centerId,
  });
}

class CreateAddressUseCase {
  final ProfileRepository _repository;

  const CreateAddressUseCase(this._repository);

  FutureEither<AddressEntity> call(CreateAddressParams params) {
    return _repository.createAddress(
      title: params.title,
      address: params.address,
      governorateId: params.governorateId,
      centerId: params.centerId,
    );
  }
}
