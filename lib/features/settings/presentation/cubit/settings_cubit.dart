import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;
  static const _languageKey = 'app_language_key';
  static const _themeKey = 'app_theme_key';

  SettingsCubit({required this.prefs}) : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final langString = prefs.getString(_languageKey);
    final themeString = prefs.getString(_themeKey);

    AppLanguage lang = AppLanguage.id;
    if (langString == AppLanguage.en.name) {
      lang = AppLanguage.en;
    }

    AppThemeMode theme = AppThemeMode.system;
    if (themeString == AppThemeMode.light.name) {
      theme = AppThemeMode.light;
    } else if (themeString == AppThemeMode.dark.name) {
      theme = AppThemeMode.dark;
    }

    emit(state.copyWith(language: lang, themeMode: theme));
  }

  Future<void> changeLanguage(AppLanguage language) async {
    await prefs.setString(_languageKey, language.name);
    emit(state.copyWith(language: language));
  }

  Future<void> changeTheme(AppThemeMode theme) async {
    await prefs.setString(_themeKey, theme.name);
    emit(state.copyWith(themeMode: theme));
  }
}
