import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.orderNumber}',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _StatusBadge(status: order.status),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.order_total_price,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                '${order.totalPrice} ${context.l10n.common_currency}',
                style: tt.titleSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.order_items_count,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                '${order.items.length}',
                style: tt.bodyMedium,
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.order_date,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                order.createdAt,
                style: tt.bodySmall,
              ),
            ],
          ),
          12.verticalSpace,
          const AppDivider(),
          12.verticalSpace,
          Text(
            context.l10n.order_payment_method,
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          4.verticalSpace,
          Text(
            order.paymentMethod.toLowerCase().contains('cash') ||
                    order.paymentMethod.contains('كاش')
                ? context.l10n.order_payment_cash
                : order.paymentMethod,
            style: tt.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final normalizedStatus = status.trim().toLowerCase();

    final statusConfig = {
      'pending':
          _StatusConfig(Colors.orange, context.l10n.order_status_pending),
      'waiting':
          _StatusConfig(Colors.orange, context.l10n.order_status_pending),
      'قيد الانتظار':
          _StatusConfig(Colors.orange, context.l10n.order_status_pending),
      'accepted':
          _StatusConfig(Colors.blue, context.l10n.order_status_accepted),
      'تم القبول':
          _StatusConfig(Colors.blue, context.l10n.order_status_accepted),
      'confirmed':
          _StatusConfig(Colors.indigo, context.l10n.order_status_confirmed),
      'processing':
          _StatusConfig(Colors.cyan, context.l10n.order_status_processing),
      'جاري التجهيز':
          _StatusConfig(Colors.cyan, context.l10n.order_status_processing),
      'shipped': _StatusConfig(Colors.teal, context.l10n.order_status_shipped),
      'تم الشحن': _StatusConfig(Colors.teal, context.l10n.order_status_shipped),
      'delivered':
          _StatusConfig(Colors.green, context.l10n.order_status_delivered),
      'تم التوصيل':
          _StatusConfig(Colors.green, context.l10n.order_status_delivered),
      'completed':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'مكتمل':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'success':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'cancelled':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'ملغي':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'rejected':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'failed': _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
    };

    final config =
        statusConfig[normalizedStatus] ?? _StatusConfig(cs.primary, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusConfig {
  final Color color;
  final String label;
  _StatusConfig(this.color, this.label);
}
