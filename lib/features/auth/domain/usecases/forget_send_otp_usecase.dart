import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/models/forget_send_otp_response_model.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ForgetSendOtpUseCase {
  final AuthRepository _repository;

  const ForgetSendOtpUseCase(this._repository);

  FutureEither<ForgetSendOtpResponseModel> call(ForgetSendOtpParams params) {
    return _repository.forgetSendOtp(
      email: params.email,
    );
  }
}

class ForgetSendOtpParams {
  final String email;

  const ForgetSendOtpParams({
    required this.email,
  });
}
