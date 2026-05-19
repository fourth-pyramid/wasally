import 'package:wassaly/core/imports/imports.dart';

/// A reusable sliver grid widget for displaying products.
///
/// Features:
/// - Pagination support with [hasMore] and [onLoadMore]
/// - Customizable grid layout via [crossAxisCount], [childAspectRatio], etc.
/// - Animation support for items
/// - Built-in padding and spacing
class AppSliverGrid<T> extends StatelessWidget {
  const AppSliverGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemKey,
    this.hasMore = false,
    this.onLoadMore,
    this.padding,
    this.crossAxisCount = 2,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio = 0.61,
    this.mainAxisExtent,
    this.animateItems = true,
    this.animationDelayMultiplier = 50,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index,
      Widget Function(Widget child) wrapAnimation) itemBuilder;
  final Key Function(T item)? itemKey;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final bool animateItems;
  final int animationDelayMultiplier;
  final Duration animationDuration;

  // FIX 1: extracted كـ method — بتتعمل مرة واحدة لكل index
  // بدل ما تتعرف جوه الـ builder في كل build
  Widget _wrapAnimation(Widget child, int index) {
    if (!animateItems) return child;
    return child.animate().fadeIn(
          delay: Duration(milliseconds: animationDelayMultiplier * (index % 4)),
          duration: animationDuration,
        );
  }

  @override
  Widget build(BuildContext context) {
    // FIX 2: نحسب آخر index مرة واحدة بره الـ builder
    final lastIndex = items.length - 1;

    return SliverPadding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing ?? 6.h,
          crossAxisSpacing: crossAxisSpacing ?? 6.w,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // FIX 3: بنكال onLoadMore على index == lastIndex بالظبط
            // مش >= عشان متكالش أكتر من مرة
            if (index == lastIndex && hasMore) {
              // FIX 4: addPostFrameCallback عشان منكالش onLoadMore
              // جوه build cycle — ده كان ممكن يسبب setState during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onLoadMore?.call();
              });
            }

            final item = items[index];

            final child = itemBuilder(
              context,
              item,
              index,
              (widget) => _wrapAnimation(widget, index), // FIX 1 applied
            );

            final key = itemKey?.call(item);
            return key != null ? KeyedSubtree(key: key, child: child) : child;
          },
          childCount: items.length,
          findChildIndexCallback: itemKey != null
              ? (Key key) {
                  if (key is ValueKey) {
                    for (int i = 0; i < items.length; i++) {
                      if (itemKey!(items[i]) == key) return i;
                    }
                  }
                  return null;
                }
              : null,
        ),
      ),
    );
  }
}
