import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/domain/entities/order_entity.dart' as cart_order;

class OrderSuccessPage extends StatelessWidget {
  final cart_order.OrderEntity order;

  const OrderSuccessPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: cs.primary,
                  size: 100.r,
                ),
              ),
              32.verticalSpace,
              Text(
                context.l10n.checkout_success_title,
                style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Text(
                context.l10n.checkout_success_msg,
                style: tt.bodyLarge?.copyWith(color: cs.outline),
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              AppCard(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    _buildRow(
                      context,
                      context.l10n.checkout_order_id,
                      '#${order.id}',
                    ),
                    12.verticalSpace,
                    _buildRow(
                      context,
                      context.l10n.order_date,
                      _formatDate(order.createdAt),
                    ),
                    12.verticalSpace,
                    _buildRow(
                      context,
                      context.l10n.order_payment_method,
                      context.l10n.order_details_payment_cod,
                    ),
                    12.verticalSpace,
                    _buildRow(
                      context,
                      context.l10n.checkout_total,
                      '${order.total.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: context.l10n.checkout_go_home,
                onPressed: () => context.go(AppRoutes.home),
              ),
              16.verticalSpace,
              AppButton(
                label: context.l10n.checkout_view_orders,
                variant: ButtonVariant.outline,
                onPressed: () => context.go(
                  AppRoutes.orders,
                  extra: {'initialIndex': 0},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final year = localDate.year;
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
