import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/settings/settings_bloc.dart';

/// A wrapper that listens to SettingsBloc and applies theme/language changes globally.
class SettingsListenerWrapper extends StatelessWidget {
  final Widget Function(BuildContext context, ThemeMode themeMode) builder;

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
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.isDarkMode != curr.isDarkMode ||
            prev.language != curr.language,
        builder: (context, state) {
          final themeMode = state.isDarkMode ? ThemeMode.dark : ThemeMode.light;
          return builder(context, themeMode);
        },
      ),
    );
  }
}
