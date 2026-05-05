import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/data/models/forget_send_otp_response_model.dart';
import 'package:wassaly/features/auth/data/models/forget_verify_otp_response_model.dart';
import 'package:wassaly/features/auth/data/models/login_response_model.dart';
import 'package:wassaly/features/auth/data/models/register_response_model.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';
import 'package:wassaly/features/auth/data/models/verify_otp_request_model.dart';
import 'package:wassaly/features/auth/data/models/verify_otp_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginData> login({
    required String email,
    required String password,
  });

  Future<UserModel> getProfile(String token);

  Future<UserModel> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    File? avatarFile,
  });

  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resendOtp({
    required String email,
  });

  Future<ForgetSendOtpResponseModel> forgetSendOtp({
    required String email,
  });

  Future<ForgetVerifyOtpResponseModel> forgetVerifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioService _dioService;

  const AuthRemoteDataSourceImpl(this._dioService);

  @override
  Future<LoginData> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioService.post(
      '/api/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final loginResponse = LoginResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        final data = loginResponse.data;
        if (data == null) {
          throw ServerFailure(loginResponse.message);
        }

        return data;
      },
    );
  }

  @override
  Future<UserModel> getProfile(String token) async {
    final response = await _dioService.get(
      '/api/show-profile',
      queryParameters: {},
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          throw const ServerFailure('Invalid response data');
        }

        return UserModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    File? avatarFile,
  }) async {
    // Build form data for multipart request
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'full_name': name,
      'type': 'user',
      'phone': phone,
      if (avatarFile != null)
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
    });

    final response = await _dioService.post(
      '/api/register',
      data: formData,
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final registerResponse = RegisterResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (!registerResponse.status) {
          throw ServerFailure(registerResponse.message);
        }

        final data = registerResponse.data;
        if (data == null) {
          throw const ServerFailure('Invalid response data');
        }

        return UserModel(
          id: data.id.toString(),
          email: data.email,
          name: data.fullName,
          phone: data.phone,
          avatarUrl: null,
          token: null,
        );
      },
    );
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    // Validate inputs before API call
    if (email.isEmpty) {
      throw const ServerFailure('Email is required');
    }
    if (otp.length != 6) {
      throw const ServerFailure('OTP must be 6 digits');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      throw const ServerFailure('Invalid OTP format');
    }

    final requestModel = VerifyOtpRequestModel(
      email: email,
      code: otp,
    );

    final result = await _dioService.post(
      '/api/verify-otp',
      data: requestModel.toJson(),
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        // Handle case where response.data might be a List or Map
        dynamic rawData = response.data;

        // Unwrap nested lists
        while (rawData is List && rawData.isNotEmpty) {
          rawData = rawData.first;
        }

        if (rawData is! Map<String, dynamic>) {
          throw const ServerFailure('Invalid response format');
        }

        final verifyResponse = VerifyOtpResponseModel.fromJson(rawData);

        if (!verifyResponse.status) {
          throw ServerFailure(verifyResponse.message);
        }

        return verifyResponse;
      },
    );
  }

  @override
  Future<void> resendOtp({
    required String email,
  }) async {
    if (email.isEmpty) {
      throw const ServerFailure('Email is required');
    }

    // Resend OTP using the register endpoint or dedicated resend endpoint
    // Using a dedicated endpoint if available, otherwise this would call the backend resend API
    final result = await _dioService.post(
      '/api/resend-otp',
      data: {'email': email},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<ForgetSendOtpResponseModel> forgetSendOtp({
    required String email,
  }) async {
    final result = await _dioService.post(
      '/api/forget-send-otp',
      data: {'email': email},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        dynamic rawData = response.data;

        while (rawData is List && rawData.isNotEmpty) {
          rawData = rawData.first;
        }

        if (rawData is! Map<String, dynamic>) {
          throw const ServerFailure('Invalid response format');
        }

        final forgetResponse = ForgetSendOtpResponseModel.fromJson(rawData);

        if (!forgetResponse.status) {
          throw ServerFailure(forgetResponse.message);
        }

        return forgetResponse;
      },
    );
  }

  @override
  Future<ForgetVerifyOtpResponseModel> forgetVerifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await _dioService.post(
      '/api/forget-verify-otp',
      data: {
        'email': email,
        'code': otp,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        dynamic rawData = response.data;

        while (rawData is List && rawData.isNotEmpty) {
          rawData = rawData.first;
        }

        if (rawData is! Map<String, dynamic>) {
          throw const ServerFailure('Invalid response format');
        }

        final verifyResponse = ForgetVerifyOtpResponseModel.fromJson(rawData);

        if (!verifyResponse.status) {
          throw ServerFailure(verifyResponse.message);
        }

        return verifyResponse;
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _dioService.post(
      '/api/reset-password',
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> logout() async {
    final result = await _dioService.post('/api/logout');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }
}
