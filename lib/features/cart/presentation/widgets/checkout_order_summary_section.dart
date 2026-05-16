import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../bloc/checkout/checkout_bloc.dart';

class CheckoutOrderSummarySection extends StatelessWidget {
  const CheckoutOrderSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      buildWhen: (prev, curr) =>
          prev.items != curr.items ||
          prev.subtotal != curr.subtotal ||
          prev.productDiscounts != curr.productDiscounts ||
          prev.shippingFee != curr.shippingFee ||
          prev.discountAmount != curr.discountAmount ||
          prev.total != curr.total ||
          prev.appliedCoupon != curr.appliedCoupon,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product list
            ...state.items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: AppCachedImage(
                          imageUrl: item.productImage,
                          width: 56.w,
                          height: 56.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: tt.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.verticalSpace,
                            Text(
                              'x${item.quantity}  •  ${item.unitPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            if (item.offers != null &&
                                item.offers!.isNotEmpty) ...[
                              2.verticalSpace,
                              Text(
                                '${context.l10n.shared_save} ${(item.unitPrice * (item.offers!.first.discountPercentage / 100) * item.quantity).toStringAsFixed(0)} ${context.l10n.shared_currency_egp} (${item.offers!.first.discountPercentage}% OFF)',
                                style: tt.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '${item.totalPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                )),

            if (state.items.isNotEmpty) ...[
              AppDivider(color: cs.outline.withValues(alpha: 0.3), height: 1),
              12.verticalSpace,
            ],

            // Subtotal
            _SummaryRow(
              label: context.l10n.checkout_subtotal,
              value:
                  '${state.subtotal.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
            ),
            if (state.productDiscounts > 0) ...[
              8.verticalSpace,
              _SummaryRow(
                label: context.l10n.cart_product_offers,
                value:
                    '- ${state.productDiscounts.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                valueColor: Colors.green,
              ),
            ],
            8.verticalSpace,

            // Shipping
            _SummaryRow(
              label: context.l10n.checkout_shipping,
              value:
                  '${state.shippingFee.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
            ),

            // Discount (only when coupon applied)
            if (state.appliedCoupon != null) ...[
              8.verticalSpace,
              _SummaryRow(
                label: context.l10n.checkout_discount,
                value:
                    '- ${state.discountAmount.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                valueColor: cs.primary,
              ),
            ],

            12.verticalSpace,
            AppDivider(color: cs.outline.withValues(alpha: 0.3), height: 1),
            12.verticalSpace,

            // Total
            _SummaryRow(
              label: context.l10n.checkout_total,
              value:
                  '${state.total.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
              isBold: true,
              valueColor: cs.primary,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final style = isBold
        ? tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : tt.bodyMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.6));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: style?.copyWith(
            color: valueColor ?? (isBold ? cs.onSurface : null),
          ),
        ),
      ],
    );
  }
}
