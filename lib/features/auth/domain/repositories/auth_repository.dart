import 'dart:io';

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

  /// Open Google login URL in external browser
  Future<bool> openGoogleLoginUrl();

  /// Complete Google login with callback data from deep link
  FutureEither<UserEntity> googleLogin({
    required String token,
    required String id,
    required String fullName,
    required String email,
    String? avatar,
  });

  FutureEither<UserEntity> getProfile();

  FutureEither<UserEntity?> getCachedUser();

  FutureEither<String?> getSavedToken();

  FutureEither<void> logout();

  FutureEither<UserEntity> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    File? avatarFile,
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
