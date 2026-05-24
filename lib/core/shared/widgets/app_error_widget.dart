import 'package:wassaly/core/imports/imports.dart';

/// Displays an error state with consistent UI based on Failure type.
///
/// Usage:
/// ```dart
/// AppErrorWidget(
///   failure: failure,
///   onRetry: () => refetch(),
/// )
/// ```
class AppErrorWidget extends StatefulWidget {
  // Default constructor for backward compatibility
  const AppErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  })  : failure = const UnknownFailure('Unknown error'),
        customMessage = null,
        showRetryButton = true;

  // Legacy constructor for backward compatibility
  const AppErrorWidget.legacy({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  })  : failure = const UnknownFailure('Unknown error'),
        customMessage = null,
        showRetryButton = true;

  // New constructor with Failure
  const AppErrorWidget.failure({
    super.key,
    required this.failure,
    this.onRetry,
    this.customMessage,
    this.showRetryButton = true,
  })  : title = null,
        message = null,
        icon = Icons.error_outline_rounded;

  final Failure failure;
  final VoidCallback? onRetry;
  final String? customMessage;
  final bool showRetryButton;

  // Legacy properties for backward compatibility
  final String? title;
  final String? message;
  final IconData icon;

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  StreamSubscription<void>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    if (widget.onRetry != null) {
      _connectivitySub = sl<InternetConnectionService>()
          .connectivityRestoredStream
          .listen((_) {
        if (mounted && widget.onRetry != null) {
          widget.onRetry!();
        }
      });
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorIcon(context),
            24.h.verticalSpace,
            _buildErrorMessage(context),
            if (widget.showRetryButton && widget.onRetry != null) ...[
              32.h.verticalSpace,
              _buildRetryButton(context),
            ],
          ],
        ),
      ),
    );
  }

  bool _isNetworkError(BuildContext context) {
    if (widget.failure is NetworkFailure) return true;

    final msg = widget.message ?? widget.customMessage ?? '';
    final t = widget.title ?? '';

    if (msg == 'errors_no_internet' ||
        msg == 'errors_no_internet_message' ||
        msg == 'no_internet' ||
        msg.contains('wifi_off') ||
        msg == context.l10n.errors_no_internet ||
        msg == context.l10n.errors_no_internet_message ||
        t == context.l10n.errors_no_internet_title) {
      return true;
    }

    return false;
  }

  Widget _buildErrorIcon(BuildContext context) {
    final isIOS = context.isIOS;

    if (_isNetworkError(context)) {
      return Icon(
        isIOS ? CupertinoIcons.wifi_exclamationmark : Icons.wifi_off_rounded,
        size: 80.r,
        color: context.appColors.warning, // Semantic warning
      );
    }

    // If legacy title/message/icon were provided, respect the explicit icon
    if ((widget.title != null || widget.message != null) &&
        widget.icon != Icons.error_outline_rounded) {
      return Icon(
        widget.icon,
        size: 80.r,
        color: context.theme.colorScheme.onSurface,
      );
    }

    IconData iconData;
    Color iconColor;

    switch (widget.failure.runtimeType) {
      case const (NetworkFailure):
        iconData = isIOS
            ? CupertinoIcons.wifi_exclamationmark
            : Icons.wifi_off_rounded;
        iconColor = context.appColors.warning; // Semantic warning
        break;
      case const (NotFoundFailure):
        iconData = isIOS ? CupertinoIcons.search : Icons.search_off_rounded;
        iconColor = context.theme.colorScheme.error; // Theme error
        break;
      case const (ServerFailure):
        iconData = isIOS
            ? CupertinoIcons.exclamationmark_circle
            : Icons.error_rounded;
        iconColor = context.theme.colorScheme.error; // Theme error
        break;
      case const (CacheFailure):
        iconData = isIOS ? CupertinoIcons.doc_text : Icons.storage_rounded;
        iconColor = context.appColors.warning; // Semantic warning
        break;
      default:
        iconData = isIOS
            ? CupertinoIcons.exclamationmark_triangle
            : Icons.error_outline_rounded;
        iconColor = context.theme.colorScheme.outline; // Theme outline
    }

    return Icon(
      iconData,
      size: 80.r,
      color: iconColor,
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final bool isNetError = _isNetworkError(context);
    final titleText = isNetError
        ? context.l10n.errors_no_internet_title
        : (widget.title ?? _getErrorTitle(context));

    final rawMessage =
        widget.customMessage ?? widget.message ?? _getErrorMessage(context);
    final messageText = isNetError
        ? context.l10n.errors_no_internet_message
        : (rawMessage == 'errors_no_internet'
            ? context.l10n.errors_no_internet_message
            : rawMessage);

    return Column(
      children: [
        Text(
          titleText,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
            fontSize: 20.sp,
          ),
          textAlign: TextAlign.center,
        ),
        16.h.verticalSpace,
        Text(
          messageText,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return AppButton(
      label: context.l10n.retry,
      variant: ButtonVariant.secondary,
      height: ButtonSize.medium,
      isFullWidth: false,
      onPressed: widget.onRetry,
    );
  }

  String _getErrorTitle(BuildContext context) {
    // Respect explicit legacy title if provided
    if (widget.title != null) return widget.title!;

    switch (widget.failure.runtimeType) {
      case const (NetworkFailure):
        return context.l10n.errors_no_internet_title;
      case const (NotFoundFailure):
        return context.l10n.errors_not_found_title;
      case const (ServerFailure):
        return context.l10n.errors_server_error_title;
      case const (CacheFailure):
        return context.l10n.errors_cache_error_title;
      default:
        return context.l10n.errors_something_went_wrong;
    }
  }

  String _getErrorMessage(BuildContext context) {
    // Respect explicit legacy message if provided
    if (widget.message != null && widget.message!.isNotEmpty) {
      return widget.message!;
    }

    switch (widget.failure.runtimeType) {
      case const (NetworkFailure):
        return context.l10n.errors_no_internet_message;
      case const (NotFoundFailure):
        return context.l10n.errors_not_found_message;
      case const (ServerFailure):
        return context.l10n.errors_server_error_message;
      case const (CacheFailure):
        return context.l10n.errors_cache_error_message;
      default:
        return context.l10n.errors_error_occurred_message;
    }
  }
}
