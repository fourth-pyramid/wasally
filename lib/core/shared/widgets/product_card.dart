import 'package:wassaly/core/imports/imports.dart';

import '../../../features/favorite/presentation/bloc/favorite_bloc.dart';
import '../../../features/favorite/presentation/bloc/favorite_event.dart';
import '../../../features/favorite/presentation/bloc/favorite_state.dart';
import '../../../features/home/domain/entities/product_entity.dart';

final activeMarqueeId = ValueNotifier<int?>(null);

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onOpenProductTap,
  });

  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onOpenProductTap;

  void _onLongPress() {
    activeMarqueeId.value =
        activeMarqueeId.value == product.id ? null : product.id;
  }

  void _openProductDetails(BuildContext context) {
    if (product.id <= 0) return;
    context.push(AppRoutes.productDetails, extra: {'productId': product.id});
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final originalPrice = double.tryParse(product.price) ?? 0;
    final hasDiscount = product.hasOffer;
    final discountedPrice = product.discountedPrice;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap ?? () => _openProductDetails(context),
        onLongPress: _onLongPress,
        child: ValueListenableBuilder<int?>(
          valueListenable: activeMarqueeId,
          builder: (context, activeId, child) {
            final isActive = activeId == product.id;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? cs.primary.withValues(alpha: 0.6)
                      : cs.outlineVariant.withValues(alpha: 0.5),
                  width: isActive ? 1.5 : 1.0,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImageSection(
                product: product,
                onFavoriteTap: onFavoriteTap,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.description.isNotEmpty)
                        _ActiveMarqueeText(
                          productId: product.id,
                          text: product.description,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      4.verticalSpace,
                      _ActiveMarqueeText(
                        productId: product.id,
                        text: product.name,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (product.reviewCount > 0)
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                size: 14.r, color: cs.secondary),
                            2.horizontalSpace,
                            Text(
                              '${product.averageRating.toStringAsFixed(1)} (${product.reviewCount})',
                              style: tt.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      _PriceRow(
                        product: product,
                        originalPrice: originalPrice,
                        discountedPrice: discountedPrice,
                        hasDiscount: hasDiscount,
                        onOpenProductTap: onOpenProductTap ??
                            () => _openProductDetails(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveMarqueeText extends StatelessWidget {
  const _ActiveMarqueeText({
    required this.productId,
    required this.text,
    this.style,
  });

  final int productId;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: activeMarqueeId,
      builder: (context, activeId, _) {
        return MarqueeText(
          text: text,
          isActive: activeId == productId,
          style: style,
        );
      },
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  const _ProductImageSection({
    required this.product,
    this.onFavoriteTap,
  });

  final ProductEntity product;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: CommonImage(
              memCacheHeight: 140 * 3,
              imageUrl: product.image,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.vertical(top: Radius.circular(9.r)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
              selector: (state) => (
                state.favoriteIds.contains(product.id) ||
                    (!state.hasLoaded && product.isFavorite),
                state.togglingIds.contains(product.id),
              ),
              builder: (context, status) {
                final isFavorite = status.$1;
                final isToggling = status.$2;
                return GestureDetector(
                  onTap: isToggling
                      ? null
                      : onFavoriteTap ??
                          () => context.read<FavoriteBloc>().add(
                                ToggleFavoriteEvent(
                                  product.id,
                                  expectedIsFavorite: isFavorite,
                                ),
                              ),
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 6.w, vertical: 6.h),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      size: 18.r,
                      color: isFavorite ? cs.error : cs.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          if (product.hasOffer)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 6.w, vertical: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${product.discountPercentage}%-',
                  style: TextStyle(
                    color: cs.onError,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.product,
    required this.originalPrice,
    required this.discountedPrice,
    required this.hasDiscount,
    required this.onOpenProductTap,
  });

  final ProductEntity product;
  final double originalPrice;
  final double discountedPrice;
  final bool hasDiscount;
  final VoidCallback onOpenProductTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDiscount)
              Text(
                '${originalPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: cs.error,
                ),
              ),
            Text(
              '${(hasDiscount ? discountedPrice : originalPrice).toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
              style: tt.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onOpenProductTap,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.remove_red_eye, size: 18.r, color: cs.onPrimary),
          ),
        ),
      ],
    );
  }
}
