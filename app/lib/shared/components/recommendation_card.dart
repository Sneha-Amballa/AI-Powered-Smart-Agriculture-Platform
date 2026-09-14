import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_card.dart';

/// Reusable card displaying crop recommendation result and alternative rankings.
class RecommendationCard extends StatelessWidget {
  final String cropName;
  final double confidence;
  final String? soilSummary;
  final VoidCallback? onTap;

  const RecommendationCard({
    super.key,
    required this.cropName,
    required this.confidence,
    this.soilSummary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      backgroundColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                    AppSpacing.gapH6,
                    Flexible(
                      child: Text(
                        'AI Recommendation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH8,
              AppBadge(
                label: '${confidence.toStringAsFixed(1)}% Match',
                variant: BadgeVariant.success,
              ),
            ],
          ),
          AppSpacing.gapV12,
          Text(
            cropName.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.textPrimary,
            ),
          ),
          if (soilSummary != null) ...[
            AppSpacing.gapV6,
            Text(
              soilSummary!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
