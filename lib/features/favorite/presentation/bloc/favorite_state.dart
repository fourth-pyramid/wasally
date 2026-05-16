import 'package:equatable/equatable.dart';
import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

enum FavoriteStatus { initial, loading, refreshing, success, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final PaginatedResponse<ProductEntity> favorites;
  final PaginatedResponse<ServiceEntity> serviceFavorites;
  final Set<int> favoriteIds;
  final Set<int> togglingIds;
  final Set<int> serviceFavoriteIds;
  final Set<int> serviceTogglingIds;
  final Failure? failure;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    PaginatedResponse<ProductEntity>? favorites,
    PaginatedResponse<ServiceEntity>? serviceFavorites,
    this.favoriteIds = const {},
    this.togglingIds = const {},
    this.serviceFavoriteIds = const {},
    this.serviceTogglingIds = const {},
    this.failure,
  })  : favorites = favorites ?? const PaginatedResponse(data: []),
        serviceFavorites =
            serviceFavorites ?? const PaginatedResponse(data: []);

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
    PaginatedResponse<ServiceEntity>? serviceFavorites,
    Set<int>? favoriteIds,
    Set<int>? togglingIds,
    Set<int>? serviceFavoriteIds,
    Set<int>? serviceTogglingIds,
    Failure? failure,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      serviceFavorites: serviceFavorites ?? this.serviceFavorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      togglingIds: togglingIds ?? this.togglingIds,
      serviceFavoriteIds: serviceFavoriteIds ?? this.serviceFavoriteIds,
      serviceTogglingIds: serviceTogglingIds ?? this.serviceTogglingIds,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        favorites,
        serviceFavorites,
        favoriteIds,
        togglingIds,
        serviceFavoriteIds,
        serviceTogglingIds,
        failure,
      ];

  // Backward compatibility getter
  String get errorMessage => failure?.message ?? '';
}
