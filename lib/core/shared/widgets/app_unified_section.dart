import 'package:wassaly/core/imports/imports.dart';

class AppUnifiedSection<T> extends StatelessWidget {
  const AppUnifiedSection({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.isLoading = false,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.crossAxisCount,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.dummyItems = const [],
  });

  final List<T> items;
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    Widget Function(Widget) wrapAnimation,
  ) itemBuilder;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final List<T> dummyItems;

  // Grid properties
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final int? crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    final displayItems = isLoading && items.isEmpty ? dummyItems : items;

    final actualCrossAxisCount = crossAxisCount ??
        context.responsiveValue<int>(
          mobile: 2,
          tablet: 3,
          desktop: 4,
        );

    final actualChildAspectRatio = childAspectRatio ??
        context.responsiveValue<double?>(
          mobile: null, // Default to mainAxisExtent on mobile
          tablet: 0.75,
          desktop: 0.85,
        );

    final actualMainAxisExtent = mainAxisExtent ??
        context.responsiveValue<double?>(
          mobile: context.h(260),
        );

    return Skeletonizer.sliver(
      enabled: isLoading,
      ignoreContainers: true,
      child: SliverMainAxisGroup(
        slivers: [
          AppSliverGrid<T>(
            padding: padding ?? EdgeInsets.zero,
            childAspectRatio: actualChildAspectRatio ?? 0.65,
            mainAxisExtent: actualMainAxisExtent,
            crossAxisCount: actualCrossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            items: displayItems,
            hasMore: hasMore && !isLoadingMore && !isLoading,
            onLoadMore: onLoadMore,
            animateItems: !isLoading,
            itemBuilder: itemBuilder,
          ),
          SliverToBoxAdapter(
            child: Builder(
              builder: (context) {
                if (hasMore && !isLoadingMore && !isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onLoadMore?.call();
                  });
                }

                if (!isLoadingMore) return const SizedBox.shrink();

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(16),
                    vertical: context.h(10),
                  ),
                  child: const AppLoading(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
