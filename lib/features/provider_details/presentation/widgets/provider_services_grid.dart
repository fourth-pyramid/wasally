import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class ProviderServicesGrid extends StatelessWidget {
  final List<ServiceEntity> services;

  const ProviderServicesGrid({
    required this.services,
    super.key,
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
          itemBuilder: (context, service, index, wrapAnimation) =>
              wrapAnimation(
            AppUnifiedCard(
              id: service.id,
              type: UnifiedItemType.service,
              title: service.title,
              description: service.description,
              image: service.image,
              price: service.price.toString(),
              isFavorite: service.isFavorite,
              activeIdNotifier: _activeMarqueeId,
              onTap: () => context.push(
                AppRoutes.serviceDetails,
                extra: {'serviceId': service.id},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
