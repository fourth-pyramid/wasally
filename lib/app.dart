import 'package:intl/intl.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      builder: (context) => SettingsListenerWrapper(
        builder: (context, themeMode, language) =>
            _buildMaterialApp(context, themeMode, language),
      ),
    );
  }

  Widget _buildMaterialApp(
      BuildContext context, ThemeMode themeMode, String language) {
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
      builder: (context, child) {
        return BlocListener<FavoriteBloc, FavoriteState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {},
          child: SessionListenerWrapper(
            child: InternetConnectionWrapper(child: child!),
          ),
        );
      },
    );
  }
}
