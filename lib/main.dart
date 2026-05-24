import 'app.dart';
import 'core/imports/imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Future.wait([
    StorageService.instance.init(),
    HiveService.init(),
  ]);

  initDependencies();
  runApp(const StateWrapper(
    child: App(),
  ));
}
