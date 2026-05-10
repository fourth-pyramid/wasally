import 'package:wassaly/core/imports/imports.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../bloc/product_details_state.dart';

class RelatedProductsSection extends StatelessWidget {
  final RelatedProductsStatus status;
  final List<ProductEntity> products;
  final bool canLoad;

  const RelatedProductsSection({
    super.key,
    required this.status,
    required this.products,
    required this.canLoad,
  });

  @override
  Widget build(BuildContext context) {
    if (status == RelatedProductsStatus.initial && !canLoad) {
      return const SizedBox.shrink();
    }

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'product_details.related_products'.tr(),
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        10.verticalSpace,
        if (status == RelatedProductsStatus.initial ||
            status == RelatedProductsStatus.loading)
          SizedBox(
            height: 245.h,
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (status == RelatedProductsStatus.failure || products.isEmpty)
          SizedBox(
            height: 70.h,
            child: Center(
              child: Text(
                'product_details.no_related_products'.tr(),
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 245.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => 10.horizontalSpace,
              itemBuilder: (context, index) => SizedBox(
                width: 165.w,
                child: ProductCard(product: products[index]),
              ),
            ),
          ),
      ],
    );
  }
}
