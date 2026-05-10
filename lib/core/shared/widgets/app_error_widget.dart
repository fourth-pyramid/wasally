import 'package:wassaly/core/imports/imports.dart';

/// Displays an error state with an icon, title, optional body, and retry button.
///
/// Usage:
/// ```dart
/// AppErrorWidget(
///   title: 'Something went wrong',
///   message: error.toString(),
///   onRetry: () => ref.invalidate(myProvider),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  AppErrorWidget({
    super.key,
    String? title,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  }) : title = title ?? 'errors.something_went_wrong'.tr();

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: cs.error),
            16.verticalSpace,
            Text(
              title,
              style: tt.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              8.verticalSpace,
              Text(
                message!,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              24.verticalSpace,
              AppButton(
                label: 'errors.try_again'.tr(),
                onPressed: onRetry,
                variant: ButtonVariant.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
