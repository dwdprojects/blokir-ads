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
    this.isGlobalMode = false,
  });

  final int blockedCount;
  final Duration uptime;
  final int targetCount;
  final bool isGlobalMode;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: _StatCard(
              label: strings.adsBlocked,
              value: AppUtils.formatNumber(blockedCount),
              icon: Icons.block_rounded,
              iconColor: context.colors.inactive,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: strings.uptime,
              value: AppUtils.formatDuration(uptime),
              icon: Icons.timer_outlined,
              iconColor: context.colors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: strings.targetApps,
              value: isGlobalMode ? strings.all : targetCount.toString(),
              icon: isGlobalMode ? Icons.all_inclusive_rounded : Icons.apps_rounded,
              iconColor: context.colors.warning,
            ),
          ),
        ],
      ),
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
      padding: const .symmetric(horizontal: 8, vertical: 14),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          FittedBox(
            fit: .scaleDown,
            child: Text(
              value,
              style: context.textStyles.titleMedium,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: .scaleDown,
            child: Text(
              label,
              style: context.textStyles.caption,
              textAlign: .center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
