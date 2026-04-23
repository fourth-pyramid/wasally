import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/models/forget_verify_otp_response_model.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ForgetVerifyOtpUseCase {
  final AuthRepository _repository;

  const ForgetVerifyOtpUseCase(this._repository);

  FutureEither<ForgetVerifyOtpResponseModel> call(ForgetVerifyOtpParams params) {
    return _repository.forgetVerifyOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class ForgetVerifyOtpParams {
  final String email;
  final String otp;

  const ForgetVerifyOtpParams({
    required this.email,
    required this.otp,
  });
}
