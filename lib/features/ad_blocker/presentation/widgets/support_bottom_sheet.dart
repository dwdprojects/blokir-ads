// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';
import '../../../../core/localization/app_strings.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.backgroundSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.active.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: context.colors.active,
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(AppStrings.of(context).supportDevelopmentTitle, style: context.textStyles.titleLarge),
            SizedBox(height: 8),
            Text(
              AppStrings.of(context).supportDevelopmentDesc,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium,
            ),
            SizedBox(height: 32),
            _SupportButton(
              title: AppStrings.of(context).supportVia('PayPal'),
              icon: Icons.paypal_rounded,
              color: Color(0xFF00457C),
              onTap: () => _launchUrl('https://paypal.me/fachrealheart'),
            ),
            SizedBox(height: 12),
            _SupportButton(
              title: AppStrings.of(context).supportVia('Saweria'),
              icon: Icons.coffee_rounded,
              color: Color(0xFFFA8231),
              onTap: () => _launchUrl('https://saweria.co/dreamwithdiki'),
            ),
            SizedBox(height: 12),
            _SupportButton(
              title: AppStrings.of(context).supportVia('Trakteer'),
              icon: Icons.local_cafe_rounded,
              color: Color(0xFFBE1E2D),
              onTap: () => _launchUrl('https://trakteer.id/dreamwithdiki/link'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: context.textStyles.labelLarge.copyWith(color: Colors.white),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
