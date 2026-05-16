import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/shared/widgets/service_card.dart';

import '../../../sub_category/domain/entities/service_entity.dart';

class ProviderServicesGrid extends StatelessWidget {
  final List<ServiceEntity> services;

  const ProviderServicesGrid({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              context.l10n.provider_details_services,
              style: context.theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AppSliverGrid<ServiceEntity>(
          items: services,
          padding: EdgeInsets.zero,
          childAspectRatio: 0.74,
          itemBuilder: (context, service, index, wrapAnimation) {
            return wrapAnimation(
              ServiceCard(service: service),
            );
          },
        ),
      ],
    );
  }
}
