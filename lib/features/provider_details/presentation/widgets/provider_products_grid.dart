import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class ProviderProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;

  const ProviderProductsGrid({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h, top: 24.h),
            child: Text(
              context.l10n.order_products,
              style: context.theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AppSliverGrid<ProductEntity>(
          items: products,
          padding: EdgeInsets.zero,
          childAspectRatio: 0.67,
          itemBuilder: (context, product, index, wrapAnimation) =>
              wrapAnimation(
            AppUnifiedCard(
              id: product.id,
              title: product.name,
              description: product.description,
              image: product.image,
              price: product.discountedPrice.toStringAsFixed(0),
              originalPrice: product.hasOffer
                  ? (double.tryParse(product.price) ?? 0).toStringAsFixed(0)
                  : null,
              discountPercentage:
                  product.hasOffer ? product.discountPercentage : null,
              rating: product.averageRating,
              reviewCount: product.reviewCount,
              isFavorite: product.isFavorite,
              activeIdNotifier: _activeMarqueeId,
              onTap: () => context.push(
                AppRoutes.productDetails,
                extra: {'productId': product.id},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
