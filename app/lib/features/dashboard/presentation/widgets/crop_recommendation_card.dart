import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/dashboard_data.dart';

/// Crop recommendation summary widget communicating optimal crop match or prompt to recommend.
class CropRecommendationSummaryCard extends StatelessWidget {
  final CropRecommendationSummary crop;

  const CropRecommendationSummaryCard({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    if (!crop.hasRecommendation || crop.cropName.isEmpty) {
      return _buildEmptyCard(context);
    }

    return AppCard(
      onTap: () => context.go(crop.actionRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                    AppSpacing.gapH6,
                    Flexible(
                      child: Text(
                        'LATEST CROP RECOMMENDATION',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.radiusPill,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  crop.badgeText ?? '${crop.confidencePercentage.toInt()}% Match',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV4,
          Text(
            crop.subtitle,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
          AppSpacing.gapV14,

          // Recommended Crop Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: AppRadius.radiusSm,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                AppSpacing.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RECOMMENDED CROP',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        crop.cropName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV12,

          // Soil match description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.science_outlined,
                size: 15,
                color: AppColors.textSecondary,
              ),
              AppSpacing.gapH6,
              Expanded(
                child: Text(
                  crop.soilMatchDetails,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV8,

          // Action Link: View Recommendation
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.go(crop.actionRoute),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Text(
                  'View Recommendation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                label: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return AppCard(
      onTap: () => context.go(crop.actionRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                    AppSpacing.gapH6,
                    Flexible(
                      child: Text(
                        'LATEST CROP RECOMMENDATION',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppBadge(label: 'READY', variant: BadgeVariant.neutral),
            ],
          ),
          AppSpacing.gapV10,
          Text(
            crop.subtitle.isNotEmpty
                ? crop.subtitle
                : 'Get a recommendation based on your farm conditions.',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV6,
          Text(
            crop.soilMatchDetails.isNotEmpty
                ? crop.soilMatchDetails
                : 'AI analyzes your soil nutrients and climate to recommend the most optimal crop.',
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.3),
          ),
          AppSpacing.gapV12,
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.go(crop.actionRoute),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Text(
                  'Get Crop Recommendation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                label: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
