import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class ProductsSkeleton extends StatelessWidget {
  const ProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverProductGrid<ProductEntity>(
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
