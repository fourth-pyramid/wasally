import 'package:wassaly/core/imports/packages_imports.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class GetFavoritesEvent extends FavoriteEvent {
  const GetFavoritesEvent();
}

class GetServiceFavoritesEvent extends FavoriteEvent {
  const GetServiceFavoritesEvent();
}

/// Toggles the favorite status of a single product.
///
/// [expectedIsFavorite] is the UI's current belief about the product's
/// favorite status (either from the global [favoriteIds] set or from the
/// local [ProductEntity.isFavorite] fallback). The bloc uses this to decide
/// whether to call the "add" or "remove" repository endpoint.
class ToggleFavoriteEvent extends FavoriteEvent {
  final int productId;
  final bool expectedIsFavorite;

  const ToggleFavoriteEvent(
    this.productId, {
    required this.expectedIsFavorite,
  });

  @override
  List<Object?> get props => [productId, expectedIsFavorite];
}

class ToggleServiceFavoriteEvent extends FavoriteEvent {
  final int serviceId;
  final bool expectedIsFavorite;

  const ToggleServiceFavoriteEvent(
    this.serviceId, {
    required this.expectedIsFavorite,
  });

  @override
  List<Object?> get props => [serviceId, expectedIsFavorite];
}

class LoadMoreFavoritesEvent extends FavoriteEvent {
  const LoadMoreFavoritesEvent();
}

class LoadMoreServiceFavoritesEvent extends FavoriteEvent {
  const LoadMoreServiceFavoritesEvent();
}

class ClearFavoritesEvent extends FavoriteEvent {
  const ClearFavoritesEvent();
}

/// Triggered when connectivity is restored to flush the offline pending queue.
class SyncPendingFavoritesEvent extends FavoriteEvent {
  const SyncPendingFavoritesEvent();
}
