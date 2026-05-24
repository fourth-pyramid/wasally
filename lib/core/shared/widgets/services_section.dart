import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';
import 'package:wassaly/core/shared/widgets/service_card.dart';

class AppServicesSection extends StatelessWidget {
  final List<ServiceEntity> services;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final bool isLoading;

  // Grid properties
  final double childAspectRatio;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  static const _dummyServices = [
    ServiceEntity(
      id: 1,
      title: 'خدمة تجريبية طويلة جدا للتجربة',
      image: '',
      price: 100,
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      isFavorite: false,
    ),
    ServiceEntity(
      id: 2,
      title: 'خدمة تجريبية طويلة جدا للتجربة',
      image: '',
      price: 100,
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      isFavorite: false,
    ),
    ServiceEntity(
      id: 3,
      title: 'خدمة تجريبية طويلة جدا للتجربة',
      image: '',
      price: 100,
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      isFavorite: false,
    ),
    ServiceEntity(
      id: 4,
      title: 'خدمة تجريبية طويلة جدا للتجربة',
      image: '',
      price: 100,
      description: 'وصف تجريبي طويل جدا للتجربة وعرض التفاصيل بشكل كامل',
      isFavorite: false,
    ),
  ];

  const AppServicesSection({
    super.key,
    required this.services,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.isLoading = false,
    this.childAspectRatio = 0.50,
    this.mainAxisExtent,
    this.crossAxisCount = 2,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final displayServices =
        isLoading && services.isEmpty ? _dummyServices : services;

    return Skeletonizer.sliver(
      enabled: isLoading,
      ignoreContainers: true,
      child: SliverMainAxisGroup(
        slivers: [
          AppSliverGrid<ServiceEntity>(
            padding: padding ?? EdgeInsets.zero,
            childAspectRatio: childAspectRatio,
            mainAxisExtent: mainAxisExtent,
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            items: displayServices,
            hasMore: hasMore && !isLoadingMore && !isLoading,
            onLoadMore: onLoadMore,
            animateItems: !isLoading,
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
      ),
    );
  }
}
