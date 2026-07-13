import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/imports/imports.dart';

// ponytail: Showcase.withWidget with full-width tooltip to prevent overflow
class AppShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;
  final bool isLast;

  const AppShowcase({
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ponytail: Only register the global key if this route is currently active/topmost.
    // This prevents duplicate GlobalKey exceptions when the same screen class is pushed multiple times.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return child;
    }

    final margin = EdgeInsets.symmetric(horizontal: 16.w);
    // ponytail: width matches screen minus margins so _getSpace() clamps correctly
    final tooltipWidth = MediaQuery.sizeOf(context).width - margin.horizontal;

    return Showcase.withWidget(
      key: showcaseKey,
      height: 150.h,
      width: tooltipWidth,
      disableDefaultTargetGestures: true,
      toolTipMargin: margin,
      container: _AppShowcaseTooltip(
        title: title,
        description: description,
        isLast: isLast,
        showcaseContext: context,
        maxWidth: tooltipWidth,
      ),
      child: child,
    );
  }
}

class _AppShowcaseTooltip extends StatelessWidget {
  final String title;
  final String description;
  final bool isLast;
  final BuildContext showcaseContext;
  final double maxWidth;

  const _AppShowcaseTooltip({
    required this.title,
    required this.description,
    required this.showcaseContext,
    required this.maxWidth,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    // ponytail: ConstrainedBox ensures the container never exceeds the width
    // that Showcase.withWidget uses for positioning
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            6.verticalSpace,
            Text(
              description,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () =>
                      ShowCaseWidget.of(showcaseContext).dismiss(),
                  child: Text(
                    context.l10n.shared_skip,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
                8.horizontalSpace,
                ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      ShowCaseWidget.of(showcaseContext).dismiss();
                    } else {
                      ShowCaseWidget.of(showcaseContext).next();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text(
                    isLast
                        ? context.l10n.shared_finish
                        : context.l10n.shared_next,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
