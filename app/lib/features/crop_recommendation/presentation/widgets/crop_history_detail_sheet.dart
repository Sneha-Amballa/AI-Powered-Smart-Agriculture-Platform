import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/crop_history_model.dart';

/// Modal bottom sheet showing full immutable audit trail of a previous recommendation.
class CropHistoryDetailSheet extends StatelessWidget {
  final CropHistoryItem item;

  const CropHistoryDetailSheet({
    super.key,
    required this.item,
  });

  static Future<void> show(BuildContext context, CropHistoryItem item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => CropHistoryDetailSheet(item: item),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = dt.day;
    final month = months[dt.month - 1];
    final year = dt.year;

    final hour24 = dt.hour;
    final hour = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';

    return '$day $month $year, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommendation Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 20),

              // 1. RECOMMENDATION
              const Text(
                'RECOMMENDATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapV8,
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: AppRadius.radiusSm,
                      ),
                      child: const Icon(Icons.eco, color: AppColors.primary, size: 24),
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.recommendedCrop.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            'Generated: ${_formatDateTime(item.createdAt)}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (item.confidence != null) ...[
                      AppBadge(
                        label: '${item.confidence!.toStringAsFixed(1)}% Match',
                        variant: BadgeVariant.success,
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // 2. FARM CONTEXT
              const Text(
                'FARM CONTEXT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapV8,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildRow('Location', item.locationSummary),
                    const Divider(height: 14),
                    _buildRow('Land', item.landSummary),
                    const Divider(height: 14),
                    _buildRow('Soil', item.soilType),
                    const Divider(height: 14),
                    _buildRow('Irrigation', item.irrigationType),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // 3. CONDITIONS USED
              const Text(
                'CONDITIONS USED',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.gapV8,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildRow('Nitrogen (N)', '${item.nitrogen.toStringAsFixed(0)} kg/ha'),
                    const Divider(height: 12),
                    _buildRow('Phosphorus (P)', '${item.phosphorus.toStringAsFixed(0)} kg/ha'),
                    const Divider(height: 12),
                    _buildRow('Potassium (K)', '${item.potassium.toStringAsFixed(0)} kg/ha'),
                    const Divider(height: 12),
                    _buildRow('Soil pH', item.ph.toStringAsFixed(1)),
                    const Divider(height: 12),
                    _buildRow('Temperature', '${item.temperature.toStringAsFixed(1)}°C'),
                    const Divider(height: 12),
                    _buildRow('Humidity', '${item.humidity.toStringAsFixed(0)}%'),
                    const Divider(height: 12),
                    _buildRow('Rainfall', '${item.rainfall.toStringAsFixed(0)} mm'),
                    const Divider(height: 12),
                    _buildRow('Data Source', item.dataSource),
                  ],
                ),
              ),

              // Alternatives if available
              if (item.alternatives.length > 1) ...[
                AppSpacing.gapV16,
                const Text(
                  'MODEL ALTERNATIVES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.gapV8,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: item.alternatives.skip(1).map((alt) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(alt.crop.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('${alt.confidence.toStringAsFixed(1)}% Match',
                                style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              AppSpacing.gapV20,
              AppButton(
                label: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
              AppSpacing.gapV20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
