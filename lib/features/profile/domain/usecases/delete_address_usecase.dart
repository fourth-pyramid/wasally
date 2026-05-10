import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class DeleteAddressParams {
  final String addressId;

  const DeleteAddressParams({required this.addressId});
}

class DeleteAddressUseCase {
  final ProfileRepository _repository;

  const DeleteAddressUseCase(this._repository);

  FutureEither<void> call(DeleteAddressParams params) {
    return _repository.deleteAddress(addressId: params.addressId);
  }
}
