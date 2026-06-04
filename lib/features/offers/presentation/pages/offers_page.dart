import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_bloc.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_event.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => sl<OffersBloc>()..add(GetOffersEvent()),
        child: const OffersView(),
      );
}

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  void _onLoadMore(BuildContext context, AppStatus status) {
    if (status != AppStatus.loading) {
      context.read<OffersBloc>().add(LoadMoreOffersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          AppSliverTopBar(
            titleWidget: Text(
              l10n.offers,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
          BlocSelector<OffersBloc, OffersState,
              (AppStatus, List<ProductEntity>, bool, String)>(
            selector: (state) => (
              state.status,
              state.products,
              state.hasReachedMax,
              state.errorMessage,
            ),
            builder: (context, data) {
              final (status, products, hasReachedMax, errorMessage) = data;

              final isLoading = status == AppStatus.loading && products.isEmpty;

              if (isLoading || products.isNotEmpty) {
                return AppUnifiedSection<ProductEntity>(
                  isLoading: isLoading,
                  items: isLoading ? const [] : products,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                  hasMore: !isLoading && !hasReachedMax,
                  isLoadingMore: !isLoading && (status == AppStatus.loading),
                  mainAxisExtent: 240.h,
                  onLoadMore:
                      isLoading ? null : () => _onLoadMore(context, status),
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
                );
              }

              if (status == AppStatus.failure) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    message: errorMessage,
                    onRetry: () =>
                        context.read<OffersBloc>().add(GetOffersEvent()),
                  ),
                );
              }

              return SliverFillRemaining(
                child: AppEmptyState(
                  title: l10n.errors_something_went_wrong,
                  icon: Icons.local_offer_outlined,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
