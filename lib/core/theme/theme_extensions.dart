import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemeColors {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color background;
  final Color backgroundSecondary;
  final Color surface;
  final Color surfaceVariant;
  final Color active;
  final Color activeDark;
  final Color inactive;
  final Color warning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color divider;
  
  final LinearGradient primaryGradient;
  final LinearGradient activeGradient;
  final LinearGradient inactiveGradient;
  final LinearGradient cardGradient;
  final LinearGradient backgroundGradient;

  const AppThemeColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.background,
    required this.backgroundSecondary,
    required this.surface,
    required this.surfaceVariant,
    required this.active,
    required this.activeDark,
    required this.inactive,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.divider,
    required this.primaryGradient,
    required this.activeGradient,
    required this.inactiveGradient,
    required this.cardGradient,
    required this.backgroundGradient,
  });
}

class AppThemeTextStyles {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle caption;

  const AppThemeTextStyles({
    required this.displayLarge,
    required this.displayMedium,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.caption,
  });
}

// -----------------------------------------------------------------------------
// DARK THEME (Sesuai dengan `AppColors` statis yang sudah ada)
// -----------------------------------------------------------------------------
const _darkColors = AppThemeColors(
  primary: AppColors.primary,
  primaryDark: AppColors.primaryDark,
  primaryLight: AppColors.primaryLight,
  background: AppColors.background,
  backgroundSecondary: AppColors.backgroundSecondary,
  surface: AppColors.surface,
  surfaceVariant: AppColors.surfaceVariant,
  active: AppColors.active,
  activeDark: AppColors.activeDark,
  inactive: AppColors.inactive,
  warning: AppColors.warning,
  textPrimary: AppColors.textPrimary,
  textSecondary: AppColors.textSecondary,
  textHint: AppColors.textHint,
  border: AppColors.border,
  divider: AppColors.divider,
  primaryGradient: AppColors.primaryGradient,
  activeGradient: AppColors.activeGradient,
  inactiveGradient: AppColors.inactiveGradient,
  cardGradient: AppColors.cardGradient,
  backgroundGradient: AppColors.backgroundGradient,
);

// -----------------------------------------------------------------------------
// LIGHT THEME
// -----------------------------------------------------------------------------
const _lightColors = AppThemeColors(
  primary: Color(0xFF00B8D9),
  primaryDark: Color(0xFF0096B3),
  primaryLight: Color(0xFF33CFFF),
  // Background sedikit lebih gelap (soft gray dengan hint biru) agar tidak terlalu menyilaukan
  background: Color(0xFFF0F3F8), 
  // Background secondary untuk highlight/icon container (soft blueish)
  backgroundSecondary: Color(0xFFE1EBF5),
  // Surface (Card) tetap putih bersih agar kontras dengan background
  surface: Color(0xFFFFFFFF),
  surfaceVariant: Color(0xFFF4F7FA),
  active: Color(0xFF00C853),
  activeDark: Color(0xFF00897B),
  inactive: Color(0xFFE53935),
  warning: Color(0xFFFBC02D),
  // Text primary sedikit di-soften agar tidak terlalu kontras
  textPrimary: Color(0xFF1E293B),
  // Text secondary lebih soft
  textSecondary: Color(0xFF64748B),
  textHint: Color(0xFF94A3B8),
  // Border dan divider dibuat sangat soft (subtle) agar UI terlihat bersih
  border: Color(0xFFE2E8F0),
  divider: Color(0xFFE2E8F0),
  primaryGradient: LinearGradient(
    colors: [Color(0xFF00B8D9), Color(0xFF00839C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  activeGradient: LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  inactiveGradient: LinearGradient(
    colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  cardGradient: LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  backgroundGradient: LinearGradient(
    colors: [Color(0xFFF0F3F8), Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

// -----------------------------------------------------------------------------
// BUILDCONTEXT EXTENSIONS
// -----------------------------------------------------------------------------
extension ThemeExtensions on BuildContext {
  /// Mendapatkan kumpulan warna dinamis yang menyesuaikan dengan tema saat ini.
  AppThemeColors get colors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? _darkColors : _lightColors;
  }

  /// Mendapatkan set TextStyles yang warnanya otomatis terikat ke tema (terang/gelap).
  AppThemeTextStyles get textStyles {
    final c = colors;
    
    // We dynamically map the styles based on the current `colors`
    return AppThemeTextStyles(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: c.textPrimary),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: c.textPrimary),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c.textPrimary),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: c.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: c.textPrimary),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: c.textSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.textPrimary),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: c.textSecondary),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: c.textSecondary, letterSpacing: 0.5),
      caption: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: c.textHint, letterSpacing: 0.4),
    );
  }
}
