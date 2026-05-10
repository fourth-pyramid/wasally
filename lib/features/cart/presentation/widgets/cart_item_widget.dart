import '../../../../core/imports/imports.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onRemove;
  final VoidCallback onQuantityIncrease;
  final VoidCallback onQuantityDecrease;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityIncrease,
    required this.onQuantityDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Text('cart.remove_item_title'.tr()),
            content: Text('cart.remove_item_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('common.cancel'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'common.delete'.tr(),
                  style: TextStyle(color: cs.error),
                ),
              ),
            ],
          ),
        );
      },
      background: _buildDismissBackground(cs),
      child: _buildCard(context, cs, tt),
    );
  }

  Widget _buildDismissBackground(ColorScheme cs) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: cs.error, size: 28.r),
          4.verticalSpace,
          Text(
            'cart.delete'.tr(),
            style: TextStyle(
              color: cs.error,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ColorScheme cs, TextTheme tt) {
    return AppCard(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CommonImage(
              imageUrl: item.productImage,
              width: 100.w,
              memCacheHeight: 100 * 3,
              height: 100.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          14.horizontalSpace,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                if (item.productDescription != null &&
                    item.productDescription!.isNotEmpty)
                  Text(
                    item.productDescription!,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                6.verticalSpace,
                _buildPriceSection(cs, tt),
                10.verticalSpace,
                Row(
                  children: [
                    _buildQuantityControl(cs, tt),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(ColorScheme cs, TextTheme tt) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10.r),
        color: cs.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: onQuantityDecrease,
            cs: cs,
          ),
          Container(
            constraints: BoxConstraints(minWidth: 32.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: onQuantityIncrease,
            cs: cs,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(ColorScheme cs, TextTheme tt) {
    final hasOffer = item.offers != null && item.offers!.isNotEmpty;
    final originalPrice = double.tryParse(item.price) ?? 0.0;
    final discountedPrice = hasOffer
        ? originalPrice * (1 - (item.offers!.first.discountPercentage / 100))
        : originalPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price line with original, discounted, and discount percentage
        Row(
          children: [
            if (hasOffer) ...[
              Text(
                originalPrice.toStringAsFixed(0),
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  decoration: TextDecoration.lineThrough,
                  decorationColor: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
              8.horizontalSpace,
              Text(
                discountedPrice.toStringAsFixed(0),
                style: tt.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.horizontalSpace,
              Text(
                'shared.currency_egp'.tr(),
                style: tt.labelSmall?.copyWith(color: cs.primary),
              ),
              8.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '-${item.offers!.first.discountPercentage.toInt()}%',
                  style: tt.labelSmall?.copyWith(
                    color: cs.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else ...[
              Text(
                originalPrice.toStringAsFixed(0),
                style: tt.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.horizontalSpace,
              Text(
                'shared.currency_egp'.tr(),
                style: tt.labelSmall?.copyWith(color: cs.primary),
              ),
            ],
          ],
        ),
        4.verticalSpace,
        // Total price line
        Row(
          children: [
            Text(
              'cart.total_price'.tr(),
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            4.horizontalSpace,
            Text(
              '${item.totalPrice.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.horizontalSpace,
            Text(
              '(${item.quantity} ${'cart.items'.tr()})',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(icon, size: 18.r, color: cs.onSurface),
        ),
      ),
    );
  }
}
