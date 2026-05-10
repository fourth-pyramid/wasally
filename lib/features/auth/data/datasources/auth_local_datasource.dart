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

  /// Cache user data locally
  Future<void> cacheUser(UserModel user);

  /// Get cached user data
  Future<UserModel?> getCachedUser();

  /// Clear all cached auth data
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;
  final StorageService _storage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  const AuthLocalDataSourceImpl(this._secureStorage, this._storage);

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
    await _storage.setString(_userKey, userJson);
    AppLogger.info('User cached locally');
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = _storage.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      AppLogger.error('Error parsing cached user: $e');
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await deleteToken();
    await _storage.remove(_userKey);
    AppLogger.info('All auth data cleared');
  }
}
