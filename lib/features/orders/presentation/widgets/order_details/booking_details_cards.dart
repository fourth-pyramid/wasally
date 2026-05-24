import 'package:wassaly/core/imports/imports.dart';

import '../../../../service_booking/domain/entities/booking_entity.dart';

class BookingHeaderCard extends StatelessWidget {
  final BookingEntity booking;
  final bool isCancelled;

  const BookingHeaderCard({
    super.key,
    required this.booking,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.booking_details_title,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? Colors.red.withValues(alpha: 0.1)
                      : cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _getStatusText(context, booking.status),
                  style: tt.bodyMedium?.copyWith(
                    color: isCancelled ? Colors.red : cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          const AppDivider(),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderInfoItem(
                context,
                icon: Icons.calendar_today_rounded,
                label: context.l10n.service_booking_day,
                value: booking.day,
              ),
              _buildHeaderInfoItem(
                context,
                icon: Icons.access_time_rounded,
                label: context.l10n.service_booking_time,
                value: booking.time.to12HourFormat(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(BuildContext context, String status) {
    final norm = status.trim().toLowerCase();
    if (norm.contains('pending') ||
        norm.contains('waiting') ||
        norm.contains('قيد الانتظار')) {
      return context.l10n.order_status_pending;
    } else if (norm.contains('accepted') || norm.contains('تم القبول')) {
      return context.l10n.order_status_accepted;
    } else if (norm.contains('confirmed') || norm.contains('مؤكد')) {
      return context.l10n.order_status_confirmed;
    } else if (norm.contains('completed') || norm.contains('مكتمل')) {
      return context.l10n.order_status_completed;
    } else if (norm.contains('cancelled') || norm.contains('ملغي')) {
      return context.l10n.order_status_cancelled;
    }
    return status;
  }

  Widget _buildHeaderInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: cs.primary),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 10.sp,
                  ),
                ),
                4.verticalSpace,
                Text(
                  value,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCancelledAlert extends StatelessWidget {
  const BookingCancelledAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red, size: 24.r),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.order_details_cancelled_title,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                2.verticalSpace,
                Text(
                  context.l10n.order_details_cancelled_msg,
                  style: TextStyle(
                    color: Colors.red.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TimelineStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class BookingTrackerWidget extends StatelessWidget {
  final String status;

  const BookingTrackerWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final List<_TimelineStep> steps = [
      _TimelineStep(
        title: context.l10n.order_status_pending,
        description: context.l10n.order_tracker_pending_desc,
        icon: Icons.access_time_filled_rounded,
        color: Colors.orange,
      ),
      _TimelineStep(
        title: context.l10n.order_status_accepted,
        description: context.l10n.order_tracker_accepted_desc,
        icon: Icons.check_circle_rounded,
        color: Colors.blue,
      ),
      _TimelineStep(
        title: context.l10n.order_status_completed,
        description: context.l10n.order_tracker_delivered_desc,
        icon: Icons.stars_rounded,
        color: Colors.green,
      ),
    ];

    final normStatus = status.trim().toLowerCase();
    int currentStep = -1;
    bool isCancelled = false;

    if (normStatus.contains('pending') ||
        normStatus.contains('waiting') ||
        normStatus.contains('قيد الانتظار')) {
      currentStep = 0;
    } else if (normStatus.contains('accepted') ||
        normStatus.contains('confirmed') ||
        normStatus.contains('تم القبول') ||
        normStatus.contains('مؤكد')) {
      currentStep = 1;
    } else if (normStatus.contains('completed') ||
        normStatus.contains('mektmel') ||
        normStatus.contains('مكتمل')) {
      currentStep = 2;
    } else if (normStatus.contains('cancelled') ||
        normStatus.contains('ملغي') ||
        normStatus.contains('rejected') ||
        normStatus.contains('failed')) {
      isCancelled = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];

        final bool isCompleted = !isCancelled && currentStep >= index;
        final bool isCurrent = !isCancelled && currentStep == index;

        final double opacity = isCompleted ? 1.0 : 0.4;
        final Color activeColor = isCompleted
            ? step.color
            : cs.onSurfaceVariant.withValues(alpha: 0.3);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 32.r,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (index < steps.length - 1)
                      Positioned(
                        top: 32.r,
                        bottom: 0,
                        child: Container(
                          width: 2.w,
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          color: !isCancelled && currentStep > index
                              ? steps[index + 1].color
                              : cs.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? activeColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        border: Border.all(
                          color: activeColor,
                          width: isCurrent ? 2 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isCompleted ? Icons.check : step.icon,
                          size: 16.r,
                          color: activeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Opacity(
                  opacity: opacity,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: index == steps.length - 1 ? 0 : 20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          step.description,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BookingServiceInfoCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingServiceInfoCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final customerName = booking.customerName;
    final customerPhone = booking.customerPhone;
    final customerEmail = booking.customerEmail ?? '';
    final serviceName = booking.service.name;
    final servicePrice = booking.service.price;
    final providerName = booking.provider.name;
    final dayText = booking.day;
    final timeText = booking.time.to12HourTimeOnly();
    final problemDesc = booking.problemDescription;

    final hasAddress = booking.governorate != null && booking.center != null;
    final addressPath =
        hasAddress ? '${booking.center} - ${booking.governorate}' : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Service Details Card
        AppCard(
          showShadow: true,
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: cs.primaryContainer,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CommonImage(
                    imageUrl: booking.service.image ?? '',
                    width: 64,
                    height: 64,
                    memCacheHeight: 64 * 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    if (booking.service.description != null &&
                        booking.service.description!.isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        booking.service.description!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              12.horizontalSpace,
              Text(
                '$servicePrice ${context.l10n.common_currency}',
                style: tt.titleSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        16.verticalSpace,

        // 2. Provider Card
        AppCard(
          showShadow: true,
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: cs.primaryContainer,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: CommonImage(
                    imageUrl: booking.provider.avatar ?? '',
                    width: 50,
                    height: 50,
                    memCacheHeight: 50 * 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerName,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    if (booking.provider.description != null &&
                        booking.provider.description!.isNotEmpty) ...[
                      4.verticalSpace,
                      Text(
                        booking.provider.description!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (booking.provider.rating != null) ...[
                12.horizontalSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 18.r),
                    4.horizontalSpace,
                    Text(
                      booking.provider.rating!.toStringAsFixed(1),
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        16.verticalSpace,

        // 3. Appointment & Customer Details Card
        AppCard(
          showShadow: true,
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              // Appointment Slot
              _buildInfoRow(
                context,
                icon: Icons.calendar_month_outlined,
                title: context.l10n.service_booking_day,
                content: '$dayText - $timeText',
              ),
              12.verticalSpace,
              const AppDivider(),
              12.verticalSpace,
              // Customer Name
              _buildInfoRow(
                context,
                icon: Icons.person_outline_rounded,
                title: context.l10n.order_details_customer_name,
                content: customerName,
              ),
              12.verticalSpace,
              const AppDivider(),
              12.verticalSpace,
              // Customer Phone
              _buildInfoRow(
                context,
                icon: Icons.phone_android_rounded,
                title: context.l10n.order_details_customer_phone,
                content: customerPhone,
              ),
              if (customerEmail.isNotEmpty) ...[
                12.verticalSpace,
                const AppDivider(),
                12.verticalSpace,
                _buildInfoRow(
                  context,
                  icon: Icons.email_outlined,
                  title: context.l10n.service_booking_email,
                  content: customerEmail,
                ),
              ],
              if (hasAddress) ...[
                12.verticalSpace,
                const AppDivider(),
                12.verticalSpace,
                _buildInfoRow(
                  context,
                  icon: Icons.location_on_outlined,
                  title: context.l10n.order_details_address,
                  content: addressPath,
                ),
              ],
              12.verticalSpace,
              const AppDivider(),
              12.verticalSpace,
              // Problem Description
              _buildInfoRow(
                context,
                icon: Icons.description_outlined,
                title: context.l10n.service_booking_problem,
                content: problemDesc.isNotEmpty ? problemDesc : '---',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: cs.primary),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.verticalSpace,
              Text(
                content,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
