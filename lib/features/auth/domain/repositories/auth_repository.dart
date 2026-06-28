import 'dart:io';

import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/forget_send_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/entities/forget_verify_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/entities/verify_otp_response_entity.dart';

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

  /// Clears all user-specific local data (token, user cache, cart, favorites).
  /// Must succeed even if the remote logout API fails.
  FutureEither<void> clearUserSession();

  FutureEither<UserEntity> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    File? avatarFile,
  });

  FutureEither<VerifyOtpResponseEntity> verifyOtp({
    required String email,
    required String otp,
  });

  FutureEither<void> resendOtp({
    required String email,
  });

  FutureEither<ForgetSendOtpResponseEntity> forgetSendOtp({
    required String email,
  });

  FutureEither<ForgetVerifyOtpResponseEntity> forgetVerifyOtp({
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
