import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/dashboard_data.dart';

/// The visual centerpiece of the Farmer Dashboard.
/// Communicates high-priority agricultural advisories and operational decision support.
class FarmAdvisoryCard extends StatelessWidget {
  final FarmAdvisory advisory;

  const FarmAdvisoryCard({
    super.key,
    required this.advisory,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = advisory.severity == AdvisorySeverity.critical;
    final isWarning = advisory.severity == AdvisorySeverity.warning;

    final badgeBg = isCritical
        ? const Color(0xFFFFEBEE)
        : (isWarning ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9));
    final badgeColor = isCritical
        ? AppColors.error
        : (isWarning ? const Color(0xFFE65100) : AppColors.primary);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.radiusXl,
        boxShadow: AppShadows.card,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          // Subtle background decorative pattern (watermark icon)
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.agriculture_rounded,
              size: 110,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag: Centerpiece Badge
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: AppRadius.radiusPill,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isWarning || isCritical
                                ? Icons.warning_amber_rounded
                                : Icons.lightbulb_outline_rounded,
                            size: 13,
                            color: badgeColor,
                          ),
                          AppSpacing.gapH4,
                          Text(
                            advisory.severityLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: badgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'TODAY’S ADVISORY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.sage,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV14,

                // Headline
                Text(
                  advisory.headline,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                AppSpacing.gapV6,

                // Actionable Agricultural Guidance
                Text(
                  advisory.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFD7E5DC), // Soft light sage for contrast
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                AppSpacing.gapV16,

                // CTA Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(advisory.actionRoute),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text(advisory.actionLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sage,
                      foregroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.radiusMd,
                      ),
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
