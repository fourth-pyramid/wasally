import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class ServiceFavoritesTab extends StatelessWidget {
  const ServiceFavoritesTab({super.key});
  // Manual ScrollController removed in favor of AppSliverGrid's built-in pagination

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<FavoriteBloc, FavoriteState,
        (FavoriteStatus, PaginatedResponse<ServiceEntity>, Failure?, bool)>(
      selector: (state) => (
        state.serviceStatus,
        state.serviceFavorites,
        state.serviceFailure,
        state.isServiceLoadingMore
      ),
      builder: (context, data) {
        final (status, serviceFavorites, failure, isLoadingMore) = data;
        final isLoading = status == FavoriteStatus.loading ||
            (status == FavoriteStatus.refreshing &&
                serviceFavorites.data.isEmpty);
        final isError = status == FavoriteStatus.error;
        final bloc = context.read<FavoriteBloc>();
        final l10n = context.l10n;

        return RefreshIndicator(
          onRefresh: () async {
            bloc.add(const GetServiceFavoritesEvent());
            await bloc.stream.firstWhere(
              (s) =>
                  s.serviceStatus == FavoriteStatus.success ||
                  s.serviceStatus == FavoriteStatus.error,
            );
          },
          color: cs.primary,
          backgroundColor: cs.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isLoading || serviceFavorites.data.isNotEmpty)
                AppUnifiedSection<ServiceEntity>(
                  isLoading: isLoading,
                  items: isLoading ? const [] : serviceFavorites.data,
                  dummyItems: const [
                    ServiceEntity(
                      id: 1,
                      title: 'خدمة',
                      description: '',
                      price: 0,
                      isFavorite: false,
                    ),
                  ],
                  hasMore: serviceFavorites.hasMore,
                  isLoadingMore: isLoadingMore,
                  onLoadMore: () =>
                      bloc.add(const LoadMoreServiceFavoritesEvent()),
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 190.h,
                  itemBuilder: (context, service, index, wrapAnimation) =>
                      wrapAnimation(
                    AppUnifiedCard(
                      id: service.id,
                      type: UnifiedItemType.service,
                      title: service.title,
                      description: service.description,
                      image: service.image,
                      price: service.price.toString(),
                      isFavorite: service.isFavorite,
                      activeIdNotifier: _activeMarqueeId,
                      onTap: () => context.push(
                        AppRoutes.serviceDetails,
                        extra: {'serviceId': service.id},
                      ),
                    ),
                  ),
                )
              else if (isError && serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure:
                          failure ?? const UnknownFailure('An error occurred'),
                      onRetry: () => bloc.add(const GetServiceFavoritesEvent()),
                    ),
                  ),
                )
              else if (serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: l10n.favorite_no_services,
                      subtitle: l10n.favorite_no_services_subtitle,
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
