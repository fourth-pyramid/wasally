import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/product_detail_entity.dart';

class ProductReviewCard extends StatelessWidget {
  final ProductDetailReviewEntity review;
  final bool isCurrentUserReview;
  final bool canEdit;
  final VoidCallback? onEdit;

  const ProductReviewCard({
    super.key,
    required this.review,
    this.isCurrentUserReview = false,
    this.canEdit = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(cs, tt),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  review.user.name,
                  style: tt.titleSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14.r,
                    color: index < review.rating ? cs.secondary : cs.outline,
                  ),
                ),
              ),
              if (isCurrentUserReview) ...[
                4.horizontalSpace,
                PopupMenuButton<String>(
                  tooltip: 'product_details.review_options'.tr(),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20.r,
                    color: cs.onSurfaceVariant,
                  ),
                  onSelected: (_) => onEdit?.call(),
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      enabled: canEdit,
                      child: Text(
                        canEdit
                            ? 'shared.edit'.tr()
                            : 'product_details.edit_time_expired'.tr(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          8.verticalSpace,
          Text(
            review.comment,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme cs, TextTheme tt) {
    final hasAvatar =
        review.user.avatar != null && review.user.avatar!.isNotEmpty;

    if (hasAvatar) {
      return ClipOval(
        child: CommonImage(
          width: 32.w,
          height: 24.h,
          memCacheHeight: 32 * 3,
          imageUrl: review.user.avatar!,
        ),
      );
    }

    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        review.user.name.isNotEmpty
            ? review.user.name.trim()[0].toUpperCase()
            : '?',
        style: tt.titleSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
