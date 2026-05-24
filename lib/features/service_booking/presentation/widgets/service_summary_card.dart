import 'package:wassaly/core/imports/imports.dart';

import '../../../service_details/domain/entities/service_detail_entity.dart';

class ServiceSummaryCard extends StatelessWidget {
  final ServiceDetailEntity service;

  const ServiceSummaryCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          CommonImage(
            imageUrl: service.image,
            width: 80,
            height: 80,
            memCacheHeight: 80 * 2,
            borderRadius: BorderRadius.circular(12.r),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.service,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                4.verticalSpace,
                Text(
                  service.provider.title,
                  style: tt.bodyMedium?.copyWith(color: cs.outline),
                ),
                8.verticalSpace,
                Text(
                  '${service.price} ${context.l10n.common_currency}',
                  style: tt.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
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
