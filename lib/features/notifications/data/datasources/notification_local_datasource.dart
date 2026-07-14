import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/notifications/data/models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<Either<Failure, void>> cacheNotifications(
    List<NotificationModel> notifications, {
    int page = 1,
  });
  List<NotificationModel> getCachedNotifications({int page = 1});
  Future<Either<Failure, void>> clearCache();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final Box<NotificationModel> _box;

  NotificationLocalDataSourceImpl()
      : _box = Hive.box<NotificationModel>(HiveService.notificationsBox);

  @override
  Future<Either<Failure, void>> cacheNotifications(
    List<NotificationModel> notifications, {
    int page = 1,
  }) async {
    try {
      if (page == 1) {
        await _box.clear();
      }

      final map = <int, NotificationModel>{
        for (final n in notifications) n.id: n,
      };
      await _box.putAll(map);

      return right(null);
    } on Object catch (e) {
      return left(
        CacheFailure('Failed to cache notifications: $e'),
      );
    }
  }

  @override
  List<NotificationModel> getCachedNotifications({int page = 1}) =>
      _box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _box.clear();
      return right(null);
    } on Object catch (e) {
      return left(
        CacheFailure('Failed to clear notifications cache: $e'),
      );
    }
  }
}
