import 'package:dio/dio.dart';

class AppErrorHandler {
  static String format(dynamic error) {
    if (error is String) return error;

    // Handle DioException for API error messages
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        // Extract message from API response
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
        // Extract error messages from validation errors
        if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return firstError.toString();
          }
        }
      }
      return error.message ?? 'Network error occurred';
    }

    // Handle Failure objects
    try {
      if (error?.message != null) return error.message;
      if (error?.toString() != null) return error.toString();
    } catch (_) {}

    return 'An unexpected error occurred';
  }
}
