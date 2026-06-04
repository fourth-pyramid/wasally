import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/product_details/presentation/bloc/product_details_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class RelatedProductsSection extends StatelessWidget {
  final RelatedProductsStatus status;
  final List<ProductEntity> products;
  final bool canLoad;

  const RelatedProductsSection({
    required this.status,
    required this.products,
    required this.canLoad,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (status == RelatedProductsStatus.initial && !canLoad) {
      return const SizedBox.shrink();
    }

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.product_details_related_products,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        10.verticalSpace,
        if (status == RelatedProductsStatus.initial ||
            status == RelatedProductsStatus.loading)
          SizedBox(
            height: 245.h,
            child: const Center(child: AppLoading()),
          )
        else if (status == RelatedProductsStatus.failure || products.isEmpty)
          SizedBox(
            height: 70.h,
            child: Center(
              child: Text(
                context.l10n.product_details_no_related_products,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 245.h,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == products.length - 1 ? 0 : 10.w,
                    ),
                    child: AppUnifiedCard(
                      id: products[index].id,
                      title: products[index].name,
                      description: products[index].description,
                      image: products[index].image,
                      price: products[index].discountedPrice.toStringAsFixed(0),
                      originalPrice: products[index].hasOffer
                          ? (double.tryParse(products[index].price) ?? 0)
                              .toStringAsFixed(0)
                          : null,
                      discountPercentage: products[index].hasOffer
                          ? products[index].discountPercentage
                          : null,
                      rating: products[index].averageRating,
                      reviewCount: products[index].reviewCount,
                      isFavorite: products[index].isFavorite,
                      activeIdNotifier: _activeMarqueeId,
                      onTap: () => context.push(
                        AppRoutes.productDetails,
                        extra: {'productId': products[index].id},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
