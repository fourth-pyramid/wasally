import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class ProductFavoritesTab extends StatelessWidget {
  const ProductFavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<FavoriteBloc, FavoriteState,
        (FavoriteStatus, PaginatedResponse<ProductEntity>, Failure?)>(
      selector: (state) => (state.status, state.favorites, state.failure),
      builder: (context, data) {
        final (status, favorites, failure) = data;
        final isLoading = status == FavoriteStatus.loading ||
            (status == FavoriteStatus.refreshing && favorites.data.isEmpty);
        final isError = status == FavoriteStatus.error;

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
              if (isLoading || favorites.data.isNotEmpty)
                AppProductsSection(
                  isLoading: isLoading,
                  products: isLoading ? const [] : favorites.data,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 230.h,
                )
              else if (isError && favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure: failure ?? const UnknownFailure('An error occurred'),
                      onRetry: () => context
                          .read<FavoriteBloc>()
                          .add(const GetFavoritesEvent()),
                    ),
                  ),
                )
              else if (favorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: context.l10n.favorite_no_products,
                      subtitle: context.l10n.favorite_no_products_subtitle,
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
