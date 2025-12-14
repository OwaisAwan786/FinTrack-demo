import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fintrack_app/core/utils/constants.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          // Simple dark surface color, no blur
          color: AppColors.surfaceColor, 
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
