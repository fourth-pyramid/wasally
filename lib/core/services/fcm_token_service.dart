import 'dart:async';
import 'dart:io';

import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/domain/usecases/register_fcm_token_usecase.dart';

class FcmTokenService {
  FcmTokenService._();
  static final FcmTokenService instance = FcmTokenService._();

  late RegisterFcmTokenUseCase _registerFcmTokenUseCase;

  /// Must be called once after DI is initialized.
  set useCase(RegisterFcmTokenUseCase value) {
    _registerFcmTokenUseCase = value;
  }

  /// Fetches FCM token + device ID and registers them with the backend.
  /// Errors are swallowed — this must never block the login flow.
  Future<void> registerToken(int userId) async {
    try {
      String? token;
      var retryCount = 0;
      const maxRetries = 3;

      while (token == null && retryCount < maxRetries) {
        if (retryCount > 0) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }

        token = await FirebaseMessaging.instance.getToken();
        retryCount++;
      }

      if (token == null) {
        return;
      }

      final deviceId = await _getDeviceId();

      // ponytail: removed _logger
      await _registerFcmTokenUseCase(
        FcmTokenParams(token: token, deviceId: deviceId, userId: userId),
      );
    } on Object catch (_) {
      // ponytail: swallowed error
    }
  }

  StreamSubscription<String>? _tokenRefreshSubscription;

  /// Listens to token refresh events and re-registers with the backend.
  void setupTokenRefresh(int userId) {
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) async {
        // ponytail: removed _logger
        final deviceId = await _getDeviceId();

        await _registerFcmTokenUseCase(
          FcmTokenParams(token: newToken, deviceId: deviceId, userId: userId),
        );
      },
      onError: (Object _) {},
    );
  }

  /// Cancels the token refresh listener (e.g. on logout).
  void cancelTokenRefresh() {
    // ponytail: removed _logger
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = null;
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        return info.id;
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        return info.identifierForVendor ?? 'unknown-ios';
      }
    } on Object catch (_) {}
    return 'unknown-device';
  }
}
