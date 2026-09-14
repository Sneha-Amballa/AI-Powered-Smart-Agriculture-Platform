import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_spacing.dart';

/// Production card component with clean borders, subtle depth, and accessible tap states.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool elevated;

  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.edgeCard,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.radiusLg;
    final effectiveBorder = borderColor ?? AppColors.cardBorder;
    final effectiveBg = backgroundColor ?? AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
        border: Border.all(color: effectiveBorder, width: 1),
        boxShadow: elevated ? AppShadows.card : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        clipBehavior: Clip.antiAlias,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: effectiveRadius,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              )
            : Padding(
                padding: padding,
                child: child,
              ),
      ),
    );
  }
}
