import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  FutureEither<UserEntity> login({
    required String email,
    required String password,
  });

  FutureEither<UserEntity> loginWithGoogle();

  FutureEither<UserEntity> loginWithFacebook();

  FutureEither<UserEntity> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  FutureEither<void> verifyOtp({
    required String email,
    required String otp,
  });

  FutureEither<void> resendOtp({
    required String email,
  });

  FutureEither<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });
}
