import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';

import '../bloc/favorite_event.dart';
import '../bloc/favorite_state.dart';

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

    if (state.favorites.data.isEmpty && !state.isLoading) {
      context.read<FavoriteBloc>().add(const GetFavoritesEvent());
    }
    if (state.serviceFavorites.data.isEmpty && !state.isLoading) {
      context.read<FavoriteBloc>().add(const GetServiceFavoritesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppTopBar(
          title: context.l10n.favorite_favorite_title,
          bottom: TabBar(
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: context.l10n.favorite_products),
              Tab(text: context.l10n.favorite_services),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ProductFavoritesTab(),
            _ServiceFavoritesTab(),
          ],
        ),
      ),
    );
  }
}

class _ProductFavoritesTab extends StatelessWidget {
  const _ProductFavoritesTab();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.favorites != current.favorites ||
          previous.failure != current.failure,
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
              if (state.isLoading && state.favorites.data.isEmpty)
                const AppProductsSkeleton(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  mainAxisExtent: 220,
                )
              else if (state.isError && state.favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure: state.failure!,
                      onRetry: () => context
                          .read<FavoriteBloc>()
                          .add(const GetFavoritesEvent()),
                    ),
                  ),
                )
              else if (state.favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: context.l10n.favorite_no_favorites,
                      subtitle: context.l10n.favorite_no_favorites_subtitle,
                    ),
                  ),
                )
              else
                AppProductsSection(
                  products: state.favorites.data,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 230.h,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceFavoritesTab extends StatelessWidget {
  const _ServiceFavoritesTab();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.serviceFavorites != current.serviceFavorites ||
          previous.failure != current.failure,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<FavoriteBloc>();
            bloc.add(const GetServiceFavoritesEvent());
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
              if (state.isLoading && state.serviceFavorites.data.isEmpty)
                AppServicesSkeleton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  mainAxisExtent: 190.h,
                )
              else if (state.isError && state.serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure: state.failure!,
                      onRetry: () => context
                          .read<FavoriteBloc>()
                          .add(const GetServiceFavoritesEvent()),
                    ),
                  ),
                )
              else if (state.serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: context.l10n.favorite_no_favorites,
                      subtitle: context.l10n.favorite_no_favorites_subtitle,
                    ),
                  ),
                )
              else
                AppServicesSection(
                  services: state.serviceFavorites.data,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 190.h,
                ),
            ],
          ),
        );
      },
    );
  }
}
