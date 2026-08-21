import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'views/language_bottom_sheet_view.dart';
import 'views/theme_bottom_sheet_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Builder(
          builder: (context) {
            final strings = AppStrings.of(context);
            return Text(strings.account, style: context.textStyles.titleLarge);
          },
        ),
        backgroundColor: context.colors.background,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final strings = AppStrings.of(context);
          final themeName = state.themeMode == AppThemeMode.light 
              ? strings.light 
              : state.themeMode == AppThemeMode.dark 
                  ? strings.dark 
                  : strings.system;
          final langName = state.language == AppLanguage.en 
              ? strings.english 
              : strings.indonesian;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              _buildSectionTitle(context, strings.appPreferences),
              SizedBox(height: 12),
              _buildCard(
                context,
                children: [
                  _buildSettingsTile(
                    context,
                    icon: Icons.dark_mode_rounded,
                    title: strings.appearance,
                    subtitle: themeName,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ThemeBottomSheetView(),
                      );
                    },
                  ),
                  _buildDivider(context),
                  _buildSettingsTile(
                    context,
                    icon: Icons.language_rounded,
                    title: strings.language,
                    subtitle: langName,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => LanguageBottomSheetView(),
                      );
                    },
                  ),
              _buildDivider(context),
              _buildSettingsTile(
                context,
                icon: Icons.apps_rounded,
                title: strings.selectApp,
                subtitle: strings.selectAppSubtitle,
                onTap: () => Navigator.pushNamed(context, '/app-selector'),
              ),
              _buildDivider(context),
              _buildSettingsTile(
                context,
                icon: Icons.list_alt_rounded,
                title: strings.customBlocklist,
                subtitle: strings.customBlocklistSubtitle,
                onTap: () => Navigator.pushNamed(context, '/blocklist'),
              ),
            ],
          ),
          SizedBox(height: 32),
          _buildSectionTitle(context, strings.supportAndLegal),
          SizedBox(height: 12),
          _buildCard(
            context,
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.people_rounded,
                title: strings.aboutUs,
                onTap: () {
                  Navigator.pushNamed(context, '/about-us');
                },
              ),
              _buildDivider(context),
              _buildSettingsTile(
                context,
                icon: Icons.verified_user_rounded,
                title: strings.privacyPolicy,
                onTap: () {
                  Navigator.pushNamed(context, '/legal');
                },
              ),
              _buildDivider(context),
              _buildSettingsTile(
                context,
                icon: Icons.description_rounded,
                title: strings.termsAndConditions,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/legal',
                    arguments: {'initialTabIndex': 1},
                  );
                },
              ),
              _buildDivider(context),
              _buildSettingsTile(
                context,
                icon: Icons.info_outline_rounded,
                title: strings.appVersion,
                onTap: () {
                  _showVersionDialog(context, strings);
                },
                showChevron: false,
              ),
            ],
          ),
        ],
      );
        },
      ),
    );
  }

  void _showVersionDialog(BuildContext context, AppStrings strings) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: context.colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.shield_rounded,
                        size: 50,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  strings.appName,
                  style: context.textStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Versi ${AppConstants.appVersion}',
                  style: context.textStyles.bodyMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: context.textStyles.labelLarge.copyWith(
          color: context.colors.primaryDark,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.divider,
      indent: 64,
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: context.colors.primary, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.bodyLarge),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.textStyles.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.textHint,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
