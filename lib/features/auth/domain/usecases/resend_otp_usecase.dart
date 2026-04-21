import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository _repository;

  const ResendOtpUseCase(this._repository);

  FutureEither<void> call(ResendOtpParams params) {
    return _repository.resendOtp(
      email: params.email,
    );
  }
}

class ResendOtpParams {
  final String email;

  const ResendOtpParams({
    required this.email,
  });
}
