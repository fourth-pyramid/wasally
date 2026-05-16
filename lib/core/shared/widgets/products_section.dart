import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class AppProductsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  
  // Grid properties
  final double childAspectRatio;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const AppProductsSection({
    super.key,
    required this.products,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.childAspectRatio = 0.65,
    this.mainAxisExtent,
    this.crossAxisCount = 2,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        AppSliverGrid<ProductEntity>(
          padding: padding ?? EdgeInsets.zero,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          items: products,
          hasMore: hasMore && !isLoadingMore,
          onLoadMore: onLoadMore,
          itemBuilder: (context, product, index, wrapAnimation) {
            return wrapAnimation(
              ProductCard(
                product: product,
              ),
            );
          },
        ),
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
