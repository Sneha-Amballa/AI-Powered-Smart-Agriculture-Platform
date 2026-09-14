import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

/// Reusable secondary outlined button component.
/// - Minimum 48dp touch height for accessibility
/// - Adapts cleanly to labels without truncation
/// - Fully responsive width
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.padding,
    this.fontSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = textColor ?? AppColors.primary;
    final effectiveBorder = borderColor ?? AppColors.primary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width ?? 0,
        maxWidth: width ?? double.infinity,
        minHeight: height,
      ),
      child: SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveColor,
            side: BorderSide(color: effectiveBorder, width: 1.5),
            minimumSize: Size(width ?? 48.0, height),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: AppRadius.shapeMd,
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: effectiveColor,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: 18, color: effectiveColor),
                      AppSpacing.gapH8,
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: effectiveColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
