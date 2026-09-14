import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

enum BadgeVariant { success, warning, error, info, neutral }

/// Status badge pill without emojis, using clean typography and subtle background tints.
class AppBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (variant) {
      case BadgeVariant.success:
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case BadgeVariant.warning:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case BadgeVariant.error:
        bg = AppColors.errorLight;
        fg = AppColors.error;
        break;
      case BadgeVariant.info:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        break;
      case BadgeVariant.neutral:
        bg = AppColors.sage;
        fg = AppColors.primaryDark;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.radiusPill,
        border: Border.all(color: fg.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            AppSpacing.gapH4,
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: fg,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
