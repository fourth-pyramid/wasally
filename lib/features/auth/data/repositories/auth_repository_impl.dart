import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:wassaly/core/services/deep_link_service.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:wassaly/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';
import 'package:wassaly/features/auth/domain/entities/forget_send_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/entities/forget_verify_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/entities/verify_otp_response_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';
import 'package:wassaly/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final CartLocalDataSource _cartDataSource;
  final FavoriteLocalDataSource _favoriteDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._cartDataSource,
    this._favoriteDataSource,
  );

  @override
  FutureEither<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginData = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save token to secure storage
      await _localDataSource.saveToken(loginData.token);

      // Cache user locally
      final userWithToken = UserModel(
        id: loginData.user.id,
        email: loginData.user.email,
        name: loginData.user.name,
        phone: loginData.user.phone,
        avatarUrl: loginData.user.avatarUrl,
        token: loginData.token,
      );
      await _localDataSource.cacheUser(userWithToken);

      return Right(userWithToken);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<UserEntity> getProfile() async {
    try {
      final token = await _localDataSource.getToken();
      if (token == null) {
        return const Left(CacheFailure('No token found'));
      }

      final user = await _remoteDataSource.getProfile(token);

      // Update cached user
      await _localDataSource.cacheUser(user);

      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<UserEntity?> getCachedUser() async {
    try {
      final user = await _localDataSource.getCachedUser();
      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<String?> getSavedToken() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAuthData();

      // Clear cart data on logout
      await _cartDataSource.clearCartLocally();

      // Clear favorites data on logout
      await _favoriteDataSource.clearFavoritesLocally();

      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> clearUserSession() async {
    try {
      // 1. Attempt remote logout — swallow errors (Req 4.1–4.4)
      try {
        await _remoteDataSource.logout();
      } on Object catch (_) {
        // Remote logout failed; log and continue with local clearing
      }

      // 2. Clear local data in sequence (Req 3.7)
      await _localDataSource.clearAuthData();
      await _cartDataSource.clearCartLocally();
      await _favoriteDataSource.clearFavoritesLocally();

      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(CacheFailure('Failed to clear user session: $e'));
    }
  }

  @override
  Future<bool> openGoogleLoginUrl() =>
      DeepLinkService.instance.openGoogleLoginUrl();

  @override
  FutureEither<UserEntity> googleLogin({
    required String token,
    required String id,
    required String fullName,
    required String email,
    String? avatar,
  }) async {
    try {
      // Save token to secure storage
      await _localDataSource.saveToken(token);

      // Create user model from Google login data
      final user = UserModel(
        id: id,
        email: email,
        name: fullName,
        avatarUrl: avatar,
        token: token,
      );

      // Cache user locally
      await _localDataSource.cacheUser(user);

      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error during Google login: $e'));
    }
  }

  @override
  FutureEither<UserEntity> signup({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    File? avatarFile,
  }) async {
    try {
      final result = await _remoteDataSource.signup(
        name: name,
        phone: phone,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        avatarFile: avatarFile,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<VerifyOtpResponseEntity> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtp(email: email, otp: otp);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> resendOtp({
    required String email,
  }) async {
    try {
      await _remoteDataSource.resendOtp(email: email);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<ForgetSendOtpResponseEntity> forgetSendOtp({
    required String email,
  }) async {
    try {
      final result = await _remoteDataSource.forgetSendOtp(email: email);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<ForgetVerifyOtpResponseEntity> forgetVerifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result =
          await _remoteDataSource.forgetVerifyOtp(email: email, otp: otp);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
