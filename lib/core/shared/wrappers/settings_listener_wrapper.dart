import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/settings/settings_bloc.dart';

/// A wrapper that listens to SettingsBloc and applies theme/language changes globally.
class SettingsListenerWrapper extends StatelessWidget {
  final Widget Function(
      BuildContext context, ThemeMode themeMode, String language) builder;

  const SettingsListenerWrapper({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) => prev.language != curr.language,
      listener: (context, state) {
        // Apply language change using EasyLocalization
        final newLocale = Locale(state.language);
        if (context.locale != newLocale) {
          context.setLocale(newLocale);
        }
        // Navigate to splash to re-initialize the entire app with new language
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appRouter.go(AppRoutes.splash);
        });
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.isDarkMode != curr.isDarkMode ||
            prev.language != curr.language,
        builder: (context, state) {
          final themeMode = state.isDarkMode ? ThemeMode.dark : ThemeMode.light;
          return builder(context, themeMode, state.language);
        },
      ),
    );
  }
}
