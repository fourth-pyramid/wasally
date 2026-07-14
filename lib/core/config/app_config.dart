import 'package:wassaly/core/imports/imports.dart';

class AppConfig {
  AppConfig._();

  static late final Dio dio;
  static late final String baseUrl;

  /// In-memory cache for the auth token so we avoid hitting SecureStorage
  /// (Keychain / Keystore) on every single HTTP request.
  static String? _cachedToken;

  /// Call after login / token refresh to update the in-memory cache.
  static set cachedToken(String? token) => _cachedToken = token;

  /// Call on logout to clear the cached token.
  static void clearCachedToken() => _cachedToken = null;

  static Future<void> init() async {
    baseUrl = _getBaseUrl();

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': StorageService.instance.getString('app_language') ?? 'ar',
        },
      ),
    );

    // Development configurations
    if (kDebugMode) {
      configureDioForDevelopment(dio);
    }

    // Interceptors order is important
    _addCancelTokenInterceptor();
    _addAuthInterceptor();
    _addLanguageInterceptor();
    _addStabilityInterceptor();
  }

  static void _addCancelTokenInterceptor() {
    dio.interceptors.add(sl<CancelTokenInterceptor>());
  }

  /// Measures latency on every Dio request
  static void _addStabilityInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _reportLatency(response.requestOptions);
          return handler.next(response);
        },
        onError: (e, handler) {
          _reportLatency(e.requestOptions);
          return handler.next(e);
        },
      ),
    );
  }

  static void _reportLatency(RequestOptions options) {
    final startTime = options.extra['startTime'] as int?;
    if (startTime == null) return;

    final latency = DateTime.now().millisecondsSinceEpoch - startTime;
    sl<InternetConnectionService>().reportLatency(latency);
  }

  /// Automatically attaches the Authorization Bearer token.
  ///
  /// Uses an in-memory [_cachedToken] to avoid reading from SecureStorage
  /// (a full Keychain/Keystore round-trip) on every single HTTP request.
  /// Falls back to SecureStorage only once when the cache is cold.
  static void _addAuthInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isPublicEndpoint(options.path)) {
            return handler.next(options);
          }

          _cachedToken ??= await const FlutterSecureStorage().read(key: 'auth_token');

          if (_cachedToken != null && _cachedToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }

          return handler.next(options);
        },
      ),
    );
  }

  static bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/api/login',
      '/api/register',
      '/api/verify-otp',
      '/api/resend-otp',
      '/api/forget-send-otp',
      '/api/forget-verify-otp',
      '/api/reset-password',
    ];

    return publicPaths.any((public) => path.contains(public));
  }

  /// Keeps Accept-Language header updated
  static void _addLanguageInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final language = StorageService.instance.getString('app_language') ?? 'ar';
          options.headers['Accept-Language'] = language;
          return handler.next(options);
        },
      ),
    );
  }

  static String _getBaseUrl() => dotenv.get('BASE_API_URL');
}
