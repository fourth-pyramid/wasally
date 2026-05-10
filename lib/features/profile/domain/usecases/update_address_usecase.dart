import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class UpdateAddressParams {
  final String addressId;
  final String title;
  final String address;
  final String governorateId;
  final String centerId;

  const UpdateAddressParams({
    required this.addressId,
    required this.title,
    required this.address,
    required this.governorateId,
    required this.centerId,
  });
}

class UpdateAddressUseCase {
  final ProfileRepository _repository;

  const UpdateAddressUseCase(this._repository);

  FutureEither<AddressEntity> call(UpdateAddressParams params) {
    return _repository.updateAddress(
      addressId: params.addressId,
      title: params.title,
      address: params.address,
      governorateId: params.governorateId,
      centerId: params.centerId,
    );
  }
}
