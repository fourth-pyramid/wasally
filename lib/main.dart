import 'dart:async';

import 'app.dart';
import 'core/imports/core_imports.dart';
import 'core/imports/packages_imports.dart';
import 'core/injection/injection.dart';

Future<void> _preloadLogoAsset() async {
  const imageProvider = AssetImage('assets/images/logo.png');
  final stream = imageProvider.resolve(ImageConfiguration.empty);
  final completer = Completer<void>();
  final listener = ImageStreamListener(
    (ImageInfo info, bool syncCall) {
      if (!completer.isCompleted) completer.complete();
    },
    onError: (dynamic exception, StackTrace? stackTrace) {
      if (!completer.isCompleted) completer.completeError(exception);
    },
  );
  stream.addListener(listener);
  await completer.future;
  stream.removeListener(listener);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await StorageService.instance.init();
  await AppConfig.init();
  await initDependencies();
  await _preloadLogoAsset();

  runApp(
    const LocalizationWrapper(
      child: StateWrapper(
        child: App(),
      ),
    ),
  );
}
