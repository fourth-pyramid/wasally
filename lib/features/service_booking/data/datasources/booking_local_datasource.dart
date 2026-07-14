import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/service_booking/data/models/booking_model.dart';

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
    List<BookingModel> bookings,
  ) async {
    try {
      await _bookingsBox.clear();
      final map = <int, BookingModel>{for (final b in bookings) b.id: b};
      await _bookingsBox.putAll(map);

      return right(null);
    } on Object catch (e) {
      return left(CacheFailure('Failed to cache bookings: $e'));
    }
  }

  @override
  List<BookingModel> getCachedBookings() =>
      _bookingsBox.values.toList()..sort((a, b) => b.id.compareTo(a.id));

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _bookingsBox.clear();
      return right(null);
    } on Object catch (e) {
      return left(
        CacheFailure('Failed to clear bookings cache: $e'),
      );
    }
  }
}
