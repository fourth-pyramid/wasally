import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithFacebook();

  Future<UserModel> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resendOtp({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // TODO: Inject Dio client here when API is ready
  // final Dio _dio;
  // const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with actual API call
    // Simulating network delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock success response
    if (email.isNotEmpty && password.length >= 6) {
      return UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        phone: '+1234567890',
        avatarUrl: null,
        token: 'mock_token_12345',
      );
    }

    throw const ServerFailure('Invalid credentials');
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: 'google_1',
      email: 'user@gmail.com',
      name: 'Google User',
      phone: null,
      avatarUrl: null,
      token: 'google_mock_token',
    );
  }

  @override
  Future<UserModel> loginWithFacebook() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: 'fb_1',
      email: 'user@facebook.com',
      name: 'Facebook User',
      phone: null,
      avatarUrl: null,
      token: 'fb_mock_token',
    );
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        password.length >= 6) {
      return UserModel(
        id: 'new_user_1',
        email: email,
        name: name,
        phone: phone,
        avatarUrl: null,
        token: 'mock_signup_token_12345',
      );
    }

    throw const ServerFailure('Invalid signup data');
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock validation: OTP must be 6 digits and email must not be empty
    if (email.isEmpty) {
      throw const ServerFailure('Email is required');
    }
    if (otp.length != 6) {
      throw const ServerFailure('OTP must be 6 digits');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      throw const ServerFailure('Invalid OTP format');
    }

    // Mock success - simulate 123456 as valid OTP
    if (otp != '123456') {
      throw const ServerFailure('Invalid OTP code');
    }
  }

  @override
  Future<void> resendOtp({
    required String email,
  }) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(seconds: 1));

    if (email.isEmpty) {
      throw const ServerFailure('Email is required');
    }

    // Mock success - OTP would be resent
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(seconds: 1));

    if (email.isEmpty) {
      throw const ServerFailure('Email is required');
    }
    if (newPassword.length < 8) {
      throw const ServerFailure('Password must be at least 8 characters');
    }
    if (otp.length != 6) {
      throw const ServerFailure('Invalid OTP');
    }

    // Mock success - password would be reset
  }
}
