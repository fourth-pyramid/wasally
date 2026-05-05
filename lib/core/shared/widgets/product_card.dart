import 'package:wassaly/core/imports/imports.dart';

import '../../../features/home/domain/entities/product_entity.dart';

/// Shared notifier that holds the currently active (long-pressed) product id.
/// When a card long-presses, it sets its id here.
/// All other cards listen and stop their marquee automatically.
final activeMarqueeId = ValueNotifier<int?>(null);

/// Auto-scrolling marquee text widget.
/// Only scrolls when [isActive] is true.
/// Resets to start instantly when [isActive] becomes false.
class _MarqueeText extends StatefulWidget {
  const _MarqueeText({
    required this.text,
    required this.style,
    required this.isActive,
  });

  final String text;
  final TextStyle? style;
  final bool isActive;

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText> {
  late final ScrollController _scrollController;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(_MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAndReset();
    }
  }

  void _startScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    if (_isRunning) return;

    _isRunning = true;
    _runMarquee(maxScroll);
  }

  void _stopAndReset() {
    _isRunning = false;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _runMarquee(double maxScroll) async {
    while (mounted && _isRunning) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted || !_isRunning) break;

      await _scrollController.animateTo(
        maxScroll,
        duration: Duration(milliseconds: (maxScroll * 18).toInt()),
        curve: Curves.linear,
      );
      if (!mounted || !_isRunning) break;

      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted || !_isRunning) break;

      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}

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
/// - Action callbacks for tap, favorite, and add to cart
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
      setState(() => _isActive = isNowActive);
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

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final originalPrice = double.tryParse(widget.product.price) ?? 0;
    final hasDiscount = widget.product.hasOffer;
    final discountedPrice = widget.product.discountedPrice;

    return GestureDetector(
      onTap: widget.onTap,
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
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description — marquee when active
                    if (widget.product.description.isNotEmpty)
                      _MarqueeText(
                        text: widget.product.description,
                        isActive: _isActive,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    4.verticalSpace,

                    // Product name — marquee when active
                    _MarqueeText(
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
                            widget.product.averageRating.toStringAsFixed(1),
                            style: tt.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                              fontSize: 10.sp,
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
              fit: BoxFit.cover,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(9.r),
              ),
            ),
          ),

          // Favorite button
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: widget.onFavoriteTap,
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
                  widget.product.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 18.r,
                  color: widget.product.isFavorite
                      ? cs.error
                      : cs.onSurfaceVariant,
                ),
              ),
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
                '${originalPrice.toStringAsFixed(0)} ${'ج.م'.tr()}',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: cs.onSurfaceVariant,
                ),
              ),
            Text(
              '${(hasDiscount ? discountedPrice : originalPrice).toStringAsFixed(0)} ${'ج.م'.tr()}',
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
          onTap: widget.onOpenProductTap,
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
