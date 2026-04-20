import 'package:wassaly/core/imports/core_imports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      builder: (context) => _buildMaterialApp(context),
    );
  }

  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp.router(
      title: 'وصّلي',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#093773'),
      darkTheme: buildDarkTheme(primaryColorHex: '#093773'),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        Widget current = child!;
        current = SkeletonWrapper(child: current);
        // current = SessionListenerWrapper(child: current);
        return current;
      },
    );
  }
}
