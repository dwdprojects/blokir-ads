// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:blokir_ads/core/theme/theme_extensions.dart';

import '../../../../core/localization/app_strings.dart';

class BlockerToggleWidget extends StatefulWidget {
  const BlockerToggleWidget({
    super.key,
    required this.isActive,
    required this.isLoading,
    required this.onTap,
  });

  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<BlockerToggleWidget> createState() => _BlockerToggleWidgetState();
}

class _BlockerToggleWidgetState extends State<BlockerToggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(BlockerToggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.isActive
        ? context.colors.activeGradient
        : context.colors.inactiveGradient;
    final glowColor = widget.isActive ? context.colors.active : context.colors.textHint;
    final strings = AppStrings.of(context);

    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) {
          final scale = widget.isActive ? _pulseAnim.value : 1.0;
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(widget.isActive ? 0.5 : 0.15),
                blurRadius: widget.isActive ? 40 : 15,
                spreadRadius: widget.isActive ? 10 : 2,
              ),
            ],
          ),
          child: widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Column(
                  mainAxisAlignment: .center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          widget.isActive
                              ? Icons.shield_rounded
                              : Icons.shield_outlined,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.isActive ? strings.active : strings.inactive,
                      style: context.textStyles.labelLarge.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
