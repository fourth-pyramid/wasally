import 'package:wassaly/core/imports/imports.dart';

import '../../../features/favorite/presentation/bloc/favorite_bloc.dart';
import '../../../features/favorite/presentation/bloc/favorite_event.dart';
import '../../../features/favorite/presentation/bloc/favorite_state.dart';
import '../../../features/home/domain/entities/product_entity.dart';

/// Shared notifier that holds the currently active (long-pressed) product id.
/// When a card long-presses, it sets its id here.
/// All other cards listen and stop their marquee automatically.
final activeMarqueeId = ValueNotifier<int?>(null);



/// A reusable product card widget for displaying product information.
///
/// Used across the app in grids, lists, and other product displays.
/// Features:
/// - Product image with cached loading
/// - Favorite toggle button
/// - Discount badge
/// - Rating display
/// - Price with original price strikethrough when discounted
/// - Auto-scrolling (marquee) on long-press — stays active until another card
///   is long-pressed, or the same card is long-pressed again to toggle off
/// - Default product detail navigation, with optional action overrides
class ProductCard extends StatefulWidget {
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

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    activeMarqueeId.addListener(_onActiveIdChanged);
  }

  @override
  void dispose() {
    activeMarqueeId.removeListener(_onActiveIdChanged);
    // If this card was the active one, clear the notifier
    if (activeMarqueeId.value == widget.product.id) {
      activeMarqueeId.value = null;
    }
    super.dispose();
  }

  void _onActiveIdChanged() {
    final isNowActive = activeMarqueeId.value == widget.product.id;
    if (isNowActive != _isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isActive = isNowActive);
        }
      });
    }
  }

  void _onLongPress() {
    // Toggle off if same card is long-pressed again, otherwise activate
    if (activeMarqueeId.value == widget.product.id) {
      activeMarqueeId.value = null;
    } else {
      activeMarqueeId.value = widget.product.id;
    }
  }

  void _openProductDetails() {
    if (widget.product.id <= 0) return;

    context.push(
      AppRoutes.productDetails,
      extra: {'productId': widget.product.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final originalPrice = double.tryParse(widget.product.price) ?? 0;
    final hasDiscount = widget.product.hasOffer;
    final discountedPrice = widget.product.discountedPrice;

    return GestureDetector(
      onTap: widget.onTap ?? _openProductDetails,
      onLongPress: _onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            // Subtle highlight when marquee is active
            color: _isActive
                ? cs.primary.withValues(alpha: 0.6)
                : cs.outlineVariant.withValues(alpha: 0.5),
            width: _isActive ? 1.5 : 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with favorite & discount badge
            _buildImageSection(cs),

            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 4.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description — marquee when active
                    if (widget.product.description.isNotEmpty)
                      MarqueeText(
                        text: widget.product.description,
                        isActive: _isActive,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    4.verticalSpace,

                    // Product name — marquee when active
                    MarqueeText(
                      text: widget.product.name,
                      isActive: _isActive,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),

                    const Spacer(),

                    // Rating row
                    if (widget.product.reviewCount > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14.r,
                            color: const Color(0xFFFFC107),
                          ),
                          2.horizontalSpace,
                          Text(
                            '${widget.product.averageRating.toStringAsFixed(1)} (${widget.product.reviewCount})',
                            style: tt.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),

                    _buildPriceRow(
                      cs,
                      tt,
                      originalPrice,
                      discountedPrice,
                      hasDiscount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ColorScheme cs) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Product image
          Positioned.fill(
            child: CommonImage(
              memCacheHeight: 140 * 3,
              imageUrl: widget.product.image,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(9.r),
              ),
            ),
          ),

          // Favorite button — uses BlocSelector for granular rebuilds
          Align(
            alignment: Alignment.topLeft,
            child: BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
              selector: (state) => (
                state.favoriteIds.contains(widget.product.id) ||
                    (!state.hasLoaded && widget.product.isFavorite),
                state.togglingIds.contains(widget.product.id),
              ),
              builder: (context, status) {
                final isFavorite = status.$1;
                final isToggling = status.$2;
                return GestureDetector(
                  onTap: isToggling
                      ? null
                      : widget.onFavoriteTap ??
                          () {
                            context.read<FavoriteBloc>().add(
                                  ToggleFavoriteEvent(
                                    widget.product.id,
                                    expectedIsFavorite: isFavorite,
                                  ),
                                );
                          },
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

          // Discount badge
          if (widget.product.hasOffer)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 6.w, vertical: 6.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${widget.product.discountPercentage}%-',
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

  Widget _buildPriceRow(
    ColorScheme cs,
    TextTheme tt,
    double originalPrice,
    double discountedPrice,
    bool hasDiscount,
  ) {
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

        // Eye button
        GestureDetector(
          onTap: widget.onOpenProductTap ?? _openProductDetails,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.remove_red_eye,
              size: 18.r,
              color: cs.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
