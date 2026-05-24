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

    final rowsCount = (specifications.length / 2).ceil();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: List.generate(
          rowsCount,
          (rowIndex) {
            final firstIndex = rowIndex * 2;
            final secondIndex = firstIndex + 1;

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex == rowsCount - 1 ? 0 : 8.h,
              ),
              child: Row(
                children: [
                  // First item in the row
                  Expanded(
                    child:
                        _buildItem(context, cs, tt, specifications[firstIndex]),
                  ),
                  8.horizontalSpace,
                  // Second item in the row (if exists)
                  Expanded(
                    child: secondIndex < specifications.length
                        ? _buildItem(
                            context, cs, tt, specifications[secondIndex])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    ProductSpecificationEntity item,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          if (item.icon.isNotEmpty) ...[
            CommonImage(
              imageUrl: item.icon,
              height: 25,
              width: 25,
              memCacheHeight: 25 * 3,
              memCacheWidth: 25 * 3,
              fit: BoxFit.contain,
            ),
            12.horizontalSpace,
          ],
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
