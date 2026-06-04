import 'package:wassaly/core/imports/imports.dart';

class OrderStatusConfig {
  final Color color;
  final String label;

  const OrderStatusConfig({
    required this.color,
    required this.label,
  });

  static OrderStatusConfig getConfig(BuildContext context, String status) {
    final cs = context.theme.colorScheme;
    final normalizedStatus = status.trim().toLowerCase();

    switch (normalizedStatus) {
      case 'pending':
      case 'waiting':
      case 'قيد الانتظار':
        return OrderStatusConfig(
          color: const Color(0xFFF59E0B),
          label: context.l10n.order_status_pending,
        );
      case 'accepted':
      case 'تم القبول':
        return OrderStatusConfig(
          color: Colors.blue,
          label: context.l10n.order_status_accepted,
        );
      case 'confirmed':
        return OrderStatusConfig(
          color: Colors.indigo,
          label: context.l10n.order_status_confirmed,
        );
      case 'processing':
      case 'جاري التجهيز':
        return OrderStatusConfig(
          color: Colors.cyan,
          label: context.l10n.order_status_processing,
        );
      case 'shipped':
      case 'تم الشحن':
        return OrderStatusConfig(
          color: Colors.teal,
          label: context.l10n.order_status_shipped,
        );
      case 'delivered':
      case 'تم التوصيل':
        return OrderStatusConfig(
          color: Colors.green,
          label: context.l10n.order_status_delivered,
        );
      case 'completed':
      case 'مكتمل':
      case 'success':
        return OrderStatusConfig(
          color: Colors.green,
          label: context.l10n.order_status_completed,
        );
      case 'cancelled':
      case 'ملغي':
      case 'rejected':
      case 'failed':
        return OrderStatusConfig(
          color: Colors.red,
          label: context.l10n.order_status_cancelled,
        );
      case 'reschedule_by_provider':
      case 'reschedule_by_customer':
        return OrderStatusConfig(
          color: Colors.orange,
          label: context.l10n.order_status_reschedule,
        );
      default:
        return OrderStatusConfig(
          color: cs.primary,
          label: status,
        );
    }
  }
}
