import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../data/crop_history_model.dart';
import 'crop_history_detail_sheet.dart';

/// Clean, prioritize-first Crop History Card adhering to Requirement 15.
/// Prioritizes: Recommended Crop, Formatted Date, NPK, pH, and "View Details".
class CropHistoryCard extends StatelessWidget {
  final CropHistoryItem item;
  final VoidCallback? onDelete;

  const CropHistoryCard({
    super.key,
    required this.item,
    this.onDelete,
  });

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => CropHistoryDetailSheet.show(context, item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Crop Name & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: AppRadius.radiusSm,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.primary, size: 22),
                  ),
                  AppSpacing.gapH10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RECOMMENDED CROP',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        item.recommendedCrop.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusPill,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  _formatDate(item.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,

          // NPK & pH row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusSm,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.npkSummary,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  height: 14,
                  width: 1,
                  color: AppColors.cardBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(
                  'pH ${item.ph.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV10,

          // Footer: "View Details"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.dataSource,
                style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
              TextButton.icon(
                onPressed: () => CropHistoryDetailSheet.show(context, item),
                icon: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                label: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
