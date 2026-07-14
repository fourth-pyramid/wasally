import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:wassaly/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wassaly/features/cart/domain/entities/coupon_entity.dart';
import 'package:wassaly/features/cart/domain/entities/order_entity.dart';
import 'package:wassaly/features/cart/domain/entities/place_order_params.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  const CartRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await remoteDataSource.getCartItems();
      final entities = items.map((e) => e.toEntity()).toList();
      // Cache cart items locally for offline access
      await localDataSource.saveCartItemsLocally(entities);
      return Right(entities);
    } on NetworkFailure {
      // Fallback to local data on network failure
      final localData = localDataSource.getCartItemsLocally();
      return Right(localData);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(int productId, int quantity) async {
    try {
      await remoteDataSource.addToCart(productId, quantity);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int cartItemId) async {
    try {
      await remoteDataSource.removeFromCart(cartItemId);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    int cartItemId,
    int quantity,
  ) async {
    try {
      await remoteDataSource.updateQuantity(cartItemId, quantity);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CouponEntity>> applyCoupon(String code) async {
    try {
      final coupon = await remoteDataSource.applyCoupon(code);
      return Right(coupon.toEntity());
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> placeOrder(
    PlaceOrderParams params,
  ) async {
    try {
      final orderModel = await remoteDataSource.placeOrder(params);
      return Right(orderModel.toEntity());
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } on Object catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCartItemsLocally(
    List<CartItemEntity> items,
  ) async =>
      localDataSource.saveCartItemsLocally(items);

  @override
  List<CartItemEntity> getCartItemsLocally() =>
      localDataSource.getCartItemsLocally();

  @override
  bool isProductInCartLocally(int productId) =>
      localDataSource.isProductInCartLocally(productId);

  @override
  int getCartCountLocally() => localDataSource.getCartCountLocally();

  @override
  Future<Either<Failure, void>> clearCartLocally() async =>
      localDataSource.clearCartLocally();
}
