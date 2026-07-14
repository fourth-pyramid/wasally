import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_bloc.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_event.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'offers_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async =>
            !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance
                .setHasSeenShowcase('offers_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => BlocProvider(
            create: (context) => sl<OffersBloc>()..add(GetOffersEvent()),
            child: const OffersView(),
          ),
        ),
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

              if (status.isSuccess && products.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ShowCaseWidget.of(context).startShowCase([
                      AppShowcaseKeys.offersPromotions,
                    ]);
                  }
                });
              }

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
                  itemBuilder: (context, product, index, wrapAnimation) {
                    final card = AppUnifiedCard(
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
                    );

                    final wrappedCard = wrapAnimation(card);

                    if (index == 0) {
                      return AppShowcase(
                        showcaseKey: AppShowcaseKeys.offersPromotions,
                        title: context.l10n.showcase_offers_promotions_title,
                        description: context.l10n.showcase_offers_promotions_desc,
                        isLast: true,
                        child: wrappedCard,
                      );
                    }
                    return wrappedCard;
                  },
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
