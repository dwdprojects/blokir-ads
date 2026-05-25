// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
      duration: const Duration(seconds: 2),
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
        ? AppColors.activeGradient
        : AppColors.inactiveGradient;
    final glowColor = widget.isActive ? AppColors.active : AppColors.textHint;

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
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      widget.isActive
                          ? Icons.shield_rounded
                          : Icons.shield_outlined,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isActive ? 'AKTIF' : 'NONAKTIF',
                      style: AppTextStyles.labelLarge.copyWith(
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
