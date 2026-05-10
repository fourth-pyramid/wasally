import 'package:wassaly/core/imports/imports.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final StorageService _storage;

  static const String _languageKey = 'app_language';
  static const String _themeKey = 'is_dark_mode';
  static const String _notificationsKey = 'notifications_enabled';

  SettingsBloc({
    required StorageService storage,
  })  : _storage = storage,
        super(const SettingsState()) {
    on<SettingsInitialized>(_onSettingsInitialized);
    on<LanguageToggled>(_onLanguageToggled);
    on<LanguageChanged>(_onLanguageChanged);
    on<ThemeToggled>(_onThemeToggled);
    on<SettingsNotificationsToggled>(_onNotificationsToggled);
  }

  Future<void> _onSettingsInitialized(
    SettingsInitialized event,
    Emitter<SettingsState> emit,
  ) async {
    final language = _storage.getString(_languageKey) ?? 'ar';
    final isDarkMode = _storage.getBool(_themeKey) ?? false;
    final notificationsEnabled = _storage.getBool(_notificationsKey) ?? true;

    emit(state.copyWith(
      language: language,
      isDarkMode: isDarkMode,
      notificationsEnabled: notificationsEnabled,
    ));
  }

  Future<void> _onLanguageToggled(
    LanguageToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final newLanguage = state.language == 'ar' ? 'en' : 'ar';

    await _storage.setString(_languageKey, newLanguage);

    emit(state.copyWith(language: newLanguage));
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _storage.setString(_languageKey, event.language);

    emit(state.copyWith(language: event.language));
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final newIsDarkMode = !state.isDarkMode;

    await _storage.setBool(_themeKey, newIsDarkMode);

    emit(state.copyWith(isDarkMode: newIsDarkMode));
  }

  Future<void> _onNotificationsToggled(
    SettingsNotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await _storage.setBool(_notificationsKey, event.enabled);

    emit(state.copyWith(notificationsEnabled: event.enabled));
  }
}
