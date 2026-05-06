import 'package:equatable/equatable.dart';
import 'package:wassaly/core/utils/pagination.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

enum FavoriteStatus { initial, loading, refreshing, success, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final PaginatedResponse<ProductEntity> favorites;
  final Set<int> favoriteIds;
  final Set<int> togglingIds;
  final String? errorMessage;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    PaginatedResponse<ProductEntity>? favorites,
    this.favoriteIds = const {},
    this.togglingIds = const {},
    this.errorMessage,
  }) : favorites = favorites ?? const PaginatedResponse(data: []);

  bool get isLoading => status == FavoriteStatus.loading;
  bool get isRefreshing => status == FavoriteStatus.refreshing;
  bool get isSuccess => status == FavoriteStatus.success;
  bool get isError => status == FavoriteStatus.error;
  bool get isEmpty => favorites.data.isEmpty && isSuccess;

  /// True once the global favorites set has been loaded at least once.
  bool get hasLoaded => status != FavoriteStatus.initial;

  FavoriteState copyWith({
    FavoriteStatus? status,
    PaginatedResponse<ProductEntity>? favorites,
    Set<int>? favoriteIds,
    Set<int>? togglingIds,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      togglingIds: togglingIds ?? this.togglingIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        favorites,
        favoriteIds,
        togglingIds,
        errorMessage,
      ];
}
