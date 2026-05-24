import 'package:wassaly/core/imports/imports.dart';

import '../../../domain/entities/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onRemove;
  final VoidCallback onQuantityIncrease;
  final VoidCallback onQuantityDecrease;
  final VoidCallback? onTap;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityIncrease,
    required this.onQuantityDecrease,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Dismissible(
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
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context, ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.error,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: cs.onError, size: 28.r),
          12.horizontalSpace,
          Text(
            context.l10n.cart_delete,
            style: TextStyle(
              color: cs.onError,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ColorScheme cs, TextTheme tt) {
    return AppCard(
      showShadow: true,
      onTap: onTap,
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          // 1. Product Image (Far Left in LTR, Right in RTL)
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: AppCachedImage(
              imageUrl: item.productImage,
              borderRadius: BorderRadius.circular(12.r),
              fit: BoxFit.cover,
            ),
          ),
          16.horizontalSpace,

          // 2. Product Details (Middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                if (item.productDescription != null &&
                    item.productDescription!.isNotEmpty)
                  Text(
                    item.productDescription!,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                8.verticalSpace,
                _buildPriceSection(context, cs, tt),
                12.verticalSpace,
                _buildQuantityControl(cs, tt),
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
        border: Border.all(color: cs.outlineVariant),
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
            constraints: BoxConstraints(minWidth: 40.w),
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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

    final discountedTotal = discountedPrice * item.quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (hasOffer) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '-${item.offers!.first.discountPercentage.toInt()}%',
                  style: tt.labelSmall?.copyWith(
                    color: cs.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                '${discountedPrice.toStringAsFixed(2)} ${context.l10n.common_currency}',
                style: tt.titleSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.horizontalSpace,
              Text(
                originalPrice.toStringAsFixed(2),
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 10.sp,
                ),
              ),
            ] else ...[
              Text(
                '${originalPrice.toStringAsFixed(2)} ${context.l10n.common_currency}',
                style: tt.titleSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        if (hasOffer) ...[
          4.verticalSpace,
          Text(
            '${context.l10n.cart_total_after_discount} ${discountedTotal.toStringAsFixed(2)} ${context.l10n.common_currency}',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
        ],
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
