import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_outlined_button.dart';
import '../providers/crop_recommendation_state.dart';
import 'edit_soil_bottom_sheet.dart';

/// Premium zero-reentry Soil Information Card.
///
/// Handles all agronomic states:
/// - CASE 1: All soil test information (N, P, K, pH) exists from farm profile.
/// - CASE 2: Soil type exists, but N, P, K, pH are missing.
/// - CASE 3: Farmer declared no soil test report available.
/// - Custom Overridden: Farmer has tuned inputs for this recommendation only.
class SoilInformationCard extends StatelessWidget {
  final CropRecommendationState state;
  final void Function({
    required double n,
    required double p,
    required double k,
    required double ph,
    String? soilType,
    required bool updateProfile,
  }) onSaveSoil;
  final VoidCallback? onNavigateToProfile;

  const SoilInformationCard({
    super.key,
    required this.state,
    required this.onSaveSoil,
    this.onNavigateToProfile,
  });

  void _openEditor(BuildContext context) {
    EditSoilBottomSheet.show(
      context,
      initialN: state.nitrogen,
      initialP: state.phosphorus,
      initialK: state.potassium,
      initialPh: state.ph,
      initialSoilType: state.soilType,
      hasExistingProfile: state.hasSoilReport,
      onSave: onSaveSoil,
    );
  }

  @override
  Widget build(BuildContext context) {
    // CASE 1 & Custom Overridden: We have active soil test values
    if (state.hasActiveSoilData) {
      return _buildCompleteSoilCard(context);
    }

    // CASE 2: Soil type exists, but N/P/K/pH are missing
    if (state.profileSoilType != null && state.profileSoilType!.isNotEmpty && !state.hasSoilReport) {
      return _buildMissingSoilTestCard(
        context,
        title: 'Soil test information is unavailable',
        description:
            'Your farm profile specifies "${state.profileSoilType}", but soil test values (N, P, K, pH) are missing. These values are required for precision crop prediction.',
      );
    }

    // CASE 3 / INCOMPLETE: No soil report
    return _buildMissingSoilTestCard(
      context,
      title: 'Complete your farm soil information',
      description:
          'Your soil test values are missing. Add Nitrogen (N), Phosphorus (P), Potassium (K), and pH to generate an accurate crop recommendation.',
    );
  }

  Widget _buildCompleteSoilCard(BuildContext context) {
    final isCustomized = state.isSoilOverridden;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.science_outlined, color: AppColors.primary, size: 20),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        'SOIL INFORMATION',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppBadge(
                label: isCustomized ? 'CUSTOM' : 'FARM PROFILE',
                variant: isCustomized ? BadgeVariant.warning : BadgeVariant.success,
              ),
            ],
          ),
          AppSpacing.gapV14,

          // Soil Type Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.3),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: const Icon(Icons.terrain_rounded, color: AppColors.primary, size: 20),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Soil Type',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      state.soilType ?? 'Agricultural Soil',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              // Secondary Action: Edit soil information
              TextButton.icon(
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                label: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // NPK & pH Grid
          Row(
            children: [
              Expanded(
                child: _buildNutrientTile(
                  label: 'NPK Values',
                  value:
                      'N ${state.nitrogen!.toStringAsFixed(0)} · P ${state.phosphorus!.toStringAsFixed(0)} · K ${state.potassium!.toStringAsFixed(0)}',
                  subLabel: 'kg/ha',
                  icon: Icons.eco_outlined,
                ),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: _buildNutrientTile(
                  label: 'Soil pH',
                  value: state.ph!.toStringAsFixed(1),
                  subLabel: _getPhDescription(state.ph!),
                  icon: Icons.speed_outlined,
                ),
              ),
            ],
          ),

          if (isCustomized) ...[
            AppSpacing.gapV12,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.harvestGold.withValues(alpha: 0.15),
                borderRadius: AppRadius.radiusSm,
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: AppColors.harvestGold),
                  AppSpacing.gapH6,
                  Expanded(
                    child: Text(
                      'One-time edits active. Saved farm profile remains unchanged.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMissingSoilTestCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return AppCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.harvestGold.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.harvestGold.withValues(alpha: 0.15),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: const Icon(Icons.info_outline, color: AppColors.harvestGold, size: 20),
              ),
              AppSpacing.gapH10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Action needed for recommendation',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV10,
          Text(
            description,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
          AppSpacing.gapV16,
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 360) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppOutlinedButton(
                      label: 'Enter Soil Test Values',
                      leadingIcon: Icons.add_circle_outline,
                      onPressed: () => _openEditor(context),
                    ),
                    if (onNavigateToProfile != null) ...[
                      AppSpacing.gapV8,
                      TextButton(
                        onPressed: onNavigateToProfile,
                        child: const Text(
                          'Update Farm Profile',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'Enter Soil Test Values',
                      leadingIcon: Icons.add_circle_outline,
                      onPressed: () => _openEditor(context),
                    ),
                  ),
                  if (onNavigateToProfile != null) ...[
                    AppSpacing.gapH10,
                    TextButton(
                      onPressed: onNavigateToProfile,
                      child: const Text(
                        'Update Farm Profile',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientTile({
    required String label,
    required String value,
    required String subLabel,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              AppSpacing.gapH4,
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          AppSpacing.gapV4,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
          ),
          Text(
            subLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  String _getPhDescription(double ph) {
    if (ph < 5.5) return 'Strongly Acidic';
    if (ph < 6.5) return 'Slightly Acidic';
    if (ph <= 7.5) return 'Neutral Soil';
    if (ph <= 8.5) return 'Moderately Alkaline';
    return 'Alkaline Soil';
  }
}
