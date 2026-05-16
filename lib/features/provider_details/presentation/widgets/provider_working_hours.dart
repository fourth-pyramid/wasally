import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/provider_detail_entity.dart';

class ProviderWorkingHours extends StatelessWidget {
  final ProviderDetailEntity provider;

  const ProviderWorkingHours({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: cs.primary, size: 20.r),
              8.horizontalSpace,
              Text(
                context.l10n.provider_details_working_hours,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          16.verticalSpace,
          _buildInfoRow(
            context,
            context.l10n.provider_details_days,
            '${provider.fromDay} - ${provider.toDay}',
          ),
          12.verticalSpace,
          _buildInfoRow(
            context,
            context.l10n.provider_details_time,
            '${_formatTime(provider.startTime)} - ${_formatTime(provider.endTime)}',
          ),
          12.verticalSpace,
          _buildInfoRow(
            context,
            context.l10n.provider_details_price_from,
            '${provider.priceFrom} ${context.l10n.common_currency}',
            valueColor: cs.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(color: context.theme.colorScheme.outline)),
        Text(
          value,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
