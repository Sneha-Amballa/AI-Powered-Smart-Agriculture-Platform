import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

/// Production-quality primary button component.
/// - Minimum 48dp touch height for accessibility
/// - Adapts cleanly to labels without truncation
/// - Fully responsive width
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48.0,
    this.padding,
    this.fontSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width ?? 0,
        maxWidth: width ?? double.infinity,
        minHeight: height,
      ),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            elevation: 0,
            minimumSize: Size(width ?? 48.0, height),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: AppRadius.shapeMd,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: 18),
                      AppSpacing.gapH8,
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      AppSpacing.gapH8,
                      Icon(trailingIcon, size: 18),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
