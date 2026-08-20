import 'package:flutter/material.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? context.colors.primary;

    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: .circular(12),
            ),
          ),
          child: _buildChild(context, buttonColor),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: context.colors.background,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: .circular(12),
          ),
          elevation: 0,
        ),
        child: _buildChild(context, context.colors.background),
      ),
    );
  }

  Widget _buildChild(BuildContext context, Color fgColor) {
    if (isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 18, color: fgColor),
          SizedBox(width: 8),
          Text(label, style: context.textStyles.labelLarge.copyWith(color: fgColor)),
        ],
      );
    }

    return Text(label, style: context.textStyles.labelLarge.copyWith(color: fgColor));
  }
}
