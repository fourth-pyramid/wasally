import 'package:wassaly/core/imports/imports.dart';

/// A themed card widget with consistent padding, radius, and optional header.
///
/// Usage:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
/// )
///
/// // With a header
/// AppCard(
///   title: 'Recent Transactions',
///   trailing: TextButton(onPressed: _seeAll, child: const Text('See all')),
///   child: TransactionList(),
/// )
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
    this.margin,
    this.onTap,
    this.showShadow = false,
    this.color,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  /// When true, uses [AppShadows.card] instead of a border outline.
  final bool showShadow;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final cardColor = color ?? cs.surfaceContainerLow;

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || leading != null || trailing != null)
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              top: 12.h,
            ),
            child: Row(
              children: [
                if (leading != null) ...[leading!, 12.horizontalSpace],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        Padding(
          padding: padding ??
              EdgeInsets.fromLTRB(
                12.w,
                title == null ? 12.h : 0,
                12.w,
                12.h,
              ),
          child: child,
        ),
      ],
    );

    final isIOS = context.isIOS;

    final cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border:
            showShadow ? null : Border.all(color: cs.outlineVariant, width: 1),
        boxShadow: showShadow
            ? []
            : [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.05),
                  blurRadius: 4.r,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (onTap == null) return cardWidget;

    if (isIOS) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: cardWidget,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: cardWidget,
    );
  }
}
