import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/product_details/domain/entities/product_detail_entity.dart';
import 'package:wassaly/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:wassaly/features/product_details/presentation/bloc/product_details_state.dart';
import 'package:wassaly/features/product_details/presentation/screens/product_reviews_page.dart';
import 'package:wassaly/features/product_details/presentation/widgets/product_details_meta_chip.dart';
import 'package:wassaly/features/product_details/presentation/widgets/product_review_form_sheet.dart';
import 'package:wassaly/features/product_details/presentation/widgets/product_specifications_grid.dart';
import 'package:wassaly/features/product_details/presentation/widgets/related_products_section.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_provider_card.dart';

class ProductDetailsInfo extends StatelessWidget {
  final ProductDetailEntity product;
  final RelatedProductsStatus relatedProductsStatus;
  final List<ProductEntity> relatedProducts;

  const ProductDetailsInfo({
    required this.product, required this.relatedProductsStatus, required this.relatedProducts, super.key,
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
                          '${finalPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.secondary,
                          ),
                        ),
                        if (product.hasOffer)
                          Text(
                            '${price.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
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
              BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
                selector: (state) => (
                  state.favoriteIds.contains(product.id) ||
                      (!state.hasLoaded && product.isFavorite),
                  state.togglingIds.contains(product.id),
                ),
                builder: (context, status) {
                  final isFavorite = status.$1;
                  final isToggling = status.$2;
                  return IconButton(
                    onPressed: isToggling
                        ? null
                        : () async {
                            final bloc = context.read<FavoriteBloc>();
                            await HapticFeedback.lightImpact(); // ponytail: native light haptic impact on favorite button tap
                            bloc.add(
                                  ToggleFavoriteEvent(
                                    product.id,
                                    expectedIsFavorite: isFavorite,
                                  ),
                                );
                          },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? cs.error : cs.outline,
                      size: 28.r,
                    ),
                  );
                },
              ),
            ],
          ),
          12.verticalSpace,
          _ProductMeta(product: product),
          24.verticalSpace,
          Text(
            context.l10n.product_details_description,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
          12.verticalSpace,
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
          if (product.provider != null) ...[
            8.verticalSpace,
            Text(
              context.l10n.service_details_provider,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            12.verticalSpace,
            ServiceProviderCard(provider: product.provider!),
          ],
          if (product.reviews.isNotEmpty || currentUserId != null) ...[
            24.verticalSpace,
            _ReviewsSection(
              product: product,
              currentUserId: currentUserId,
            ),
          ],
          12.verticalSpace,
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
          12.verticalSpace,
          OutlinedButton.icon(
            onPressed: () => _showReviewSheet(context),
            icon: const Icon(Icons.rate_review_outlined),
            label: Text(context.l10n.product_details_add_review),
          ),
        ],
        if (previewReviews.isNotEmpty) ...[
          12.verticalSpace,
          ...previewReviews.map(
            (review) {
              final isMine = currentUserId != null &&
                  review.user.id.toString() == currentUserId;

              return AppReviewCard(
                rating: review.rating,
                comment: review.comment,
                userName: review.user.name,
                userAvatar: review.user.avatar,
                isCurrentUserReview: isMine,
                canEdit: isMine && ReviewHelper.canEditReview(review.createdAt),
                createdAt: review.createdAt,
                onEdit: () => _showReviewSheet(context, review: review),
              );
            },
          ),
          if (reviews.length > 3)
            Align(
              child: GestureDetector(
                onTap: () => _openAllReviews(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.product_details_show_more,
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

  void _showReviewSheet(
    BuildContext context, {
    ProductDetailReviewEntity? review,
  }) {
    unawaited(
      context.showAppBottomSheet<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ProductDetailsBloc>(),
          child: ProductReviewFormSheet(
            productId: product.id,
            review: review,
          ),
        ),
      ),
    );
  }

  void _openAllReviews(BuildContext context) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<ProductDetailsBloc>(),
            child: ProductReviewsPage(productId: product.id),
          ),
        ),
      ),
    );
  }
}

class _ProductMeta extends StatelessWidget {
  final ProductDetailEntity product;

  const _ProductMeta({required this.product});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          if (product.brand != null)
            ProductDetailsMetaChip(
              icon: Icons.verified_outlined,
              label:
                  '${context.l10n.product_details_brand}: ${product.brand!.name}',
            ),
          if (product.subCategory != null)
            ProductDetailsMetaChip(
              icon: Icons.category_outlined,
              label:
                  '${context.l10n.product_details_sub_category}: ${product.subCategory!.name}',
            ),
        ],
      );
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
        color: context.appColors.successContainer,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.product_details_discount,
            style: tt.labelSmall?.copyWith(
              color: context.appColors.onSuccessContainer,
              fontWeight: FontWeight.w800,
              height: 1.h,
            ),
          ),
          2.verticalSpace,
          Text(
            '$discountPercentage%',
            style: tt.labelSmall?.copyWith(
              color: context.appColors.onSuccessContainer,
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
          '${context.l10n.product_details_reviews} (${reviews.length})',
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
