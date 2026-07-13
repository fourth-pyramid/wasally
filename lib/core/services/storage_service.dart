import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wassaly/core/utils/utils.dart';

/// A wrapper around [SharedPreferences] for simple key-value persistence.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final SharedPreferences _prefs;
  Completer<void>? _initCompleter;

  /// Initialize SharedPreferences instance.
  /// Safe to call concurrently — only initializes once.
  FutureEither<void> init() async {
    // Already done
    if (_initCompleter != null && _initCompleter!.isCompleted) {
      return right(null);
    }

    // First caller starts initialization
    if (_initCompleter == null) {
      _initCompleter = Completer<void>();
      try {
        _prefs = await SharedPreferences.getInstance();
        AppLogger.info('StorageService (SharedPreferences) initialized');
        _initCompleter!.complete();
      } catch (e, st) {
        _initCompleter!.completeError(e, st);
        _initCompleter = null; // allow retry on next call
        return left(ServerFailure(e.toString()));
      }
    } else {
      // Subsequent callers wait for the first to finish
      await _initCompleter!.future;
    }

    return right(null);
  }

  // --- SETTERS ---

  FutureEither<bool> setString(String key, String value) async =>
      runTask(() => _prefs.setString(key, value));

  FutureEither<bool> setBool(String key, {required bool value}) async =>
      runTask(() => _prefs.setBool(key, value));

  FutureEither<bool> setInt(String key, int value) async =>
      runTask(() => _prefs.setInt(key, value));

  FutureEither<bool> setDouble(String key, double value) async =>
      runTask(() => _prefs.setDouble(key, value));

  FutureEither<bool> setStringList(String key, List<String> value) async =>
      runTask(() => _prefs.setStringList(key, value));

  // --- GETTERS ---

  String? getString(String key) => _prefs.getString(key);
  bool? getBool(String key) => _prefs.getBool(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // ponytail: Check if user has seen showcase, and immediately mark as seen
  // so the tutorial runs only the very first time the page is loaded and never again,
  // even if they skip or close the screen.
  bool hasSeenShowcase(String id) {
    final seen = getBool('showcase_seen_$id') ?? false;
    if (!seen) {
      unawaited(setHasSeenShowcase(id, value: true));
    }
    return seen;
  }

  FutureEither<bool> setHasSeenShowcase(String id, {required bool value}) async =>
      setBool('showcase_seen_$id', value: value);

  FutureEither<bool> clearShowcaseSeenFlags() async {
    await setBool('showcase_seen_home_v1', value: false);
    await setBool('showcase_seen_product_v1', value: false);
    await setBool('showcase_seen_cart_v1', value: false);
    await setBool('showcase_seen_favorite_v1', value: false);
    await setBool('showcase_seen_profile_v1', value: false);
    await setBool('showcase_seen_search_v1', value: false);
    await setBool('showcase_seen_filter_v1', value: false);
    await setBool('showcase_seen_checkout_v1', value: false);
    await setBool('showcase_seen_orders_v1', value: false);
    return right(true);
  }

  // --- COMMON ---

  bool containsKey(String key) => _prefs.containsKey(key);

  FutureEither<bool> remove(String key) async =>
      runTask(() => _prefs.remove(key));

  FutureEither<bool> clear() async => runTask(() => _prefs.clear());
}
