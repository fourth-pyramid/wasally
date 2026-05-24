import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../imports/imports.dart';

class AppConfig {
  AppConfig._();

  static late final Dio dio;
  static late final String baseUrl;

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
          'Accept-Language':
              StorageService.instance.getString('app_language') ?? 'ar',
        },
      ),
    );

    // Development configurations
    if (kDebugMode) {
      configureDioForDevelopment(dio);
    }

    // Interceptors order is important
    _addAuthInterceptor();
    _addLanguageInterceptor();
    _addStabilityInterceptor();

    // Logger should be the last interceptor
    _addLoggerInterceptor();
  }

  static void _addLoggerInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
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
        onError: (DioException e, handler) {
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

  /// Automatically attaches the Authorization Bearer token
  static void _addAuthInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isPublicEndpoint(options.path)) {
            return handler.next(options);
          }

          final tokenResult =
              await SecureStorageService.instance.read('auth_token');
          final token = tokenResult.fold((_) => null, (t) => t);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
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
