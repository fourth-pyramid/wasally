import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';

class AppErrorHandler {
  static String format(dynamic error) {
    if (error is String) return error;

    // Handle DioException for API error messages
    if (error is DioException) {
      // Handle 404 Not Found specifically
      if (error.response?.statusCode == 404) {
        return 'الخدمة غير متوفرة حالياً، يرجى المحاولة لاحقاً';
      }

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
      if (error is Map && error['message'] != null) {
        return error['message'].toString();
      }
      // If it's an object with a message property (like our Failure class)
      if (error is Failure) {
        return error.message;
      }
      if (error?.toString() != null) return error.toString();
    } on Object catch (_) {}

    return 'An unexpected error occurred';
  }
}
