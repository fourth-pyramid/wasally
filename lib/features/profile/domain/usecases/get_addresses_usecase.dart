import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class GetAddressesUseCase {
  final ProfileRepository _repository;

  const GetAddressesUseCase(this._repository);

  FutureEither<List<AddressEntity>> call() {
    return _repository.getAddresses();
  }
}
