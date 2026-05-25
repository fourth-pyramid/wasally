import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_service_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_service_favorite_usecase.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final GetServiceFavoritesUseCase getServiceFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final ToggleServiceFavoriteUseCase toggleServiceFavoriteUseCase;

  StreamSubscription<void>? _connectivitySub;

  FavoriteBloc(
    this.getFavoritesUseCase,
    this.getServiceFavoritesUseCase,
    this.toggleFavoriteUseCase,
    this.toggleServiceFavoriteUseCase,
  ) : super(const FavoriteState()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<GetServiceFavoritesEvent>(_onGetServiceFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleServiceFavoriteEvent>(_onToggleServiceFavorite);
    on<ClearFavoritesEvent>(_onClearFavorites);

    _connectivitySub =
        sl<InternetConnectionService>().connectivityRestoredStream.listen((_) {
      add(const GetFavoritesEvent());
      add(const GetServiceFavoritesEvent());
    });
  }

  void _onClearFavorites(
    ClearFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) {
    emit(const FavoriteState());
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
      failure: null,
    ));

    final result = await getFavoritesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoriteStatus.error,
        failure: failure,
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

  Future<void> _onGetServiceFavorites(
    GetServiceFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(
      serviceStatus: state.serviceStatus == FavoriteStatus.initial
          ? FavoriteStatus.loading
          : FavoriteStatus.refreshing,
      serviceFailure: null,
    ));

    final result = await getServiceFavoritesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        serviceStatus: FavoriteStatus.error,
        serviceFailure: failure,
      )),
      (favorites) {
        emit(state.copyWith(
          serviceStatus: FavoriteStatus.success,
          serviceFavorites: favorites,
          serviceFavoriteIds: favorites.data.map((f) => f.id).toSet(),
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

    assert(() {
      debugPrint('[FavoriteBloc] Toggle ${event.productId} — currentlyFavorite: $isCurrentlyFavorite');
      return true;
    }());

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
      failure: null,
    ));

    // Persist the change via the domain layer.
    final result = await toggleFavoriteUseCase(
      productId: event.productId,
      isCurrentlyFavorite: isCurrentlyFavorite,
    );

    result.fold(
      (failure) {
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
          failure: failure,
        ));
      },
      (_) {
        // Success: clear the toggling flag.
        final updatedToggling = Set<int>.from(state.togglingIds)
          ..remove(event.productId);

        emit(state.copyWith(
          togglingIds: updatedToggling,
          failure: null,
        ));

        // Re-fetch only when ADDING a favorite so the new product
        // appears in the Favorites page list. Skip on removal —
        // the optimistic update already handled it without flicker.
        if (!isCurrentlyFavorite) {
          add(const GetFavoritesEvent());
        }
      },
    );
  }

  Future<void> _onToggleServiceFavorite(
    ToggleServiceFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final isCurrentlyFavorite = event.expectedIsFavorite;

    // Save the entity in case we need to rollback a removal on the
    // Favorites page (where the service is already in serviceFavorites.data).
    ServiceEntity? removedEntity;
    if (isCurrentlyFavorite) {
      for (final f in state.serviceFavorites.data) {
        if (f.id == event.serviceId) {
          removedEntity = f;
          break;
        }
      }
    }

    // Optimistic update: immediately add/remove from the service favorite set
    final optimisticIds = Set<int>.from(state.serviceFavoriteIds);
    if (isCurrentlyFavorite) {
      optimisticIds.remove(event.serviceId);
    } else {
      optimisticIds.add(event.serviceId);
    }

    final optimisticFavorites = removedEntity != null
        ? state.serviceFavorites.copyWith(
            data: state.serviceFavorites.data
                .where((f) => f.id != event.serviceId)
                .toList(),
            total: state.serviceFavorites.total > 0
                ? state.serviceFavorites.total - 1
                : 0,
          )
        : state.serviceFavorites;

    emit(state.copyWith(
      serviceFavoriteIds: optimisticIds,
      serviceFavorites: optimisticFavorites,
      serviceTogglingIds: {...state.serviceTogglingIds, event.serviceId},
      failure: null,
    ));

    // Persist the change via the domain layer.
    final result = await toggleServiceFavoriteUseCase(
      serviceId: event.serviceId,
      isCurrentlyFavorite: isCurrentlyFavorite,
    );

    result.fold(
      (failure) {
        // Rollback on failure
        final rollbackIds = Set<int>.from(state.serviceFavoriteIds);
        if (isCurrentlyFavorite) {
          rollbackIds.add(event.serviceId);
        } else {
          rollbackIds.remove(event.serviceId);
        }

        final rollbackFavorites = removedEntity != null
            ? state.serviceFavorites.copyWith(
                data: [...state.serviceFavorites.data, removedEntity],
                total: state.serviceFavorites.total + 1,
              )
            : state.serviceFavorites;

        final rollbackToggling = Set<int>.from(state.serviceTogglingIds)
          ..remove(event.serviceId);

        emit(state.copyWith(
          serviceFavoriteIds: rollbackIds,
          serviceFavorites: rollbackFavorites,
          serviceTogglingIds: rollbackToggling,
          failure: failure,
        ));
      },
      (_) {
        // Success: clear the toggling flag.
        final updatedToggling = Set<int>.from(state.serviceTogglingIds)
          ..remove(event.serviceId);

        emit(state.copyWith(
          serviceTogglingIds: updatedToggling,
          failure: null,
        ));

        if (!isCurrentlyFavorite) {
          add(const GetServiceFavoritesEvent());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
