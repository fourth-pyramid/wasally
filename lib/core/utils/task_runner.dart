import 'package:wassaly/core/services/internet_connection_service.dart';

import '../imports/imports.dart';

// Global variable to track last network error toast time
DateTime? _lastNetworkErrorToastTime;

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
    if (requiresNetwork && _isConnectionError(e)) {
      final hasNetwork = await InternetConnectionService().hasConnection();
      if (!hasNetwork) {
        AppLogger.warning('Network unavailable for task');
        _showNetworkErrorToast();
        return left(NetworkFailure('errors.no_internet'.tr()));
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

void _showNetworkErrorToast() {
  final now = DateTime.now();
  final shouldShowToast = _lastNetworkErrorToastTime == null ||
      now.difference(_lastNetworkErrorToastTime!) > const Duration(seconds: 3);

  if (shouldShowToast) {
    showGlobalToast(
      message: 'errors.no_internet'.tr(),
      status: 'warning',
    );
    _lastNetworkErrorToastTime = now;
  }
}
