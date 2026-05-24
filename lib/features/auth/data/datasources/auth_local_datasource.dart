import 'dart:convert';

import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Save token to secure storage
  Future<void> saveToken(String token);

  /// Get token from secure storage
  Future<String?> getToken();

  /// Delete token from secure storage
  Future<void> deleteToken();

  /// Cache user data locally (secure storage)
  Future<void> cacheUser(UserModel user);

  /// Get cached user data
  Future<UserModel?> getCachedUser();

  /// Clear all cached auth data
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  const AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    final result = await _secureStorage.write(_tokenKey, token);
    result.fold(
      (failure) => throw failure,
      (_) => AppLogger.info('Token saved to secure storage'),
    );
  }

  @override
  Future<String?> getToken() async {
    final result = await _secureStorage.read(_tokenKey);
    return result.fold(
      (failure) => null,
      (token) => token,
    );
  }

  @override
  Future<void> deleteToken() async {
    final result = await _secureStorage.delete(_tokenKey);
    result.fold(
      (failure) => throw failure,
      (_) => AppLogger.info('Token deleted from secure storage'),
    );
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    final result = await _secureStorage.write(_userKey, userJson);
    result.fold(
      (failure) => AppLogger.error('Failed to cache user: ${failure.message}'),
      (_) => AppLogger.info('User cached in secure storage'),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final result = await _secureStorage.read(_userKey);
    return result.fold(
      (failure) => null,
      (userJson) {
        if (userJson == null) return null;
        try {
          final userMap = jsonDecode(userJson) as Map<String, dynamic>;
          return UserModel.fromJson(userMap);
        } catch (e) {
          AppLogger.error('Error parsing cached user: $e');
          return null;
        }
      },
    );
  }

  @override
  Future<void> clearAuthData() async {
    await deleteToken();
    final result = await _secureStorage.delete(_userKey);
    result.fold(
      (failure) => AppLogger.error('Failed to clear user cache: ${failure.message}'),
      (_) => AppLogger.info('All auth data cleared from secure storage'),
    );
  }
}
