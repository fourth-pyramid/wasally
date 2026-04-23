import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/models/forget_send_otp_response_model.dart';
import 'package:wassaly/features/auth/data/models/forget_verify_otp_response_model.dart';
import 'package:wassaly/features/auth/data/models/verify_otp_response_model.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  FutureEither<UserEntity> login({
    required String email,
    required String password,
  });

  FutureEither<UserEntity> getProfile();

  FutureEither<String?> getSavedToken();

  FutureEither<void> logout();

  FutureEither<UserEntity> loginWithGoogle();

  FutureEither<UserEntity> loginWithFacebook();

  FutureEither<UserEntity> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  });

  FutureEither<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
  });

  FutureEither<void> resendOtp({
    required String email,
  });

  FutureEither<ForgetSendOtpResponseModel> forgetSendOtp({
    required String email,
  });

  FutureEither<ForgetVerifyOtpResponseModel> forgetVerifyOtp({
    required String email,
    required String otp,
  });

  FutureEither<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
}
