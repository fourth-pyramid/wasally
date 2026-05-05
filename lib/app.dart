import 'package:wassaly/core/imports/imports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      builder: (context) => SettingsListenerWrapper(
        builder: (context, themeMode) => _buildMaterialApp(context, themeMode),
      ),
    );
  }

  Widget _buildMaterialApp(BuildContext context, ThemeMode themeMode) {
    return MaterialApp.router(
      title: 'وصّلي',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#093773'),
      darkTheme: buildDarkTheme(primaryColorHex: '#093773'),
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return SessionListenerWrapper(child: child!);
      },
    );
  }
}
