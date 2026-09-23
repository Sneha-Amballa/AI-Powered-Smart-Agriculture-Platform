import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/farmer_components.dart';
import '../../domain/models/dashboard_data.dart';

/// The visual centerpiece of the Farmer Dashboard.
/// Implements "See → Understand → Act":
/// Problem → Impact → Action → Time, with audio read-aloud and progressive disclosure.
class FarmAdvisoryCard extends StatelessWidget {
  final FarmAdvisory advisory;

  const FarmAdvisoryCard({
    super.key,
    required this.advisory,
  });

  void _showAdvisoryDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppSpacing.gapV16,
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 24),
                  AppSpacing.gapH8,
                  const Expanded(
                    child: Text(
                      'Farm Advisory Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  FarmerVoiceButton(textToSpeak: '${advisory.headline}. ${advisory.description}'),
                ],
              ),
              AppSpacing.gapV14,
              Text(
                advisory.headline,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV8,
              Text(
                advisory.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapV20,
              FarmerPrimaryButton(
                label: advisory.actionLabel,
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go(advisory.actionRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                // Top Tag: Centerpiece Badge + Audio Listen (Wrap for responsive 320dp)
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
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
                    FarmerVoiceButton(
                      textToSpeak: '${advisory.headline}. ${advisory.description}',
                    ),
                  ],
                ),
                AppSpacing.gapV12,

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
                AppSpacing.gapV8,

                // Problem → Impact → Action Box (Farmer-Friendly)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGuidanceRow(
                        Icons.cloud_outlined,
                        'Rain tomorrow: Pesticide will wash away',
                        const Color(0xFF90CAF9),
                      ),
                      const SizedBox(height: 6),
                      _buildGuidanceRow(
                        Icons.cancel_outlined,
                        "Don't spray your crops today",
                        const Color(0xFFFFCC80),
                      ),
                      const SizedBox(height: 6),
                      _buildGuidanceRow(
                        Icons.schedule_rounded,
                        'Best spraying window: Thursday morning',
                        const Color(0xFFA5D6A7),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapV14,

                // Action Buttons Row (Wrap for responsive 320dp)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
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
                    OutlinedButton(
                      onPressed: () => _showAdvisoryDetails(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.radiusMd,
                        ),
                      ),
                      child: const Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
