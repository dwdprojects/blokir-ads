// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../../../../core/localization/app_strings.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

class ThemeBottomSheetView extends StatelessWidget {
  const ThemeBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final strings = AppStrings.of(context);

        return Container(
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.textHint.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24),

              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.colors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.palette_rounded,
                        color: context.colors.primary, size: 24),
                  ),
                  SizedBox(width: 16),
                  Text(strings.chooseTheme, style: context.textStyles.titleLarge),
                ],
              ),
              SizedBox(height: 24),

              // Card Pilihan Tema
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colors.border, width: 1),
                ),
                child: Column(
                  children: [
                    _buildThemeItem(
                      context,
                      icon: Icons.brightness_auto_rounded,
                      title: strings.system,
                      themeMode: .system,
                      selectedTheme: state.themeMode,
                      isTop: true,
                      isBottom: false,
                    ),
                    Divider(
                        height: 1, thickness: 1, color: context.colors.divider),
                    _buildThemeItem(
                      context,
                      icon: Icons.light_mode_rounded,
                      title: strings.light,
                      themeMode: .light,
                      selectedTheme: state.themeMode,
                      isTop: false,
                      isBottom: false,
                    ),
                    Divider(
                        height: 1, thickness: 1, color: context.colors.divider),
                    _buildThemeItem(
                      context,
                      icon: Icons.dark_mode_rounded,
                      title: strings.dark,
                      themeMode: .dark,
                      selectedTheme: state.themeMode,
                      isTop: false,
                      isBottom: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Tombol Batal
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.colors.border, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    strings.cancel,
                    style: context.textStyles.titleMedium.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required AppThemeMode themeMode,
    required AppThemeMode selectedTheme,
    required bool isTop,
    required bool isBottom,
  }) {
    final isSelected = selectedTheme == themeMode;

    return InkWell(
      onTap: () {
        context.read<SettingsCubit>().changeTheme(themeMode);
        Future.delayed(Duration(milliseconds: 200), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      },
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isTop ? 16 : 0),
        bottom: Radius.circular(isBottom ? 16 : 0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.border, width: 1),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? context.colors.primary : context.colors.textSecondary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.textStyles.bodyLarge.copyWith(
                  color: isSelected ? context.colors.primary : context.colors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: context.colors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
