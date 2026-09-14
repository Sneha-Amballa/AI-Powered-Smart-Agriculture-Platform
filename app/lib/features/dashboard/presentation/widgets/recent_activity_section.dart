import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/dashboard_data.dart';

/// Activity timeline section with support for an elegant empty state.
class RecentActivitySection extends StatelessWidget {
  final List<RecentActivityItem> activities;

  const RecentActivitySection({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Farm Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        AppSpacing.gapV10,

        if (activities.isEmpty)
          _buildEmptyState(context)
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(activities.length, (index) {
                final item = activities[index];
                final isLast = index == activities.length - 1;
                return Column(
                  children: [
                    _buildActivityTile(context, item),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.cardBorder,
                      ),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, RecentActivityItem item) {
    return InkWell(
      onTap: item.route != null ? () => context.go(item.route!) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.accentColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.radiusSm,
              ),
              child: Icon(item.icon, size: 18, color: item.accentColor),
            ),
            AppSpacing.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (item.badgeLabel != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: AppRadius.radiusPill,
                          ),
                          child: Text(
                            item.badgeLabel!,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.timestampText,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapV10,
            const Text(
              'No recent activity recorded yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV4,
            const Text(
              'Run a crop test, scan a leaf, or check mandi rates to build your timeline.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
