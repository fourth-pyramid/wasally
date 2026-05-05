import 'dart:async';

import 'app.dart';
import 'core/imports/imports.dart';
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
  await StorageService.instance.init();

  await DeepLinkService.instance.initialize();

  runApp(
    const LocalizationWrapper(
      child: StateWrapper(
        child: App(),
      ),
    ),
  );
}
