import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/verify_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  FutureEither<VerifyOtpResponseEntity> call(VerifyOtpParams params) => _repository.verifyOtp(
      email: params.email,
      otp: params.otp,
    );
}

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({
    required this.email,
    required this.otp,
  });
}
