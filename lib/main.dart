import 'package:wassaly/app.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/services/fcm_background_handler.dart';
import 'package:wassaly/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Core Services
  await Future.wait([
    StorageService.instance.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    HiveService.init(),
  ]);

  // Firebase Background Message Handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  unawaited(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  );

  initDependencies();
  runApp(const App());
  // ponytail: check for updates at start of app
  unawaited(VersionUpdateService.instance.checkAndShowUpdate());
}
