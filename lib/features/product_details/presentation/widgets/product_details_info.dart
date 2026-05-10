import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_state.dart';
import '../screens/product_reviews_page.dart';
import 'product_details_meta_chip.dart';
import 'product_review_card.dart';
import 'product_review_form_sheet.dart';
import 'product_specifications_grid.dart';
import 'related_products_section.dart';

class ProductDetailsInfo extends StatelessWidget {
  final ProductDetailEntity product;
  final RelatedProductsStatus relatedProductsStatus;
  final List<ProductEntity> relatedProducts;

  const ProductDetailsInfo({
    super.key,
    required this.product,
    required this.relatedProductsStatus,
    required this.relatedProducts,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final price = double.tryParse(product.price) ?? 0;
    final finalPrice = product.hasOffer ? product.discountedPrice : price;
    final currentUserId = _currentUserId(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    8.verticalSpace,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        Text(
                          '${finalPrice.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.secondary,
                          ),
                        ),
                        if (product.hasOffer)
                          Text(
                            '${price.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
                            style: tt.bodyLarge?.copyWith(
                              color: cs.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: cs.error,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (product.hasOffer) ...[
                8.horizontalSpace,
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: _OfferBadge(
                    discountPercentage: product.discountPercentage,
                  ),
                ),
              ],
            ],
          ),
          10.verticalSpace,
          _ProductMeta(product: product),
          12.verticalSpace,
          Text(
            'product_details.description'.tr(),
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
          8.verticalSpace,
          Text(
            product.description,
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          if (product.specifications.isNotEmpty) ...[
            ProductSpecificationsGrid(specifications: product.specifications),
          ],
          if (product.reviews.isNotEmpty || currentUserId != null) ...[
            8.verticalSpace,
            _ReviewsSection(
              product: product,
              currentUserId: currentUserId,
            ),
          ],
          20.verticalSpace,
          RelatedProductsSection(
            status: relatedProductsStatus,
            products: relatedProducts,
            canLoad: (product.subCategory?.id ?? 0) > 0,
          ),
          24.verticalSpace,
        ],
      ),
    );
  }

  String? _currentUserId(BuildContext context) {
    final sessionState = context.watch<SessionBloc>().state;
    return sessionState is SessionAuthenticated ? sessionState.user.id : null;
  }
}

class _ReviewsSection extends StatelessWidget {
  final ProductDetailEntity product;
  final String? currentUserId;

  const _ReviewsSection({
    required this.product,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final reviews = product.reviews;
    final previewReviews = reviews.take(3).toList();
    final hasCurrentUserReview = currentUserId != null &&
        reviews.any((review) => review.user.id.toString() == currentUserId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewsHeader(reviews: reviews),
        if (currentUserId != null && !hasCurrentUserReview) ...[
          10.verticalSpace,
          OutlinedButton.icon(
            onPressed: () => _showReviewSheet(context),
            icon: const Icon(Icons.rate_review_outlined),
            label: Text('product_details.add_review'.tr()),
          ),
        ],
        if (previewReviews.isNotEmpty) ...[
          10.verticalSpace,
          ...previewReviews.map(
            (review) {
              final isMine = currentUserId != null &&
                  review.user.id.toString() == currentUserId;

              return ProductReviewCard(
                review: review,
                isCurrentUserReview: isMine,
                canEdit: isMine && _canEditReview(review.createdAt),
                onEdit: () => _showReviewSheet(context, review: review),
              );
            },
          ),
          if (reviews.length > 3)
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _openAllReviews(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'product_details.show_more'.tr(),
                      style: tt.titleSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.expand_more_rounded,
                      size: 18.r,
                      color: cs.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  bool _canEditReview(String createdAt) {
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return false;

    final now = DateTime.now();
    final hasTimezone = RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
        .hasMatch(createdAt.trim());
    final candidates = <DateTime>[
      createdDate.toLocal(),
      if (!hasTimezone)
        DateTime.utc(
          createdDate.year,
          createdDate.month,
          createdDate.day,
          createdDate.hour,
          createdDate.minute,
          createdDate.second,
          createdDate.millisecond,
          createdDate.microsecond,
        ).toLocal(),
    ];

    return candidates.any((date) {
      final elapsed = now.difference(date);
      return elapsed >= const Duration(minutes: -5) &&
          elapsed < const Duration(hours: 1);
    });
  }

  void _showReviewSheet(
    BuildContext context, {
    ProductDetailReviewEntity? review,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ProductDetailsBloc>(),
        child: ProductReviewFormSheet(
          productId: product.id,
          review: review,
        ),
      ),
    );
  }

  void _openAllReviews(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ProductDetailsBloc>(),
          child: ProductReviewsPage(productId: product.id),
        ),
      ),
    );
  }
}

class _ProductMeta extends StatelessWidget {
  final ProductDetailEntity product;

  const _ProductMeta({required this.product});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (product.brand != null)
          ProductDetailsMetaChip(
            icon: Icons.verified_outlined,
            label: '${'product_details.brand'.tr()}: ${product.brand!.name}',
          ),
        if (product.subCategory != null)
          ProductDetailsMetaChip(
            icon: Icons.category_outlined,
            label:
                '${'product_details.sub_category'.tr()}: ${product.subCategory!.name}',
          ),
      ],
    );
  }
}

class _OfferBadge extends StatelessWidget {
  final int discountPercentage;

  const _OfferBadge({required this.discountPercentage});

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF79F29A),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'product_details.discount'.tr(),
            style: tt.labelSmall?.copyWith(
              color: const Color(0xFF067A2F),
              fontWeight: FontWeight.w800,
              height: 1.h,
            ),
          ),
          2.verticalSpace,
          Text(
            '$discountPercentage%',
            style: tt.labelSmall?.copyWith(
              color: const Color(0xFF067A2F),
              fontWeight: FontWeight.w800,
              height: 1.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsHeader extends StatelessWidget {
  final List<ProductDetailReviewEntity> reviews;

  const _ReviewsHeader({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.fold<int>(0, (sum, review) => sum + review.rating) /
            reviews.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${'product_details.reviews'.tr()} (${reviews.length})',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 18.r,
              color: cs.secondary,
            ),
            3.horizontalSpace,
            Text(
              averageRating.toStringAsFixed(1),
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
