import 'package:fpdart/fpdart.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  const CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await remoteDataSource.getCartItems();
      return Right(items.map((e) => e.toEntity()).toList());
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
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
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      await remoteDataSource.removeFromCart(productId);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
      int productId, int quantity) async {
    try {
      await remoteDataSource.updateQuantity(productId, quantity);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } on NetworkFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
