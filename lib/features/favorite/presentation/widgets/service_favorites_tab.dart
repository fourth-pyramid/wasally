import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class ServiceFavoritesTab extends StatelessWidget {
  const ServiceFavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<FavoriteBloc, FavoriteState,
        (FavoriteStatus, PaginatedResponse<ServiceEntity>, Failure?)>(
      selector: (state) =>
          (state.status, state.serviceFavorites, state.failure),
      builder: (context, data) {
        final (status, serviceFavorites, failure) = data;
        final isLoading = status == FavoriteStatus.loading ||
            (status == FavoriteStatus.refreshing && serviceFavorites.data.isEmpty);
        final isError = status == FavoriteStatus.error;

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
              if (isLoading || serviceFavorites.data.isNotEmpty)
                AppServicesSection(
                  isLoading: isLoading,
                  services: isLoading ? const [] : serviceFavorites.data,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                  mainAxisExtent: 190.h,
                )
              else if (isError && serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget.failure(
                      failure: failure ?? const UnknownFailure('An error occurred'),
                      onRetry: () => context
                          .read<FavoriteBloc>()
                          .add(const GetServiceFavoritesEvent()),
                    ),
                  ),
                )
              else if (serviceFavorites.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.favorite_outline,
                      title: context.l10n.favorite_no_services,
                      subtitle: context.l10n.favorite_no_services_subtitle,
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
