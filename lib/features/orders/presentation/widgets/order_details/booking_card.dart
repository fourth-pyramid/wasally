import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_status_config.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingCard({required this.booking, super.key});

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
            unawaited(
              context.push(
                AppRoutes.bookingDetails,
                extra: {'booking': booking},
              ),
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
                        memCacheWidth: 56 * 3,
                        memCacheHeight: 56 * 3,
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

                if (booking.rescheduleDetails != null &&
                    _isRescheduleStatus(booking.status)) ...[
                  16.verticalSpace,
                  AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                  16.verticalSpace,
                  Text(
                    _getRescheduleHeader(context, booking.status),
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  12.verticalSpace,
                  Row(
                    children: [
                      _InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: booking.rescheduleDetails!.suggestedDay,
                      ),
                      if (booking.rescheduleDetails!.suggestedTime != null) ...[
                        16.horizontalSpace,
                        _InfoItem(
                          icon: Icons.access_time_rounded,
                          label: booking.rescheduleDetails!.suggestedTime!
                              .to12HourFormat(),
                        ),
                      ],
                    ],
                  ),
                  if (booking.rescheduleDetails!.rescheduleNote != null &&
                      booking
                          .rescheduleDetails!.rescheduleNote!.isNotEmpty) ...[
                    12.verticalSpace,
                    Text(
                      booking.rescheduleDetails!.rescheduleNote!,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],

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
    final config = OrderStatusConfig.getConfig(context, status);

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

String _getRescheduleHeader(BuildContext context, String status) {
  final normalizedStatus = status.trim().toLowerCase();
  if (normalizedStatus == 'reschedule_by_customer') {
    return context.l10n.booking_reschedule_customer_suggested;
  }
  return context.l10n.booking_reschedule_provider_suggested;
}

bool _isRescheduleStatus(String status) {
  final normalizedStatus = status.trim().toLowerCase();
  return normalizedStatus == 'reschedule_by_provider' ||
      normalizedStatus == 'reschedule_by_customer';
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
