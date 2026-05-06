import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/domain/entities/favorite_entity.dart';
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

class _FavoriteView extends StatelessWidget {
  const _FavoriteView();

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
            if (state.isLoading) {
              return CustomScrollView(
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
                  Skeletonizer.sliver(
                    enabled: true,
                    ignoreContainers: true,
                    child: SliverProductGrid<FavoriteEntity>(
                      items: List.generate(
                        4,
                        (index) => const FavoriteEntity(
                          id: 0,
                          name: 'Skeleton Loading',
                          image: '',
                          price: '0',
                          description: 'Skeleton',
                          isFavorite: true,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      itemBuilder: (context, favorite, index, wrapAnimation) {
                        return wrapAnimation(
                          ProductCard(
                            product: _convertToProductEntity(favorite),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state.isError) {
              return AppErrorWidget(
                title: 'errors.error_title'.tr(),
                message: state.errorMessage ?? 'errors.unknown_error'.tr(),
                onRetry: () =>
                    context.read<FavoriteBloc>().add(const GetFavoritesEvent()),
              );
            }

            if (state.isEmpty) {
              return AppEmptyState(
                icon: Icons.favorite_outline,
                title: 'favorite.no_favorites'.tr(),
                subtitle: 'favorite.no_favorites_subtitle'.tr(),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FavoriteBloc>().add(const GetFavoritesEvent());
                await context
                    .read<FavoriteBloc>()
                    .stream
                    .firstWhere((s) => !s.isLoading);
              },
              color: cs.primary,
              backgroundColor: cs.surface,
              child: CustomScrollView(
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
                  SliverProductGrid<FavoriteEntity>(
                    items: state.favorites.data,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    itemBuilder: (context, favorite, index, wrapAnimation) {
                      return wrapAnimation(
                        ProductCard(
                          product: _convertToProductEntity(favorite),
                          onTap: () {
                            // TODO: Navigate to product details
                          },
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

  ProductEntity _convertToProductEntity(FavoriteEntity favorite) {
    return ProductEntity(
      id: favorite.id,
      name: favorite.name,
      image: favorite.image,
      price: favorite.price,
      description: favorite.description,
      offers: const [],
      reviews: const [],
      isFavorite: favorite.isFavorite,
    );
  }
}
