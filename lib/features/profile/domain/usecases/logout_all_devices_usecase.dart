import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class LogoutAllDevicesUseCase {
  final ProfileRepository _repository;

  const LogoutAllDevicesUseCase(this._repository);

  FutureEither<void> call() {
    return _repository.logoutAllDevices();
  }
}
