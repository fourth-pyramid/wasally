import 'package:wassaly/core/imports/imports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return StateWrapper(
      child: ScreenUtilInit(
        minTextAdapt: true,
        builder: (context, _) => SettingsListenerWrapper(
          builder: _buildMaterialApp,
        ),
      ),
    );
  }

  Widget _buildMaterialApp(
    BuildContext context,
    ThemeMode themeMode,
    String language,
  ) {
    Intl.defaultLocale = language;
    return MaterialApp.router(
      key: ValueKey(language),
      onGenerateTitle: (context) => context.l10n.app_title,
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#093773'),
      darkTheme: buildDarkTheme(primaryColorHex: '#093773'),
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: Locale(language),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.noScaling,
        ),
        child: SessionListenerWrapper(
          child: InternetConnectionWrapper(child: child!),
        ),
      ),
    );
  }
}
