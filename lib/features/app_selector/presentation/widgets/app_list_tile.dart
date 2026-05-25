// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../domain/entities/installed_app_entity.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({super.key, required this.app, required this.onToggle});

  final InstalledAppEntity app;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: app.isBlocked
            ? AppColors.active.withOpacity(0.06)
            : AppColors.surface,
        borderRadius: .circular(12),
        border: Border.all(
          color: app.isBlocked
              ? AppColors.active.withOpacity(0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _AppIcon(iconBytes: app.icon, appName: app.appName),
        title: Text(
          app.appName,
          style: AppTextStyles.bodyLarge,
          maxLines: 1,
          overflow: .ellipsis,
        ),
        subtitle: Text(
          app.packageName,
          style: AppTextStyles.bodySmall,
          maxLines: 1,
          overflow: .ellipsis,
        ),
        trailing: _BlockSwitch(isBlocked: app.isBlocked, onToggle: onToggle),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({this.iconBytes, required this.appName});

  final Uint8List? iconBytes;
  final String appName;

  @override
  Widget build(BuildContext context) {
    final icon = AppUtils.buildAppIcon(iconBytes);
    if (icon != null) {
      return ClipRRect(
        borderRadius: .circular(10),
        child: Image(image: icon, width: 44, height: 44, fit: .cover),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: .circular(10),
      ),
      child: Center(
        child: Text(
          AppUtils.getInitials(appName),
          style: const TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _BlockSwitch extends StatelessWidget {
  const _BlockSwitch({required this.isBlocked, required this.onToggle});

  final bool isBlocked;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.85,
      child: Switch(
        value: isBlocked,
        onChanged: onToggle,
        activeColor: AppColors.active,
        activeTrackColor: AppColors.active.withOpacity(0.3),
        inactiveThumbColor: AppColors.textHint,
        inactiveTrackColor: AppColors.surfaceVariant,
      ),
    );
  }
}
