import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class GetFavoritesEvent extends FavoriteEvent {
  const GetFavoritesEvent();
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
