import 'package:wassaly/core/imports/imports.dart';

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
        return await showAppDialog<bool>(
          child: Builder(
            builder: (ctx) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 48.r,
                      color: cs.error,
                    ),
                    16.verticalSpace,
                    Text(
                      context.l10n.cart_remove_item_title,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      context.l10n.cart_remove_item_message,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: context.l10n.shared_cancel,
                            variant: ButtonVariant.ghost,
                            isFullWidth: false,
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: AppButton(
                            isFullWidth: true,
                            label: context.l10n.shared_delete,
                            variant: ButtonVariant.danger,
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      background: _buildDismissBackground(context, cs),
      child: _buildCard(context, cs, tt),
    );
  }

  Widget _buildDismissBackground(BuildContext context, ColorScheme cs) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: cs.error, size: 28.r),
          4.verticalSpace,
          Text(
            context.l10n.cart_delete,
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
      showShadow: true,
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
                _buildPriceSection(context, cs, tt),
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
            isEnabled: item.quantity > 1,
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

  Widget _buildPriceSection(
      BuildContext context, ColorScheme cs, TextTheme tt) {
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
                context.l10n.shared_currency_egp,
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
                context.l10n.shared_currency_egp,
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
              context.l10n.cart_total_price,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            4.horizontalSpace,
            Text(
              '${item.totalPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.horizontalSpace,
            Text(
              '(${item.quantity} ${context.l10n.cart_items})',
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
  final bool isEnabled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.cs,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(
            icon,
            size: 18.r,
            color:
                isEnabled ? cs.onSurface : cs.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
