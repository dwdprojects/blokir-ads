import 'package:equatable/equatable.dart';

enum AppLanguage { id, en }
enum AppThemeMode { system, light, dark }

class SettingsState extends Equatable {
  final AppLanguage language;
  final AppThemeMode themeMode;
  final bool isGlobalProtection;

  const SettingsState({
    this.language = .id,
    this.themeMode = .system,
    this.isGlobalProtection = true,
  });

  SettingsState copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    bool? isGlobalProtection,
  }) {
    return SettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isGlobalProtection: isGlobalProtection ?? this.isGlobalProtection,
    );
  }

  @override
  List<Object> get props => [language, themeMode, isGlobalProtection];
}
