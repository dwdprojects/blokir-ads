// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../ad_blocker/presentation/widgets/support_bottom_sheet.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(strings.aboutUs, style: context.textStyles.titleLarge),
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            _buildAppInfoCard(context, strings),
            const SizedBox(height: 16),
            _buildDescriptionCard(context, strings),
            const SizedBox(height: 16),
            _buildFeaturesCard(context, strings),
            const SizedBox(height: 16),
            _buildMenuCard(context, strings),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context, AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/icon/icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.shield_rounded,
                  size: 40,
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
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${strings.appVersion} 1.0.0',
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Text(
        strings.aboutAppDescription,
        textAlign: TextAlign.justify,
        style: context.textStyles.bodyMedium.copyWith(
          height: 1.6,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(BuildContext context, AppStrings strings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: context.colors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                strings.keyFeatures,
                style: context.textStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            context,
            Icons.security_rounded,
            strings.featureAdBlock,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            context,
            Icons.list_alt_rounded,
            strings.featureCustomBlocklist,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            context,
            Icons.terminal_rounded,
            strings.featureLiveDns,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            context,
            Icons.apps_rounded,
            strings.featureTargetApp,
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            context,
            Icons.lock_outline_rounded,
            strings.featurePrivacy,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.colors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, AppStrings strings) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.code_rounded,
            title: strings.developedBy,
            subtitle: strings.developerTeam,
            onTap: () {},
            showChevron: false,
          ),
          _buildDivider(context),
          _buildMenuItem(
            context,
            icon: Icons.favorite_rounded,
            title: strings.supportUs,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SupportBottomSheet(),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context,
            icon: Icons.star_rate_rounded,
            title: strings.rateApp,
            onTap: () async {
              final url = Uri.parse(
                'https://github.com/dwdprojects/blokir-ads',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context,
            icon: Icons.share_rounded,
            title: strings.shareApp,
            onTap: () {
              Share.share(strings.shareMessage(strings.appName));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textStyles.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
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
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colors.divider,
      indent: 60,
    );
  }
}
