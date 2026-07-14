import 'package:wassaly/core/imports/imports.dart';

/// A service to check for app updates and manage version information using
/// the `upgrader` package.
class VersionUpdateService {
  VersionUpdateService._();
  static final VersionUpdateService instance = VersionUpdateService._();

  // ponytail: Minimal wrapper for the upgrader package
  final Upgrader upgrader = Upgrader.sharedInstance;

  /// Check if a newer version of the app is available and trigger update check.
  Future<void> checkAndShowUpdate() async {
    // ponytail: Wait for rootContext to be available
    var context = rootContext;
    while (context == null) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      context = rootContext;
    }

    if (context.mounted) {
      await upgrader.initialize();
      await upgrader.updateVersionInfo();
    }
  }
}
