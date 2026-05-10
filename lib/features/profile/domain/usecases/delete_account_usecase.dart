import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository _repository;

  const DeleteAccountUseCase(this._repository);

  FutureEither<void> call() {
    return _repository.deleteAccount();
  }
}
