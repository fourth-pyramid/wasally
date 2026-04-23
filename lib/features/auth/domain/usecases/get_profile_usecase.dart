import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;

  const GetProfileUseCase(this._repository);

  FutureEither<UserEntity> call() {
    return _repository.getProfile();
  }
}
