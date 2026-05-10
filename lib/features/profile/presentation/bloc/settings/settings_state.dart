part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final String language;
  final bool isDarkMode;
  final bool notificationsEnabled;

  const SettingsState({
    this.language = 'ar',
    this.isDarkMode = false,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    String? language,
    bool? isDarkMode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [language, isDarkMode, notificationsEnabled];
}
