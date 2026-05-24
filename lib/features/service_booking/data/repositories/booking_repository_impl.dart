import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../datasources/booking_local_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;
  final BookingLocalDataSource _localDataSource;

  const BookingRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, BookingEntity>> createBooking(
      BookingParams params) async {
    try {
      final booking = await _remoteDataSource.createBooking(params);
      return Right(booking);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings() async {
    try {
      final bookings = await _remoteDataSource.getMyBookings();
      await _localDataSource.cacheBookings(bookings);
      return Right(bookings);
    } on Failure catch (failure) {
      final cached = _localDataSource.getCachedBookings();
      if (cached.isNotEmpty) return Right(cached);
      return Left(failure);
    } catch (e) {
      final cached = _localDataSource.getCachedBookings();
      if (cached.isNotEmpty) return Right(cached);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> updateBooking(
      UpdateBookingParams params) async {
    try {
      final booking = await _remoteDataSource.updateBooking(params);
      return Right(booking);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(int bookingId) async {
    try {
      await _remoteDataSource.cancelBooking(bookingId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBooking(int bookingId) async {
    try {
      await _remoteDataSource.deleteBooking(bookingId);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
