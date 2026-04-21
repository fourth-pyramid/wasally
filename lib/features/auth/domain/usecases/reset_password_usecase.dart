import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  FutureEither<void> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      email: params.email,
      newPassword: params.newPassword,
      otp: params.otp,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String newPassword;
  final String otp;

  const ResetPasswordParams({
    required this.email,
    required this.newPassword,
    required this.otp,
  });
}
