import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  FavoriteBloc(
    this.getFavoritesUseCase,
    this.toggleFavoriteUseCase,
  ) : super(const FavoriteState()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    // Show loading skeleton on the very first load; subsequent refreshes
    // use the 'refreshing' status so the UI keeps the current list visible
    // while the RefreshIndicator can detect fetch completion.
    emit(state.copyWith(
      status: state.status == FavoriteStatus.initial
          ? FavoriteStatus.loading
          : FavoriteStatus.refreshing,
      errorMessage: null,
    ));

    final result = await getFavoritesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: failure.message,
      )),
      (favorites) {
        emit(state.copyWith(
          status: FavoriteStatus.success,
          favorites: favorites,
          favoriteIds: favorites.data.map((f) => f.id).toSet(),
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    // Determine the authoritative current status.
    // Once the global set has been loaded we trust [favoriteIds];
    // otherwise we trust the UI's [expectedIsFavorite] fallback.
    final isCurrentlyFavorite = state.hasLoaded
        ? state.favoriteIds.contains(event.productId)
        : event.expectedIsFavorite;

    debugPrint(
      '[FavoriteBloc] Toggle ${event.productId} — currentlyFavorite: $isCurrentlyFavorite',
    );

    // Save the entity in case we need to rollback a removal on the
    // Favorites page (where the product is already in favorites.data).
    ProductEntity? removedEntity;
    if (isCurrentlyFavorite) {
      for (final f in state.favorites.data) {
        if (f.id == event.productId) {
          removedEntity = f;
          break;
        }
      }
    }

    // Optimistic update: immediately add/remove from the local set
    // and, if removing from the Favorites page, evict from the list too.
    final optimisticIds = Set<int>.from(state.favoriteIds)
      ..add(event.productId);
    if (isCurrentlyFavorite) {
      optimisticIds.remove(event.productId);
    }

    final optimisticFavorites = removedEntity != null
        ? state.favorites.copyWith(
            data: state.favorites.data
                .where((f) => f.id != event.productId)
                .toList(),
            total: state.favorites.total > 0 ? state.favorites.total - 1 : 0,
          )
        : state.favorites;

    emit(state.copyWith(
      favoriteIds: optimisticIds,
      favorites: optimisticFavorites,
      togglingIds: {...state.togglingIds, event.productId},
      errorMessage: null,
    ));

    debugPrint(
      '[FavoriteBloc] Optimistic — favoriteIds: ${state.favoriteIds}, '
      'favorites.count=${state.favorites.data.length}, togglingIds: ${state.togglingIds}',
    );

    // Persist the change via the domain layer.
    final result = await toggleFavoriteUseCase(
      productId: event.productId,
      isCurrentlyFavorite: isCurrentlyFavorite,
    );

    result.fold(
      (failure) {
        debugPrint(
          '[FavoriteBloc] Toggle FAILED for ${event.productId}: ${failure.message}',
        );

        // Rollback on failure: restore the previous state.
        final rollbackIds = Set<int>.from(state.favoriteIds)
          ..add(event.productId);
        if (isCurrentlyFavorite) {
          rollbackIds.remove(event.productId);
        }

        final rollbackFavorites = removedEntity != null
            ? state.favorites.copyWith(
                data: [...state.favorites.data, removedEntity],
                total: state.favorites.total + 1,
              )
            : state.favorites;

        final rollbackToggling = Set<int>.from(state.togglingIds)
          ..remove(event.productId);

        emit(state.copyWith(
          favoriteIds: rollbackIds,
          favorites: rollbackFavorites,
          togglingIds: rollbackToggling,
          errorMessage: failure.message,
        ));

        debugPrint(
          '[FavoriteBloc] Rollback — favoriteIds: $rollbackIds, '
          'favorites.count=${rollbackFavorites.data.length}',
        );
      },
      (_) {
        debugPrint(
          '[FavoriteBloc] Toggle SUCCESS for ${event.productId}',
        );

        // Success: clear the toggling flag.
        final updatedToggling = Set<int>.from(state.togglingIds)
          ..remove(event.productId);

        emit(state.copyWith(
          togglingIds: updatedToggling,
          errorMessage: null,
        ));

        debugPrint(
          '[FavoriteBloc] Success emit — favoriteIds: ${state.favoriteIds}, '
          'favorites.count=${state.favorites.data.length}, togglingIds: ${state.togglingIds}',
        );

        // Re-fetch only when ADDING a favorite so the new product
        // appears in the Favorites page list. Skip on removal —
        // the optimistic update already handled it without flicker.
        if (!isCurrentlyFavorite) {
          add(const GetFavoritesEvent());
        }
      },
    );
  }
}
