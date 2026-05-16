import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';
import 'package:wassaly/core/shared/widgets/service_card.dart';

class AppServicesSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final EdgeInsetsGeometry? padding;

  const AppServicesSkeleton({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.50,
    this.mainAxisExtent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppSliverGrid<ServiceEntity>(
      padding: padding ?? EdgeInsets.zero,
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisExtent: mainAxisExtent,
      items: List.generate(
        4,
        (index) => ServiceEntity(
          id: index,
          title: 'خدمة تجريبية',
          image: '',
          price: 100,
          description: 'وصف تجريبي',
          isFavorite: false,
        ),
      ),
      animateItems: false,
      itemBuilder: (context, service, index, wrapAnimation) {
        return Skeletonizer(
          ignoreContainers: true,
          enabled: true,
          child: ServiceCard(service: service),
        );
      },
    );
  }
}
