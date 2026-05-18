import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/booking_entity.dart';

class BookingSuccessPage extends StatelessWidget {
  final BookingEntity booking;

  const BookingSuccessPage({
    super.key,
    required this.booking,
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
                context.l10n.service_booking_success_title,
                style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Text(
                context.l10n.service_booking_success_msg,
                style: tt.bodyLarge?.copyWith(color: cs.outline),
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              AppCard(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    _buildRow(context, context.l10n.service_booking_id,
                        '#${booking.id}'),
                    12.verticalSpace,
                    _buildRow(context, context.l10n.service_booking_service,
                        booking.service.name),
                    12.verticalSpace,
                    _buildRow(context, context.l10n.service_booking_provider,
                        booking.provider.name),
                    12.verticalSpace,
                    _buildRow(
                        context, context.l10n.service_booking_day, booking.day),
                    12.verticalSpace,
                    _buildRow(context, context.l10n.service_booking_time,
                        booking.time.to12HourFormat()),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: context.l10n.service_booking_go_home,
                onPressed: () => context.go(AppRoutes.home),
              ),
              16.verticalSpace,
              AppButton(
                label: context.l10n.service_booking_view_orders,
                variant: ButtonVariant.outline,
                onPressed: () => context.go(
                  AppRoutes.orders,
                  extra: {'initialIndex': 1},
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
        Text(label,
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(color: context.theme.colorScheme.outline)),
        Text(value,
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
