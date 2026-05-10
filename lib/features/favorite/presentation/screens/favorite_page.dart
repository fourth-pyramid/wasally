import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavoriteView();
  }
}

class _FavoriteView extends StatefulWidget {
  const _FavoriteView();

  @override
  State<_FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<_FavoriteView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<FavoriteBloc>().state;
    if (state.status == FavoriteStatus.initial) {
      context.read<FavoriteBloc>().add(const GetFavoritesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: BlocListener<FavoriteBloc, FavoriteState>(
        listenWhen: (previous, current) =>
            previous.favorites.data.length != current.favorites.data.length &&
            current.favorites.data.length < previous.favorites.data.length,
        listener: (context, state) {
          context.showTypedSnackBar(
            'favorite.removed_from_favorites'.tr(),
            type: SnackBarType.success,
          );
        },
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.favorites != current.favorites ||
              previous.errorMessage != current.errorMessage,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<FavoriteBloc>();
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
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: cs.surface,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(
                      'favorite.favorite_title'.tr(),
                      style: context.typography.titleLarge
                          ?.copyWith(color: cs.primary),
                    ),
                  ),
                  if (state.isLoading)
                    Skeletonizer.sliver(
                      enabled: true,
                      ignoreContainers: true,
                      child: SliverProductGrid<ProductEntity>(
                        items: List.generate(
                          4,
                          (index) => const ProductEntity(
                            id: 0,
                            name: 'Skeleton Loading',
                            image: '',
                            price: '0',
                            description: 'Skeleton',
                            offers: [],
                            reviews: [],
                            isFavorite: true,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        itemBuilder: (context, product, index, wrapAnimation) {
                          return wrapAnimation(
                            ProductCard(
                              product: product,
                            ),
                          );
                        },
                      ),
                    )
                  else if (state.isError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppErrorWidget(
                          title: 'errors.error_title'.tr(),
                          message:
                              state.errorMessage ?? 'errors.unknown_error'.tr(),
                          onRetry: () => context
                              .read<FavoriteBloc>()
                              .add(const GetFavoritesEvent()),
                        ),
                      ),
                    )
                  else if (state.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppEmptyState(
                          icon: Icons.favorite_outline,
                          title: 'favorite.no_favorites'.tr(),
                          subtitle: 'favorite.no_favorites_subtitle'.tr(),
                        ),
                      ),
                    )
                  else
                    SliverProductGrid<ProductEntity>(
                      items: state.favorites.data,
                      itemKey: (product) => ValueKey(product.id),
                      animateItems: false,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      itemBuilder: (context, product, index, wrapAnimation) {
                        return wrapAnimation(
                          ProductCard(
                            product: product,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
