import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';

class CartOrderSummary extends StatelessWidget {
  final CartState state;

  const CartOrderSummary({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final totalOriginalPrice = state.totalOriginalPrice;
    final productOffersDiscount = state.productOffersDiscount;
    final total = state.total;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Summary Section
          _SummaryRow(
            label: context.l10n.cart_subtotal,
            value:
                '${totalOriginalPrice.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
          ),
          if (productOffersDiscount > 0) ...[
            8.verticalSpace,
            _SummaryRow(
              label: context.l10n.cart_product_offers,
              value:
                  '- ${productOffersDiscount.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
              valueColor: Colors.green,
            ),
          ],
          12.verticalSpace,
          AppDivider(color: cs.outline.withValues(alpha: 0.3), height: 1),
          12.verticalSpace,
          _SummaryRow(
            label: context.l10n.cart_total,
            value:
                '${total.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
            isBold: true,
            valueColor: cs.primary,
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.checkout, extra: state),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                context.l10n.cart_checkout,
                style: tt.titleMedium?.copyWith(
                  color: cs.onPrimary,
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
