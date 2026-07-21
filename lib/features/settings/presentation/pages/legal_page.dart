import 'package:flutter/material.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';
import '../../../../core/localization/app_strings.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  static const routeName = '/legal';

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(strings.legalAndTerms, style: context.textStyles.titleLarge),
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
      body: Column(
        children: [
          _buildTabBar(context, strings),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPrivacyPolicyTab(context, strings),
                _buildTermsTab(context, strings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, AppStrings strings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: context.colors.textSecondary,
        labelStyle: context.textStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: context.textStyles.labelLarge,
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(text: strings.privacyPolicy),
          Tab(text: strings.termsAndConditions),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicyTab(BuildContext context, AppStrings strings) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _buildHeaderCard(
          context,
          strings,
          introText: strings.privacyPolicyIntro(strings.appName),
        ),
        const SizedBox(height: 16),
        _buildExpansionTile(
          context,
          icon: Icons.search_rounded,
          title: strings.dataCollectionTitle,
          content: strings.dataCollectionDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.data_usage_rounded,
          title: strings.dataUsageTitle,
          content: strings.dataUsageDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.lock_rounded,
          title: strings.dataSecurityTitle,
          content: strings.dataSecurityDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.verified_user_rounded,
          title: strings.userRightsTitle,
          content: strings.userRightsDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.help_outline_rounded,
          title: strings.contactTitle,
          content: strings.contactDesc,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTermsTab(BuildContext context, AppStrings strings) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _buildHeaderCard(
          context,
          strings,
          introText: strings.termsIntro(strings.appName),
        ),
        const SizedBox(height: 16),
        _buildExpansionTile(
          context,
          icon: Icons.check_circle_outline_rounded,
          title: strings.acceptanceTitle,
          content: strings.acceptanceDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.settings_rounded,
          title: strings.serviceUseTitle,
          content: strings.serviceUseDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.warning_amber_rounded,
          title: strings.disclaimerTitle,
          content: strings.disclaimerDesc,
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          context,
          icon: Icons.update_rounded,
          title: strings.changesTitle,
          content: strings.changesDesc,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, AppStrings strings, {required String introText}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.legalAndTerms,
            style: context.textStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            strings.lastUpdated,
            style: context.textStyles.bodySmall.copyWith(color: context.colors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.security_rounded, color: context.colors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  introText,
                  textAlign: TextAlign.justify,
                  style: context.textStyles.bodyMedium.copyWith(
                    height: 1.5,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconColor: context.colors.textHint,
          collapsedIconColor: context.colors.textHint,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: context.colors.primary, size: 20),
          ),
          title: Text(
            title,
            style: context.textStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: context.colors.divider, height: 24),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: context.textStyles.bodyMedium.copyWith(
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
