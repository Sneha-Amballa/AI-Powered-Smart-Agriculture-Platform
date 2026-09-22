import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_outlined_button.dart';
import '../../data/crop_recommendation_model.dart';
import '../providers/crop_recommendation_state.dart';

/// Production recommendation result card.
///
/// Complies strictly with responsible AI guidelines:
/// - Wording: "Recommended Crop", "This recommendation is based on the farm conditions provided."
/// - Explicit agronomic advisory note.
/// - Shows exact conditions used (N, P, K, pH, Temperature, Humidity, Rainfall).
/// - Shows actual API returned alternatives with confidence without inventing yield/profit metrics.
class RecommendationResultCard extends StatelessWidget {
  final CropRecommendationResult result;
  final CropRecommendationState state;
  final VoidCallback onViewHistory;
  final VoidCallback onRunAgain;

  const RecommendationResultCard({
    super.key,
    required this.result,
    required this.state,
    required this.onViewHistory,
    required this.onRunAgain,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  AppSpacing.gapH8,
                  Text(
                    'RECOMMENDED CROP',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              AppBadge(
                label: result.recommendations.isNotEmpty
                    ? '${result.recommendations.first.confidence.toStringAsFixed(1)}% ML Match'
                    : 'Optimal',
                variant: BadgeVariant.success,
              ),
            ],
          ),
          AppSpacing.gapV14,

          // Crop Name Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.eco, size: 30, color: AppColors.primary),
                ),
                AppSpacing.gapH16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.recommendedCrop.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      AppSpacing.gapV2,
                      const Text(
                        'This recommendation is based on the farm conditions provided.',
                        style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV16,

          // Conditions Used Section
          const Text(
            'CONDITIONS USED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildConditionChip('N', '${state.nitrogen?.toStringAsFixed(0) ?? "—"} kg/ha'),
                _buildConditionChip('P', '${state.phosphorus?.toStringAsFixed(0) ?? "—"} kg/ha'),
                _buildConditionChip('K', '${state.potassium?.toStringAsFixed(0) ?? "—"} kg/ha'),
                _buildConditionChip('pH', state.ph?.toStringAsFixed(1) ?? '—'),
                _buildConditionChip('Temp', '${state.temperature?.toStringAsFixed(1) ?? "—"}°C'),
                _buildConditionChip('Humidity', '${state.humidity?.toStringAsFixed(0) ?? "—"}%'),
                _buildConditionChip('Rainfall', '${state.rainfall?.toStringAsFixed(0) ?? "—"} mm'),
              ],
            ),
          ),

          // Real Alternatives returned by API (if any)
          if (result.recommendations.length > 1) ...[
            AppSpacing.gapV16,
            const Text(
              'ALTERNATIVE SUITABLE CROPS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV8,
            ...result.recommendations.skip(1).map((alt) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      alt.crop.toUpperCase(),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    Text(
                      '${alt.confidence.toStringAsFixed(1)}% Match',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }),
          ],

          AppSpacing.gapV14,

          // Agronomic Advisory Disclaimer
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.25),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.primary),
                AppSpacing.gapH8,
                Expanded(
                  child: Text(
                    'Consider local agricultural guidance, mandi market price, and water availability before making final planting decisions.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV20,

          // Navigation & Action Buttons
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  label: 'View Crop History',
                  leadingIcon: Icons.history_rounded,
                  onPressed: onViewHistory,
                ),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: AppButton(
                  label: 'Run New Analysis',
                  leadingIcon: Icons.refresh_rounded,
                  onPressed: onRunAgain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
