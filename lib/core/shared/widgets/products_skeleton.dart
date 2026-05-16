import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class AppProductsSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final EdgeInsetsGeometry? padding;

  const AppProductsSkeleton({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
    this.mainAxisExtent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppSliverGrid<ProductEntity>(
      padding: padding ?? EdgeInsets.zero,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisExtent: mainAxisExtent,
      items: List.generate(
        4,
        (index) => ProductEntity(
          id: index,
          name: 'منتج تجريبي',
          image: '',
          price: '100',
          description: 'وصف تجريبي',
          offers: const [],
          reviews: const [],
          isFavorite: false,
        ),
      ),
      animateItems: false,
      itemBuilder: (context, product, index, wrapAnimation) {
        return Skeletonizer(
          ignoreContainers: true,
          enabled: true,
          child: ProductCard(product: product),
        );
      },
    );
  }
}
