import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        showShadow: true,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            context.push(
              AppRoutes.bookingDetails,
              extra: {'booking': booking},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Status (Left) and Service Info + Image (Right)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: booking.status),
                    const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            booking.service.name,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          4.verticalSpace,
                          Text(
                            booking.provider.name,
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: AppCachedImage(
                        imageUrl: booking.service.image ?? '',
                        borderRadius: BorderRadius.circular(8.r),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                16.verticalSpace,

                // 2. Middle Section: Price (Left), Time, Day (Right)
                Row(
                  children: [
                    Text(
                      '${booking.service.price} ${context.l10n.common_currency}',
                      style: tt.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _InfoItem(
                      icon: Icons.access_time_rounded,
                      label: booking.time.to12HourFormat(),
                    ),
                    16.horizontalSpace,
                    _InfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: booking.day,
                    ),
                  ],
                ),

                // 3. Footer: Location (Bottom aligned Right)
                if (booking.governorate != null || booking.center != null) ...[
                  16.verticalSpace,
                  AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          '${booking.governorate ?? ''}${booking.governorate != null && booking.center != null ? ' - ' : ''}${booking.center ?? ''}',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.r,
                        color: cs.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
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
      'pending': _StatusConfig(
          const Color(0xFFF59E0B), context.l10n.order_status_pending),
      'waiting': _StatusConfig(
          const Color(0xFFF59E0B), context.l10n.order_status_pending),
      'قيد الانتظار': _StatusConfig(
          const Color(0xFFF59E0B), context.l10n.order_status_pending),
      'accepted':
          _StatusConfig(Colors.blue, context.l10n.order_status_accepted),
      'تم القبول':
          _StatusConfig(Colors.blue, context.l10n.order_status_accepted),
      'confirmed':
          _StatusConfig(Colors.indigo, context.l10n.order_status_confirmed),
      'completed':
          _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'مكتمل': _StatusConfig(Colors.green, context.l10n.order_status_completed),
      'cancelled':
          _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'ملغي': _StatusConfig(Colors.red, context.l10n.order_status_cancelled),
      'reschedule_by_provider':
          _StatusConfig(Colors.orange, context.l10n.order_status_reschedule),
      'reschedule_by_customer':
          _StatusConfig(Colors.orange, context.l10n.order_status_reschedule),
    };

    final config =
        statusConfig[normalizedStatus] ?? _StatusConfig(cs.primary, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 11.sp,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        6.horizontalSpace,
        Icon(icon, size: 16.r, color: cs.onSurfaceVariant),
      ],
    );
  }
}
