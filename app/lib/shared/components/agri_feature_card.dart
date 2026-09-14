import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../illustrations/agri_illustrations.dart';
import '../widgets/app_badge.dart';

/// Primary feature action card specifically designed for farmer accessibility.
/// - Minimum 56dp touch height
/// - Distinct color coding and vector illustration per domain
/// - Clear title + one short line of plain English
/// - Zero horizontal overflow on small screens (320dp+)
class AgriFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final AgriIllustrationType illustrationType;
  final IconData fallbackIcon;
  final Color accentColor;
  final Color lightBgColor;
  final String? badgeLabel;
  final BadgeVariant badgeVariant;
  final VoidCallback? onTap;
  final String? actionHint;

  const AgriFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.illustrationType,
    required this.fallbackIcon,
    required this.accentColor,
    required this.lightBgColor,
    this.badgeLabel,
    this.badgeVariant = BadgeVariant.neutral,
    this.onTap,
    this.actionHint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: '$title. $subtitle. ${badgeLabel ?? ""}',
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusLg,
          side: const BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radiusLg,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration / Icon Badge
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: lightBgColor,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AgriIllustration(
                    type: illustrationType,
                    size: 40,
                    primaryColor: accentColor,
                    secondaryColor: lightBgColor,
                  ),
                ),
                AppSpacing.gapH16,

                // Content (Title + One-line Subtitle + Badge)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, titleConstraints) {
                          if (badgeLabel == null) {
                            return Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            );
                          }
                          if (titleConstraints.maxWidth < 200) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AppBadge(
                                  label: badgeLabel!,
                                  variant: badgeVariant,
                                ),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              AppBadge(
                                label: badgeLabel!,
                                variant: badgeVariant,
                              ),
                            ],
                          );
                        },
                      ),
                      AppSpacing.gapV4,
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.gapH12,

                // Forward chevron action indicator (min 44x44 tap area)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
