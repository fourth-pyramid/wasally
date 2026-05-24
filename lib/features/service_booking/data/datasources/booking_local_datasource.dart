import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/imports/core_imports.dart';
import '../models/booking_model.dart';

abstract class BookingLocalDataSource {
  Future<Either<Failure, void>> cacheBookings(List<BookingModel> bookings);
  List<BookingModel> getCachedBookings();
  Future<Either<Failure, void>> clearCache();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final Box<BookingModel> _bookingsBox;

  BookingLocalDataSourceImpl()
      : _bookingsBox = Hive.box<BookingModel>(HiveService.bookingsBox);

  @override
  Future<Either<Failure, void>> cacheBookings(
      List<BookingModel> bookings) async {
    try {
      await _bookingsBox.clear();
      final Map<int, BookingModel> map = {for (final b in bookings) b.id: b};
      await _bookingsBox.putAll(map);

      return right(null);
    } catch (e) {
      return left(CacheFailure('Failed to cache bookings: ${e.toString()}'));
    }
  }

  @override
  List<BookingModel> getCachedBookings() {
    final list = _bookingsBox.values.toList();
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _bookingsBox.clear();
      return right(null);
    } catch (e) {
      return left(
          CacheFailure('Failed to clear bookings cache: ${e.toString()}'));
    }
  }
}
