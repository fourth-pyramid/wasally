import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  FutureEither<void> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      email: params.email,
      token: params.token,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });
}
