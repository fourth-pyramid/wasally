import 'dart:async';

import 'app.dart';
import 'core/imports/core_imports.dart';
import 'core/imports/packages_imports.dart';
import 'core/injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDependencies();

  // Initialize DeepLinkService for Google OAuth callbacks
  await DeepLinkService.instance.initialize();

  runApp(
    const LocalizationWrapper(
      child: StateWrapper(
        child: App(),
      ),
    ),
  );
}
