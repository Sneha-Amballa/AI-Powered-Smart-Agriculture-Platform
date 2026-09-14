import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

/// Clean brand logo component combining an agricultural icon with modern typography.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? iconColor;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.size = 32.0,
    this.showText = true,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: iconColor ?? AppColors.primary,
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(
              Icons.eco,
              size: size * 0.65,
              color: Colors.white,
            ),
          ),
          if (showText) ...[
            AppSpacing.gapH8,
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: textColor ?? AppColors.textPrimary,
                ),
                children: const [
                  TextSpan(text: 'Kisan'),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(color: AppColors.primaryLight),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
