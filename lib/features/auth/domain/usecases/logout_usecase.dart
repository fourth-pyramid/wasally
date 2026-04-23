import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  FutureEither<void> call() {
    return _repository.logout();
  }
}
