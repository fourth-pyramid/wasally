import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/forget_send_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class ForgetSendOtpUseCase {
  final AuthRepository _repository;

  const ForgetSendOtpUseCase(this._repository);

  FutureEither<ForgetSendOtpResponseEntity> call(ForgetSendOtpParams params) => _repository.forgetSendOtp(
      email: params.email,
    );
}

class ForgetSendOtpParams {
  final String email;

  const ForgetSendOtpParams({
    required this.email,
  });
}
