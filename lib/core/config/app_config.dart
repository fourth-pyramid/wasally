import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../imports/core_imports.dart';

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
          'Accept-Language': 'ar',
        },
      ),
    );

    // Bypass SSL certificate validation for development
    // WARNING: Remove for production
    configureDioForDevelopment(dio);

    // Add auth token interceptor
    _addAuthInterceptor();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info(
              '🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
              '✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.error(
              '❌ [DIO] ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
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

  static String _getBaseUrl() {
    return dotenv.get('BASE_API_URL');
  }
}
