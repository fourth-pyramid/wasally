import 'package:hive_flutter/hive_flutter.dart';
import 'package:wassaly/core/imports/imports.dart';

import '../../../../features/home/domain/entities/product_entity.dart';
import '../../../../features/sub_category/domain/entities/service_entity.dart';

abstract class FavoriteLocalDataSource {
  // Products
  Future<Either<Failure, void>> cacheProductFavorites(
      List<ProductEntity> products);
  List<ProductEntity> getCachedProductFavorites();
  Future<Either<Failure, void>> toggleProductFavoriteLocally(
      ProductEntity product, bool isFav);

  // Services
  Future<Either<Failure, void>> cacheServiceFavorites(
      List<ServiceEntity> services);
  List<ServiceEntity> getCachedServiceFavorites();
  Future<Either<Failure, void>> toggleServiceFavoriteLocally(
      ServiceEntity service, bool isFav);

  // Quick checks
  Set<int> getFavoriteProductIds();
  Set<int> getFavoriteServiceIds();

  Future<Either<Failure, void>> clearFavoritesLocally();
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final Box<ProductEntity> _productsBox;
  final Box<ServiceEntity> _servicesBox;

  FavoriteLocalDataSourceImpl()
      : _productsBox = Hive.box<ProductEntity>(HiveService.favoriteProductsBox),
        _servicesBox = Hive.box<ServiceEntity>(HiveService.favoriteServicesBox);

  @override
  Future<Either<Failure, void>> cacheProductFavorites(
      List<ProductEntity> products) async {
    try {
      await _productsBox.clear();
      final Map<int, ProductEntity> map = {for (final p in products) p.id: p};
      await _productsBox.putAll(map);
      return right(null);
    } catch (e) {
      return left(
          CacheFailure('Failed to cache favorite products: ${e.toString()}'));
    }
  }

  @override
  List<ProductEntity> getCachedProductFavorites() {
    return _productsBox.values.toList();
  }

  @override
  Future<Either<Failure, void>> toggleProductFavoriteLocally(
      ProductEntity product, bool isFav) async {
    try {
      if (isFav) {
        await _productsBox.put(product.id, product);
      } else {
        await _productsBox.delete(product.id);
      }
      return right(null);
    } catch (e) {
      return left(CacheFailure(
          'Failed to toggle favorite product locally: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheServiceFavorites(
      List<ServiceEntity> services) async {
    try {
      await _servicesBox.clear();
      final Map<int, ServiceEntity> map = {for (final s in services) s.id: s};
      await _servicesBox.putAll(map);
      return right(null);
    } catch (e) {
      return left(
          CacheFailure('Failed to cache favorite services: ${e.toString()}'));
    }
  }

  @override
  List<ServiceEntity> getCachedServiceFavorites() {
    return _servicesBox.values.toList();
  }

  @override
  Future<Either<Failure, void>> toggleServiceFavoriteLocally(
      ServiceEntity service, bool isFav) async {
    try {
      if (isFav) {
        await _servicesBox.put(service.id, service);
      } else {
        await _servicesBox.delete(service.id);
      }
      return right(null);
    } catch (e) {
      return left(CacheFailure(
          'Failed to toggle favorite service locally: ${e.toString()}'));
    }
  }

  @override
  Set<int> getFavoriteProductIds() {
    return _productsBox.keys.cast<int>().toSet();
  }

  @override
  Set<int> getFavoriteServiceIds() {
    return _servicesBox.keys.cast<int>().toSet();
  }

  @override
  Future<Either<Failure, void>> clearFavoritesLocally() async {
    try {
      await _productsBox.clear();
      await _servicesBox.clear();
      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to clear favorites: ${e.toString()}'));
    }
  }
}
