import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({super.key, required this.booking});

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
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: cs.primaryContainer,
                ),
                child: CommonImage(
                  imageUrl: booking.service.image ?? '',
                  width: 50.w,
                  height: 50.w,
                  memCacheHeight: 50 * 2,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.service.name,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      booking.provider.name,
                      style: tt.bodySmall?.copyWith(
                        color: cs.outline,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: booking.status),
            ],
          ),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                label: booking.day,
              ),
              _InfoItem(
                icon: Icons.access_time,
                label: booking.time,
              ),
              Text(
                '${booking.service.price} ${context.l10n.shared_currency_egp}',
                style: tt.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (booking.governorate != null || booking.center != null) ...[
            Divider(height: 24.h),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14.sp, color: cs.outline),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    '${booking.governorate ?? ''}${booking.governorate != null && booking.center != null ? ' - ' : ''}${booking.center ?? ''}',
                    style: tt.bodySmall?.copyWith(color: cs.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
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
      'completed':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'مكتمل':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'cancelled':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'ملغي':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
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

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      children: [
        Icon(icon, size: 14.sp, color: cs.outline),
        SizedBox(width: 4.w),
        Text(
          label,
          style: tt.bodySmall,
        ),
      ],
    );
  }
}
