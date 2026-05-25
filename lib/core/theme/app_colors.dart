import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF00B8D9);
  static const Color primaryLight = Color(0xFF80F0FF);

  // Background
  static const Color background = Color(0xFF0A0E1A);
  static const Color backgroundSecondary = Color(0xFF111827);
  static const Color surface = Color(0xFF141D2E);
  static const Color surfaceVariant = Color(0xFF1A2540);

  // Status
  static const Color active = Color(0xFF00E676);
  static const Color activeDark = Color(0xFF00897B);
  static const Color inactive = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFD740);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8899BB);
  static const Color textHint = Color(0xFF3D4F6E);

  // Border
  static const Color border = Color(0xFF1E3050);
  static const Color divider = Color(0xFF151F30);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF006080)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activeGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inactiveGradient = LinearGradient(
    colors: [Color(0xFF4A5568), Color(0xFF2D3748)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF141D2E), Color(0xFF0F1624)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF0D1525)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
