import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'app_button.dart';
import 'app_card.dart';

// ==========================================
// 1. FARMER STATUS BADGE (🟢 🟡 🟠 🔴)
// ==========================================

enum FarmerStatus {
  good,
  check,
  warning,
  urgent,
}

/// Visual status indicator combining color, icon, and text.
/// 🟢 Good | 🟡 Check | 🟠 Warning | 🔴 Urgent
class FarmerStatusBadge extends StatelessWidget {
  final FarmerStatus status;
  final String? customLabel;
  final bool isLarge;

  const FarmerStatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color fg;
    IconData icon;
    String defaultText;

    switch (status) {
      case FarmerStatus.good:
        bg = const Color(0xFFE8F5E9);
        border = const Color(0xFFA5D6A7);
        fg = const Color(0xFF1B5E20);
        icon = Icons.check_circle_rounded;
        defaultText = 'Good';
        break;
      case FarmerStatus.check:
        bg = const Color(0xFFFFFDE7);
        border = const Color(0xFFFFF176);
        fg = const Color(0xFFF57F17);
        icon = Icons.info_rounded;
        defaultText = 'Check';
        break;
      case FarmerStatus.warning:
        bg = const Color(0xFFFFF3E0);
        border = const Color(0xFFFFCC80);
        fg = const Color(0xFFE65100);
        icon = Icons.warning_rounded;
        defaultText = 'Warning';
        break;
      case FarmerStatus.urgent:
        bg = const Color(0xFFFFEBEE);
        border = const Color(0xFFEF9A9A);
        fg = const Color(0xFFC62828);
        icon = Icons.error_rounded;
        defaultText = 'Urgent';
        break;
    }

    final displayText = customLabel ?? defaultText;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12 : 8,
        vertical: isLarge ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.radiusPill,
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isLarge ? 16 : 13, color: fg),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              displayText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isLarge ? 13 : 11.5,
                fontWeight: FontWeight.w700,
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

// ==========================================
// 2. FARMER VOICE ASSISTANT BUTTON ("🔊 Listen")
// ==========================================

/// Accessible "🔊 Listen" button with haptic feedback to read advice aloud.
class FarmerVoiceButton extends StatelessWidget {
  final String textToSpeak;
  final String label;
  final VoidCallback? onSpeak;

  const FarmerVoiceButton({
    super.key,
    required this.textToSpeak,
    this.label = 'Listen',
    this.onSpeak,
  });

  void _handleSpeak(BuildContext context) {
    HapticFeedback.lightImpact();
    if (onSpeak != null) {
      onSpeak!();
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Playing voice audio: "$textToSpeak"',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.sage.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _handleSpeak(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.primaryDark),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. FARMER ALERT CARD (See → Understand → Act)
// Problem → Impact → Action → Time
// ==========================================

class FarmerAlertCard extends StatelessWidget {
  final String problem;
  final String impact;
  final String actionTitle;
  final String? timeWindow;
  final IconData icon;
  final Color iconColor;
  final Color badgeColor;
  final VoidCallback? onAction;
  final VoidCallback? onDetails;

  const FarmerAlertCard({
    super.key,
    required this.problem,
    required this.impact,
    required this.actionTitle,
    this.timeWindow,
    this.icon = Icons.warning_amber_rounded,
    this.iconColor = AppColors.warning,
    this.badgeColor = AppColors.warningLight,
    this.onAction,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Problem + Audio button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      problem,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (timeWindow != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: iconColor),
                          const SizedBox(width: 4),
                          Text(
                            timeWindow!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              FarmerVoiceButton(textToSpeak: '$problem. $impact. $actionTitle'),
            ],
          ),
          AppSpacing.gapV10,

          // Impact explanation (1 short sentence)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV12,

          // Bottom Action Row
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: actionTitle,
                  height: 44,
                  fontSize: 13.5,
                  onPressed: onAction ?? onDetails,
                ),
              ),
              if (onDetails != null) ...[
                AppSpacing.gapH8,
                OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: AppRadius.shapeMd,
                    side: const BorderSide(color: AppColors.cardBorder, width: 1.2),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. FARMER WEATHER SUMMARY CARD
// ==========================================

class FarmerWeatherSummary extends StatelessWidget {
  final String temperature;
  final String condition;
  final int rainProbability;
  final String farmingImpact;
  final VoidCallback? onTap;

  const FarmerWeatherSummary({
    super.key,
    required this.temperature,
    required this.condition,
    required this.rainProbability,
    required this.farmingImpact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Weather Condition Icon & Temp
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapH10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.water_drop_outlined, size: 13, color: AppColors.sky),
                        const SizedBox(width: 3),
                        Text(
                          'Rain: $rainProbability%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sky,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24),
            ],
          ),
          AppSpacing.gapV10,

          // 1 Single Clear Farming Impact
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.4),
              borderRadius: AppRadius.radiusSm,
              border: Border.all(color: AppColors.sageMedium.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_rounded, size: 15, color: AppColors.primaryDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmingImpact,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. FARMER ACTION CARD (One-Handed / Outdoor Touch)
// ==========================================

class FarmerActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const FarmerActionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBgColor = const Color(0xFFE8F5E9),
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMd,
        side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing! else const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. FARMER INFO ROW (Clean tappable rows)
// ==========================================

class FarmerInfoRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget? trailing;

  const FarmerInfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusSm,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: AppColors.primary),
                    AppSpacing.gapH12,
                  ],
                  Expanded(
                    flex: 2,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ] else if (onTap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textTertiary),
                  ],
                ],
              ),
            ),
            if (showDivider)
              const Divider(height: 1, thickness: 1, color: AppColors.cardBorder),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. FARMER SECTION HEADER (< 5 words)
// ==========================================

class FarmerSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const FarmerSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(40, 32),
            ),
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ==========================================
// 8. FARMER OFFLINE BANNER
// ==========================================

class FarmerOfflineBanner extends StatelessWidget {
  const FarmerOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, size: 16, color: Color(0xFF92400E)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Offline • Showing saved farm data',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 9. FARMER BUTTONS (48-56dp Touch Target)
// ==========================================

class FarmerPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final double? width;

  const FarmerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 52,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: AppRadius.shapeMd,
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class FarmerSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final double? width;

  const FarmerSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 50,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: AppRadius.shapeMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 19),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 10. FARMER FEEDBACK & STATE WIDGETS
// ==========================================

class FarmerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const FarmerEmptyState({
    super.key,
    this.icon = Icons.eco_outlined,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            AppSpacing.gapV16,
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV6,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapV20,
              FarmerPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FarmerLoadingState extends StatelessWidget {
  final String message;

  const FarmerLoadingState({
    super.key,
    this.message = 'Loading farm information...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3.5,
            ),
            AppSpacing.gapV16,
            Text(
              message,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const FarmerErrorState({
    super.key,
    this.title = 'Could not load',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline_rounded, size: 48, color: AppColors.warning),
            AppSpacing.gapV12,
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV6,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.gapV16,
              FarmerSecondaryButton(
                label: 'Try again',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
