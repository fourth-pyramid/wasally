import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';

/// Data class representing Google login callback from deep link
class GoogleLoginCallbackData {
  final String token;
  final String id;
  final String fullName;
  final String email;
  final String? avatar;
  final String status;

  const GoogleLoginCallbackData({
    required this.token,
    required this.id,
    required this.fullName,
    required this.email,
    this.avatar,
    required this.status,
  });

  bool get isSuccess => status == 'success';
}

/// Service to handle deep links for OAuth callbacks
class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  final _callbackController =
      StreamController<GoogleLoginCallbackData?>.broadcast();

  /// Stream of Google login callback data
  Stream<GoogleLoginCallbackData?> get callbackStream =>
      _callbackController.stream;

  /// Initialize deep link listening
  Future<void> initialize() async {
    // Handle app launched from terminated state with deep link
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      AppLogger.error('Error getting initial deep link: $e');
    }

    // Listen for deep links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (err) {
        AppLogger.error('Deep link stream error: $err');
      },
    );

    AppLogger.info('DeepLinkService initialized');
  }

  /// Dispose the service
  void dispose() {
    _linkSubscription?.cancel();
    _callbackController.close();
    AppLogger.info('DeepLinkService disposed');
  }

  /// Handle incoming deep link URI
  void _handleDeepLink(Uri uri) {
    AppLogger.info('🔔 Received deep link: $uri');
    AppLogger.info(
        '   Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');
    AppLogger.info('   Query params: ${uri.queryParameters}');

    // Check if this is an auth callback
    if (uri.scheme == 'wasly' && uri.host == 'auth') {
      AppLogger.info('✅ Auth callback detected');
      if (uri.path == '/callback') {
        final callbackData = _parseAuthCallback(uri);
        _callbackController.add(callbackData);
      }
    } else {
      AppLogger.info('⚠️ Deep link does not match auth callback pattern');
    }
  }

  /// Parse auth callback URI into GoogleLoginCallbackData
  GoogleLoginCallbackData? _parseAuthCallback(Uri uri) {
    try {
      final queryParams = uri.queryParameters;

      final token = queryParams['token'];
      // Backend sends 'user_id' but we need 'id' internally
      final id = queryParams['user_id'] ?? queryParams['id'];
      final fullName = queryParams['full_name'];
      final email = queryParams['email'];
      final avatar = queryParams['avatar'];
      final status = queryParams['status'] ?? 'unknown';

      AppLogger.info(
          '🔍 Parsing auth callback - token: $token, id: $id, email: $email');

      if (token == null || id == null || fullName == null || email == null) {
        AppLogger.error(
            '❌ Missing required parameters in auth callback: $queryParams');
        return null;
      }

      AppLogger.info('✅ Auth callback parsed successfully');
      return GoogleLoginCallbackData(
        token: token,
        id: id,
        fullName: fullName,
        email: email,
        avatar: avatar,
        status: status,
      );
    } catch (e) {
      AppLogger.error('❌ Error parsing auth callback: $e');
      return null;
    }
  }

  /// Open Google login URL in external browser
  Future<bool> openGoogleLoginUrl() async {
    const String googleLoginUrl =
        'https://wasly.bynona.store/api/auth/google/redirect?platform=mobile';
    final Uri uri = Uri.parse(googleLoginUrl);

    try {
      // Try to launch directly without canLaunchUrl check
      // (canLaunchUrl is unreliable on Android for HTTPS URLs)
      final result = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      AppLogger.info('Launched Google login URL: $result');
      return result;
    } catch (e) {
      AppLogger.error('Error launching Google login URL: $e');
      return false;
    }
  }
}
