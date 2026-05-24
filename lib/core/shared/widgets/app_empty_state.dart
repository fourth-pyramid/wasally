import 'package:wassaly/core/imports/imports.dart';

/// Displays a premium empty state with an icon, title, optional subtitle, and action.
///
/// Usage:
/// ```dart
/// AppEmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No messages yet',
///   subtitle: 'Your inbox will appear here.',
///   actionLabel: 'Refresh',
///   onAction: _refresh,
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isIOS = context.isIOS;

    final displayIcon = (isIOS && icon == Icons.inbox_outlined)
        ? CupertinoIcons.tray
        : icon;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with a soft background
            Container(
              padding: EdgeInsets.all(30.r),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                displayIcon,
                size: 80.r,
                color: cs.primary.withValues(alpha: 0.4),
              ),
            )
                .animate()
                .scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack)
                .fadeIn(),

            32.verticalSpace,

            // Title
            Text(
              title,
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .slideY(begin: 0.2, duration: const Duration(milliseconds: 400))
                .fadeIn(),

            if (subtitle != null) ...[
              12.verticalSpace,
              // Subtitle
              Text(
                subtitle!,
                style: tt.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .slideY(
                      begin: 0.3,
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400))
                  .fadeIn(),
            ],

            if (actionLabel != null && onAction != null) ...[
              28.verticalSpace,
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: ButtonVariant.secondary,
              )
                  .animate()
                  .slideY(
                      begin: 0.4,
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 400))
                  .fadeIn(),
            ],
          ],
        ),
      ),
    );
  }
}
