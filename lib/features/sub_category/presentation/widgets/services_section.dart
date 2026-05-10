import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

import 'service_card.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceEntity> services;

  const ServicesSection({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              'home.services'.tr(),
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
        ),
        SliverProductGrid<ServiceEntity>(
          items: services,
          itemBuilder: (context, service, index, wrapAnimation) {
            return wrapAnimation(
              ServiceCard(
                service: service,
                onTap: () {
                  // TODO: Navigate to service detail
                },
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: 16.verticalSpace,
        ),
      ],
    );
  }
}
