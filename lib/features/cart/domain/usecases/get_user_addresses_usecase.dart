import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/usecases/get_addresses_usecase.dart';

class GetUserAddressesUseCase {
  final GetAddressesUseCase _getAddressesUseCase;

  GetUserAddressesUseCase(this._getAddressesUseCase);

  Future<Either<Failure, List<AddressEntity>>> call() async =>
      _getAddressesUseCase();
}
