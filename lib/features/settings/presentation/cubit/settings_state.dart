import 'package:equatable/equatable.dart';

enum AppLanguage { id, en }
enum AppThemeMode { system, light, dark }

class SettingsState extends Equatable {
  final AppLanguage language;
  final AppThemeMode themeMode;

  const SettingsState({
    this.language = AppLanguage.id,
    this.themeMode = AppThemeMode.system,
  });

  SettingsState copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
  }) {
    return SettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [language, themeMode];
}
