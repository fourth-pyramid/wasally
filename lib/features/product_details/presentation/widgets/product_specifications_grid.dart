import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/product_detail_entity.dart';

class ProductSpecificationsGrid extends StatelessWidget {
  final List<ProductSpecificationEntity> specifications;

  const ProductSpecificationsGrid({
    super.key,
    required this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: specifications.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemBuilder: (context, index) {
        final item = specifications[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              if (item.icon.isNotEmpty)
                CommonImage(
                  imageUrl: item.icon,
                  width: 25.w,
                  memCacheWidth: 25 * 3,
                  fit: BoxFit.cover,
                ),
              12.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.key,
                    style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    item.value,
                    style: tt.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
