import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';

/// Clean icon button with accessible touch target and optional background pill.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: AppRadius.radiusMd,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: size,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}
