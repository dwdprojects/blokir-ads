import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/app_card.dart';

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
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Iklan Diblokir',
            value: AppUtils.formatNumber(blockedCount),
            icon: Icons.block_rounded,
            iconColor: AppColors.inactive,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Waktu Aktif',
            value: AppUtils.formatDuration(uptime),
            icon: Icons.timer_outlined,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'App Target',
            value: targetCount.toString(),
            icon: Icons.apps_rounded,
            iconColor: AppColors.warning,
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
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: .center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
