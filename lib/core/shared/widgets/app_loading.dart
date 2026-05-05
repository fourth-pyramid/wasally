import 'package:wassaly/core/imports/imports.dart';

/// Centered loading indicator using the primary colour from the theme.
///
/// Usage:
/// ```dart
/// // Simple inline loader
/// const AppLoading()
///
/// // Full-screen loader with message
/// AppLoading(message: 'Fetching data...')
/// ```
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message,
    this.size = 28,
    this.strokeWidth = 3,
  });

  final String? message;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final isIOS = context.isIOS;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: isIOS
                ? CupertinoActivityIndicator(
                    color: cs.primary,
                    radius: size / 2,
                  )
                : CircularProgressIndicator(
                    strokeWidth: strokeWidth,
                    color: cs.primary,
                  ),
          ),
          if (message != null) ...[
            16.verticalSpace,
            Text(
              message!,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
