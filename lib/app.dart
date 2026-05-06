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
    return MaterialApp.router(
      key: ValueKey(language),
      title: 'app.title'.tr(),
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#093773'),
      darkTheme: buildDarkTheme(primaryColorHex: '#093773'),
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return BlocListener<FavoriteBloc, FavoriteState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            context.showTypedSnackBar(
              state.errorMessage!,
              type: SnackBarType.error,
            );
          },
          child: SessionListenerWrapper(child: child!),
        );
      },
    );
  }
}
