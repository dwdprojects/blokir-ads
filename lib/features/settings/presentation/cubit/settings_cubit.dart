import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;
  static const _languageKey = 'app_language_key';
  static const _themeKey = 'app_theme_key';
  static const _globalProtectionKey = 'app_global_protection_key';

  SettingsCubit({required this.prefs}) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final langString = prefs.getString(_languageKey);
    final themeString = prefs.getString(_themeKey);
    final isGlobal = prefs.getBool(_globalProtectionKey) ?? true;

    AppLanguage lang = .id;
    if (langString == AppLanguage.en.name) {
      lang = .en;
    }

    AppThemeMode theme = .system;
    if (themeString == AppThemeMode.light.name) {
      theme = .light;
    } else if (themeString == AppThemeMode.dark.name) {
      theme = .dark;
    }

    emit(state.copyWith(
      language: lang,
      themeMode: theme,
      isGlobalProtection: isGlobal,
    ));
  }

  Future<void> changeLanguage(AppLanguage language) async {
    await prefs.setString(_languageKey, language.name);
    emit(state.copyWith(language: language));
  }

  Future<void> changeTheme(AppThemeMode theme) async {
    await prefs.setString(_themeKey, theme.name);
    emit(state.copyWith(themeMode: theme));
  }

  Future<void> toggleGlobalProtection(bool isGlobal) async {
    await prefs.setBool(_globalProtectionKey, isGlobal);
    emit(state.copyWith(isGlobalProtection: isGlobal));
  }
}
