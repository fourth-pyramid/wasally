import 'package:wassaly/core/imports/imports.dart';

/// A reusable sliver grid widget for displaying products.
///
/// Features:
/// - Pagination support with [hasMore] and [onLoadMore]
/// - Customizable grid layout via [crossAxisCount], [childAspectRatio], etc.
/// - Animation support for items
/// - Built-in padding and spacing
class SliverProductGrid<T> extends StatelessWidget {
  const SliverProductGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.hasMore = false,
    this.onLoadMore,
    this.padding,
    this.crossAxisCount = 2,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 0.61,
    this.animateItems = true,
    this.animationDelayMultiplier = 50,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  /// List of items to display
  final List<T> items;

  /// Builder function to create a widget for each item
  /// Provides the item, index, and optional animation wrapper
  final Widget Function(BuildContext context, T item, int index,
      Widget Function(Widget child) wrapAnimation) itemBuilder;

  /// Whether there are more items to load (pagination)
  final bool hasMore;

  /// Callback when reaching the end of the list for pagination
  final VoidCallback? onLoadMore;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Number of columns in the grid
  final int crossAxisCount;

  /// Vertical spacing between items
  final double? mainAxisSpacing;

  /// Horizontal spacing between items
  final double? crossAxisSpacing;

  /// Ratio of width to height for each item
  final double childAspectRatio;

  /// Whether to animate items as they appear
  final bool animateItems;

  /// Delay multiplier for staggered animation (ms per item index modulo)
  final int animationDelayMultiplier;

  /// Duration of the fade-in animation
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing ?? 6.h,
          crossAxisSpacing: crossAxisSpacing ?? 6.w,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Trigger load more when reaching the end
            if (index >= items.length - 1 && hasMore) {
              onLoadMore?.call();
            }

            final item = items[index];

            Widget wrapAnimation(Widget child) {
              if (!animateItems) return child;
              return child.animate().fadeIn(
                    delay: Duration(
                        milliseconds: animationDelayMultiplier * (index % 4)),
                    duration: animationDuration,
                  );
            }

            return itemBuilder(context, item, index, wrapAnimation);
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
