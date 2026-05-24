import 'package:wassaly/core/imports/imports.dart';

/// A reusable generic function to handle potential exceptions in async tasks
/// and map them to the [Either] type matching [FutureEither<T>].
///
/// If [requiresNetwork] is `true` and the action fails with a connection error,
/// a secondary connectivity check is performed to distinguish between
/// "no internet" and "server down" scenarios.
FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  try {
    final result = await action();
    return right(result);
  } on DioException catch (e) {
    // Handle 404 Not Found specifically
    if (e.response?.statusCode == 404) {
      final errorMessage = AppErrorHandler.format(e);
      return left(NotFoundFailure(errorMessage, error: e));
    }

    if (requiresNetwork && _isConnectionError(e)) {
      // Timeout added to prevent blocking when internet_connection_checker_plus
      // takes too long (5-30s) to confirm no internet via HTTP checks.
      final hasNetwork = await InternetConnectionService()
          .hasConnection()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => false,
          );
      if (!hasNetwork) {
        AppLogger.warning('Network unavailable for task');
        // Don't show toast here - let the UI handle the error display
        return left(const NetworkFailure('errors_no_internet'));
      }
    }
    final errorMessage = AppErrorHandler.format(e);
    return left(ServerFailure(errorMessage, error: e));
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed $error', [error, stackTrace]);
    final errorMessage = AppErrorHandler.format(error);
    return left(ServerFailure(errorMessage, error: error));
  }
}

bool _isConnectionError(DioException e) {
  return e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout;
}
