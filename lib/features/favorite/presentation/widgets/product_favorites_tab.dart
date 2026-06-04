import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class ProductFavoritesTab extends StatelessWidget {
  const ProductFavoritesTab({super.key});
  // Manual ScrollController removed in favor of AppSliverGrid's built-in pagination

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<FavoriteBloc, FavoriteState,
        (FavoriteStatus, PaginatedResponse<ProductEntity>, Failure?, bool)>(
      selector: (state) =>
          (state.status, state.favorites, state.failure, state.isLoadingMore),
      builder: (context, data) {
        final (status, favorites, failure, isLoadingMore) = data;
        final isLoading = status == FavoriteStatus.loading ||
            (status == FavoriteStatus.refreshing && favorites.data.isEmpty);
        final isError = status == FavoriteStatus.error;
        final bloc = context.read<FavoriteBloc>();
        final l10n = context.l10n;

        return RefreshIndicator(
          onRefresh: () async {
            bloc.add(const GetFavoritesEvent());
            await bloc.stream.firstWhere(
              (s) =>
                  s.status == FavoriteStatus.success ||
                  s.status == FavoriteStatus.error,
            );
          },
          color: cs.primary,
          backgroundColor: cs.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isLoading || favorites.data.isNotEmpty)
                AppUnifiedSection<ProductEntity>(
                  isLoading: isLoading,
                  items: isLoading ? const [] : favorites.data,
                  dummyItems: const [
                    ProductEntity(
                      id: 1,
                      name: 'منتج',
                      image: '',
                      price: '0',
                      description: '',
                      offers: [],
                      reviews: [],
                      isFavorite: false,
                    ),
                  ],
                  hasMore: favorites.hasMore,
                  isLoadingMore: isLoadingMore,
                  onLoadMore: () => bloc.add(const LoadMoreFavoritesEvent()),
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 230.h,
                  itemBuilder: (context, product, index, wrapAnimation) =>
                      wrapAnimation(
                    AppUnifiedCard(
                      id: product.id,
                      title: product.name,
                      description: product.description,
                      image: product.image,
                      price: product.discountedPrice.toStringAsFixed(0),
                      originalPrice: product.hasOffer
                          ? (double.tryParse(product.price) ?? 0)
                              .toStringAsFixed(0)
                          : null,
                      discountPercentage:
                          product.hasOffer ? product.discountPercentage : null,
                      rating: product.averageRating,
                      reviewCount: product.reviewCount,
                      isFavorite: product.isFavorite,
                      activeIdNotifier: _activeMarqueeId,
                      onTap: () => context.push(
                        AppRoutes.productDetails,
                        extra: {'productId': product.id},
                      ),
                    ),
                  ),
                )
              else if (isError && favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure:
                          failure ?? const UnknownFailure('An error occurred'),
                      onRetry: () => bloc.add(const GetFavoritesEvent()),
                    ),
                  ),
                )
              else if (favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: l10n.favorite_no_products,
                      subtitle: l10n.favorite_no_products_subtitle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
