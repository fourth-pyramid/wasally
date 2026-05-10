import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../imports/imports.dart';

class AppConfig {
  AppConfig._();
  static late final Dio dio;

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language':
              StorageService.instance.getString('app_language') ?? 'ar',
        },
      ),
    );

    // Bypass SSL certificate validation for development
    // WARNING: Remove for production
    configureDioForDevelopment(dio);

    // Add auth token interceptor
    _addAuthInterceptor();

    // Add language interceptor
    _addLanguageInterceptor();

    // Add pretty logger for detailed request/response logging
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 120,
    ));
  }

  /// Adds an interceptor that automatically attaches the Authorization header
  /// with the Bearer token from secure storage.
  static void _addAuthInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip auth for login and public endpoints
          if (_isPublicEndpoint(options.path)) {
            return handler.next(options);
          }

          // Get token from secure storage
          final tokenResult =
              await SecureStorageService.instance.read('auth_token');

          final token = tokenResult.fold(
            (failure) => null,
            (token) => token,
          );

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }

  /// Check if the endpoint is public (doesn't require auth)
  static bool _isPublicEndpoint(String path) {
    final publicPaths = [
      '/api/login',
      '/api/register',
      '/api/verify-otp',
      '/api/resend-otp',
      '/api/forget-send-otp',
      '/api/forget-verify-otp',
      '/api/reset-password',
    ];

    return publicPaths.any((publicPath) => path.contains(publicPath));
  }

  /// Adds an interceptor to set Accept-Language header based on app language
  static void _addLanguageInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final language =
              StorageService.instance.getString('app_language') ?? 'ar';
          options.headers['Accept-Language'] = language;
          return handler.next(options);
        },
      ),
    );
  }

  static String _getBaseUrl() {
    return dotenv.get('BASE_API_URL');
  }
}
