import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/crop_recommendation_state.dart';

/// "Review Before Recommending" decision-support centerpiece.
///
/// Implements progressive disclosure:
/// - Default: Clean, transparent summary of all 7 parameters being supplied to the ML model.
/// - Expanded: Detailed agronomic breakdown and location context.
/// - Primary Action: "Get Crop Recommendation".
class ReadyRecommendationCard extends StatefulWidget {
  final CropRecommendationState state;
  final VoidCallback onGetRecommendation;
  final bool isLoading;

  const ReadyRecommendationCard({
    super.key,
    required this.state,
    required this.onGetRecommendation,
    this.isLoading = false,
  });

  @override
  State<ReadyRecommendationCard> createState() => _ReadyRecommendationCardState();
}

class _ReadyRecommendationCardState extends State<ReadyRecommendationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final isReady = s.isReadyForRecommendation;

    return AppCard(
      borderColor: isReady ? AppColors.primaryLight : AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isReady ? AppColors.successLight : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isReady ? Icons.check_rounded : Icons.pending_outlined,
                        size: 16,
                        color: isReady ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.gapH8,
                    Expanded(
                      child: Text(
                        isReady ? 'READY FOR RECOMMENDATION' : 'CONDITIONS REVIEW',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isReady ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius: AppRadius.radiusSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Hide' : 'Inspect',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV14,

          // Concise Parameter Grid (The Core Review Summary)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  label: 'Soil',
                  value: '${s.soilType ?? "Agricultural Soil"} · pH ${s.ph != null ? s.ph!.toStringAsFixed(1) : "—"}',
                  isSet: s.ph != null,
                ),
                const Divider(height: 14),
                _buildSummaryRow(
                  label: 'NPK',
                  value: s.nitrogen != null && s.phosphorus != null && s.potassium != null
                      ? '${s.nitrogen!.toStringAsFixed(0)} · ${s.phosphorus!.toStringAsFixed(0)} · ${s.potassium!.toStringAsFixed(0)}'
                      : '—',
                  isSet: s.nitrogen != null,
                ),
                const Divider(height: 14),
                _buildSummaryRow(
                  label: 'Temperature',
                  value: s.temperature != null ? '${s.temperature!.toStringAsFixed(1)}°C' : '—',
                  isSet: s.temperature != null,
                ),
                const Divider(height: 14),
                _buildSummaryRow(
                  label: 'Humidity',
                  value: s.humidity != null ? '${s.humidity!.toStringAsFixed(0)}%' : '—',
                  isSet: s.humidity != null,
                ),
                const Divider(height: 14),
                _buildSummaryRow(
                  label: 'Rainfall',
                  value: s.rainfall != null ? '${s.rainfall!.toStringAsFixed(0)} mm' : '—',
                  isSet: s.rainfall != null,
                ),
              ],
            ),
          ),

          // Progressive Disclosure: Expanded Detailed Breakdown
          if (_isExpanded) ...[
            AppSpacing.gapV14,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Farm Context Snapshot',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  ),
                  AppSpacing.gapV6,
                  _buildDetailLine(
                    'Location',
                    [s.village, s.district, s.state].where((v) => v.isNotEmpty).join(', '),
                  ),
                  _buildDetailLine('Holding', '${s.landArea.toStringAsFixed(1)} ${s.areaUnit}'),
                  _buildDetailLine('Irrigation', s.irrigationType),
                  _buildDetailLine(
                    'Soil Data Source',
                    s.isSoilOverridden ? 'Manual override for this run' : 'Hydrated from Farm Profile',
                  ),
                  _buildDetailLine('Weather Data Source', s.weatherSource),
                ],
              ),
            ),
          ],

          AppSpacing.gapV16,

          // Notice if not ready
          if (!isReady) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.harvestGold.withValues(alpha: 0.15),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.harvestGold),
                  AppSpacing.gapH8,
                  Expanded(
                    child: Text(
                      'Missing: ${s.missingRequirements.join(", ")}.',
                      style: const TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Primary CTA Button
          AppButton(
            label: widget.isLoading ? 'Analyzing Farm Conditions...' : 'Get Crop Recommendation',
            leadingIcon: Icons.psychology_outlined,
            isLoading: widget.isLoading,
            onPressed: isReady && !widget.isLoading ? widget.onGetRecommendation : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required bool isSet,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isSet ? AppColors.textPrimary : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
