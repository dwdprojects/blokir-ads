import 'package:flutter/material.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/app_card.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

import '../../../../core/localization/app_strings.dart';

class BlockerStatsWidget extends StatelessWidget {
  const BlockerStatsWidget({
    super.key,
    required this.blockedCount,
    required this.uptime,
    required this.targetCount,
  });

  final int blockedCount;
  final Duration uptime;
  final int targetCount;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: strings.adsBlocked,
            value: AppUtils.formatNumber(blockedCount),
            icon: Icons.block_rounded,
            iconColor: context.colors.inactive,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: strings.uptime,
            value: AppUtils.formatDuration(uptime),
            icon: Icons.timer_outlined,
            iconColor: context.colors.primary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: strings.targetApps,
            value: targetCount.toString(),
            icon: Icons.apps_rounded,
            iconColor: context.colors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          SizedBox(height: 8),
          Text(value, style: context.textStyles.titleMedium),
          SizedBox(height: 4),
          Text(
            label,
            style: context.textStyles.caption,
            textAlign: .center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
