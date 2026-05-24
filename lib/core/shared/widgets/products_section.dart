import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class AppProductsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final bool isLoading;

  // Grid properties
  final double childAspectRatio;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  static const _dummyProducts = [
    ProductEntity(
      id: 1,
      name: 'منتج تجريبي طويل جدا للتجربة',
      image: '',
      price: '100.00',
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      offers: [],
      reviews: [],
      isFavorite: false,
    ),
    ProductEntity(
      id: 2,
      name: 'منتج تجريبي طويل جدا للتجربة',
      image: '',
      price: '100.00',
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      offers: [],
      reviews: [],
      isFavorite: false,
    ),
    ProductEntity(
      id: 3,
      name: 'منتج تجريبي طويل جدا للتجربة',
      image: '',
      price: '100.00',
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      offers: [],
      reviews: [],
      isFavorite: false,
    ),
    ProductEntity(
      id: 4,
      name: 'منتج تجريبي طويل جدا للتجربة',
      image: '',
      price: '100.00',
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      offers: [],
      reviews: [],
      isFavorite: false,
    ),
  ];

  const AppProductsSection({
    super.key,
    required this.products,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.isLoading = false,
    this.childAspectRatio = 0.65,
    this.mainAxisExtent,
    this.crossAxisCount = 2,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts =
        isLoading && products.isEmpty ? _dummyProducts : products;

    return Skeletonizer.sliver(
      enabled: isLoading,
      ignoreContainers: true,
      child: SliverMainAxisGroup(
        slivers: [
          AppSliverGrid<ProductEntity>(
            padding: padding ?? EdgeInsets.zero,
            childAspectRatio: childAspectRatio,
            mainAxisExtent: mainAxisExtent,
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            items: displayProducts,
            hasMore: hasMore && !isLoadingMore && !isLoading,
            onLoadMore: onLoadMore,
            animateItems: !isLoading,
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
      ),
    );
  }
}
