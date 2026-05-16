import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';
import 'package:wassaly/core/shared/widgets/service_card.dart';

class AppServicesSection extends StatelessWidget {
  final List<ServiceEntity> services;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  // Grid properties
  final double childAspectRatio;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const AppServicesSection({
    super.key,
    required this.services,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.childAspectRatio = 0.50,
    this.mainAxisExtent,
    this.crossAxisCount = 2,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        AppSliverGrid<ServiceEntity>(
          padding: padding ?? EdgeInsets.zero,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          items: services,
          hasMore: hasMore && !isLoadingMore,
          onLoadMore: onLoadMore,
          itemBuilder: (context, service, index, wrapAnimation) {
            return wrapAnimation(
              ServiceCard(
                service: service,
              ),
            );
          },
        ),
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
