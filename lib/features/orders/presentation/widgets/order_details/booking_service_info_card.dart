import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class BookingServiceInfoCard extends StatelessWidget {
  final BookingEntity booking;
  final GlobalKey? providerShowcaseKey;

  const BookingServiceInfoCard({
    required this.booking,
    this.providerShowcaseKey,
    super.key,
  });

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
        if (providerShowcaseKey != null)
          AppShowcase(
            showcaseKey: providerShowcaseKey!,
            title: context.l10n.showcase_booking_details_provider_title,
            description: context.l10n.showcase_booking_details_provider_desc,
            isLast: true,
            child: AppCard(
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
          )
        else
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
