import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository _repository;

  const GetCachedUserUseCase(this._repository);

  FutureEither<UserEntity?> call() async {
    return _repository.getCachedUser();
  }
}
