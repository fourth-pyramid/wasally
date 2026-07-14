import 'dart:async';

import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/utils.dart';

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
    required this.status,
    this.avatar,
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

  bool _isInitialized = false;

  /// Initialize deep link listening
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.info('DeepLinkService already initialized, skipping.');
      return;
    }
    _isInitialized = true;

    // Handle app launched from terminated state with deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } on Object catch (e) {
      AppLogger.error('Error getting initial deep link: $e');
    }

    // Listen for deep links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (Object err) {
        AppLogger.error('Deep link stream error: $err');
      },
    );

    AppLogger.info('DeepLinkService initialized');
  }

  /// Dispose the service
  void dispose() {
    unawaited(_linkSubscription?.cancel());
    _linkSubscription = null;
    unawaited(_callbackController.close());
    _isInitialized = false;
    AppLogger.info('DeepLinkService disposed');
  }

  /// Handle incoming deep link URI
  void _handleDeepLink(Uri uri) {
    AppLogger.info('🔔 Received deep link: $uri');

    final internalRoute = getRouteForDeepLink(uri);
    if (internalRoute != null) {
      AppLogger.info(
        '✅ Valid deep link detected, internal route: $internalRoute',
      );

      // Parse data for any listeners (like GoogleLoginBloc)
      final callbackData = _parseAuthCallback(uri);
      if (callbackData != null) {
        _callbackController.add(callbackData);
      }
    } else {
      AppLogger.info('⚠️ Deep link does not match any handled pattern');
    }
  }

  /// Transforms a raw deep link into an internal app route.
  /// Used by GoRouter's redirect logic.
  String? getRouteForDeepLink(Uri uri) {
    // Check for auth callback (wasly://auth/callback or https://wasly.bynona.store/auth/callback)
    if ((uri.scheme == 'wasly' &&
            uri.host == 'auth' &&
            uri.path == '/callback') ||
        (uri.host == 'wasly.bynona.store' && uri.path == '/auth/callback')) {
      // Fix potential encoding issues in query parameters
      final queryParams = _getFixedQueryParams(uri);

      // Build internal route with query parameters
      final internalUri = Uri(
        path: '/auth/callback', // AppRoutes.authCallback
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return internalUri.toString();
    }

    return null;
  }

  /// Extracts and fixes query parameters from a URI
  Map<String, String> _getFixedQueryParams(Uri uri) {
    // Fix HTML encoding in query parameters (&amp; -> &) if present in raw query
    final fixedQuery = uri.query.replaceAll('&amp;', '&');
    final tempUri = Uri.parse('http://temp.com/?$fixedQuery');
    final rawParams = tempUri.queryParameters;

    final params = <String, String>{};

    // Normalize parameter names (backend sends 'user_id', we might want 'id')
    if (rawParams['token'] != null) params['token'] = rawParams['token']!;
    if (rawParams['user_id'] != null) params['id'] = rawParams['user_id']!;
    if (rawParams['id'] != null) params['id'] = rawParams['id']!;
    if (rawParams['full_name'] != null) {
      params['full_name'] = rawParams['full_name']!;
    }
    if (rawParams['email'] != null) params['email'] = rawParams['email']!;
    if (rawParams['avatar'] != null) params['avatar'] = rawParams['avatar']!;
    if (rawParams['status'] != null) params['status'] = rawParams['status']!;

    return params;
  }

  /// Parse auth callback URI into GoogleLoginCallbackData
  GoogleLoginCallbackData? _parseAuthCallback(Uri uri) {
    try {
      final queryParams = _getFixedQueryParams(uri);

      final token = queryParams['token'];
      final id = queryParams['id'];
      final fullName = queryParams['full_name'];
      final email = queryParams['email'];
      final avatar = queryParams['avatar'];
      final status = queryParams['status'] ?? 'unknown';

      if (token == null || id == null || fullName == null || email == null) {
        return null;
      }

      return GoogleLoginCallbackData(
        token: token,
        id: id,
        fullName: fullName,
        email: email,
        avatar: avatar,
        status: status,
      );
    } on Object catch (e) {
      AppLogger.error('❌ Error parsing auth callback: $e');
      return null;
    }
  }

  /// Open Google login URL in external browser
  Future<bool> openGoogleLoginUrl() async {
    const googleLoginUrl =
        'https://wasly.bynona.store/api/auth/google/redirect?platform=mobile';
    final uri = Uri.parse(googleLoginUrl);

    try {
      // Try to launch directly without canLaunchUrl check
      // (canLaunchUrl is unreliable on Android for HTTPS URLs)
      final result = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      AppLogger.info('Launched Google login URL: $result');
      return result;
    } on Object catch (e) {
      AppLogger.error('Error launching Google login URL: $e');
      return false;
    }
  }
}
