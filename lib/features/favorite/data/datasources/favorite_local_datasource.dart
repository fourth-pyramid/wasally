import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

// ─── Pending operation model ────────────────────────────────────────────────
enum PendingFavoriteAction { add, remove }

enum PendingFavoriteItemType { product, service }

class PendingFavoriteOperation {
  final PendingFavoriteAction action;
  final PendingFavoriteItemType itemType;
  final int id;

  const PendingFavoriteOperation({
    required this.action,
    required this.itemType,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'action': action.name,
        'itemType': itemType.name,
        'id': id,
      };

  factory PendingFavoriteOperation.fromJson(Map<String, dynamic> json) =>
      PendingFavoriteOperation(
        action: PendingFavoriteAction.values.byName(json['action'] as String),
        itemType:
            PendingFavoriteItemType.values.byName(json['itemType'] as String),
        id: json['id'] as int,
      );
}

// ─── Abstract interface ──────────────────────────────────────────────────────
abstract class FavoriteLocalDataSource {
  // Products
  Future<Either<Failure, void>> cacheProductFavorites(
    List<ProductEntity> products,
  );
  List<ProductEntity> getCachedProductFavorites();
  Future<Either<Failure, void>> toggleProductFavoriteLocally(
    ProductEntity product, {
    required bool isFav,
  });

  // Services
  Future<Either<Failure, void>> cacheServiceFavorites(
    List<ServiceEntity> services,
  );
  List<ServiceEntity> getCachedServiceFavorites();
  Future<Either<Failure, void>> toggleServiceFavoriteLocally(
    ServiceEntity service, {
    required bool isFav,
  });

  // Quick checks
  Set<int> getFavoriteProductIds();
  Set<int> getFavoriteServiceIds();

  Future<Either<Failure, void>> clearFavoritesLocally();

  // ── Pending queue (offline operations) ───────────────────────────────────
  Future<void> enqueuePendingOperation(PendingFavoriteOperation op);
  List<PendingFavoriteOperation> getPendingOperations();
  Future<void> clearPendingOperations();
}

// ─── Implementation ──────────────────────────────────────────────────────────
class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final Box<ProductEntity> _productsBox;
  final Box<ServiceEntity> _servicesBox;
  final Box<Map<String, dynamic>> _pendingBox;

  FavoriteLocalDataSourceImpl()
      : _productsBox = Hive.box<ProductEntity>(HiveService.favoriteProductsBox),
        _servicesBox = Hive.box<ServiceEntity>(HiveService.favoriteServicesBox),
        _pendingBox =
            Hive.box<Map<String, dynamic>>(HiveService.favoritePendingBox);

  // ── Products ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> cacheProductFavorites(
    List<ProductEntity> products,
  ) async {
    try {
      await _productsBox.clear();
      final map = <int, ProductEntity>{for (final p in products) p.id: p};
      await _productsBox.putAll(map);
      return right(null);
    } on Exception catch (e) {
      return left(
        CacheFailure('Failed to cache favorite products: $e'),
      );
    }
  }

  @override
  List<ProductEntity> getCachedProductFavorites() =>
      _productsBox.values.toList();

  @override
  Future<Either<Failure, void>> toggleProductFavoriteLocally(
    ProductEntity product, {
    required bool isFav,
  }) async {
    try {
      if (isFav) {
        await _productsBox.put(product.id, product);
      } else {
        await _productsBox.delete(product.id);
      }
      return right(null);
    } on Exception catch (e) {
      return left(
        CacheFailure(
          'Failed to toggle favorite product locally: $e',
        ),
      );
    }
  }

  // ── Services ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> cacheServiceFavorites(
    List<ServiceEntity> services,
  ) async {
    try {
      await _servicesBox.clear();
      final map = <int, ServiceEntity>{for (final s in services) s.id: s};
      await _servicesBox.putAll(map);
      return right(null);
    } on Exception catch (e) {
      return left(
        CacheFailure('Failed to cache favorite services: $e'),
      );
    }
  }

  @override
  List<ServiceEntity> getCachedServiceFavorites() =>
      _servicesBox.values.toList();

  @override
  Future<Either<Failure, void>> toggleServiceFavoriteLocally(
    ServiceEntity service, {
    required bool isFav,
  }) async {
    try {
      if (isFav) {
        await _servicesBox.put(service.id, service);
      } else {
        await _servicesBox.delete(service.id);
      }
      return right(null);
    } on Exception catch (e) {
      return left(
        CacheFailure(
          'Failed to toggle favorite service locally: $e',
        ),
      );
    }
  }

  // ── Quick checks ───────────────────────────────────────────────────────────

  @override
  Set<int> getFavoriteProductIds() => _productsBox.keys.cast<int>().toSet();

  @override
  Set<int> getFavoriteServiceIds() => _servicesBox.keys.cast<int>().toSet();

  @override
  Future<Either<Failure, void>> clearFavoritesLocally() async {
    try {
      await _productsBox.clear();
      await _servicesBox.clear();
      return right(null);
    } on Exception catch (e) {
      return left(CacheFailure('Failed to clear favorites: $e'));
    }
  }

  // ── Pending queue ──────────────────────────────────────────────────────────

  @override
  Future<void> enqueuePendingOperation(PendingFavoriteOperation op) async {
    // Collapse opposite operations on the same item (add then remove = no-op)
    final existingIndex = _pendingBox.values.toList().indexWhere((m) {
      final existing = PendingFavoriteOperation.fromJson(m);
      return existing.itemType == op.itemType && existing.id == op.id;
    });

    if (existingIndex != -1) {
      final existing =
          PendingFavoriteOperation.fromJson(_pendingBox.getAt(existingIndex)!);
      if (existing.action != op.action) {
        // Opposite action cancels out — remove the queued entry
        await _pendingBox.deleteAt(existingIndex);
        return;
      }
      // Same action already queued — skip duplicate
      return;
    }

    await _pendingBox.add(op.toJson());
  }

  @override
  List<PendingFavoriteOperation> getPendingOperations() =>
      _pendingBox.values.map(PendingFavoriteOperation.fromJson).toList();

  @override
  Future<void> clearPendingOperations() => _pendingBox.clear();
}
