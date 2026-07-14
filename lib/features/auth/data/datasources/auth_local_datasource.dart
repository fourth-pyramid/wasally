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
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  const AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      AppConfig.cachedToken = token;
      AppLogger.info('Token saved to secure storage');
    } on Object catch (e) {
      throw ServerFailure('Failed to save token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    AppConfig.clearCachedToken();
    try {
      await _secureStorage.delete(key: _tokenKey);
      AppLogger.info('Token deleted from secure storage');
    } on Object catch (e) {
      throw ServerFailure('Failed to delete token: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    try {
      await _secureStorage.write(key: _userKey, value: userJson);
      AppLogger.info('User cached in secure storage');
    } on Object catch (e) {
      AppLogger.error('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      if (userJson == null) return null;
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } on Object catch (e) {
      AppLogger.error('Error parsing cached user: $e');
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await deleteToken();
    try {
      await _secureStorage.delete(key: _userKey);
      AppLogger.info('All auth data cleared from secure storage');
    } on Object catch (e) {
      AppLogger.error('Failed to clear user cache: $e');
    }
  }
}
