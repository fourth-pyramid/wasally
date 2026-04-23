import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class GetSavedTokenUseCase {
  final AuthRepository _repository;

  const GetSavedTokenUseCase(this._repository);

  FutureEither<String?> call() {
    return _repository.getSavedToken();
  }
}
