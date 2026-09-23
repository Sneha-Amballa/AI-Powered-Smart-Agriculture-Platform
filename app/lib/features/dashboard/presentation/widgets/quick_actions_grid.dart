import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class _QuickActionItem {
  final String title;
  final String statusLabel;
  final bool isLive;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;

  const _QuickActionItem({
    required this.title,
    required this.statusLabel,
    required this.isLive,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
  });
}

/// Production-grade quick actions grid with concise icon-led cards and status chips.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const List<_QuickActionItem> _actions = [
    _QuickActionItem(
      title: 'Crop Recommendation',
      statusLabel: 'Active',
      isLive: true,
      icon: Icons.eco_rounded,
      color: AppColors.primary,
      bgColor: Color(0xFFE8F5E9),
      route: '/crop-recommendation',
    ),
    _QuickActionItem(
      title: 'Plant Disease Scan',
      statusLabel: 'In Progress',
      isLive: false,
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFF00796B),
      bgColor: Color(0xFFE0F2F1),
      route: '/disease-detection',
    ),
    _QuickActionItem(
      title: 'Mandi Market Rates',
      statusLabel: 'In Progress',
      isLive: false,
      icon: Icons.storefront_rounded,
      color: Color(0xFF4527A0),
      bgColor: Color(0xFFEDE7F6),
      route: '/market',
    ),
    _QuickActionItem(
      title: 'AI Farm Assistant',
      statusLabel: 'In Progress',
      isLive: false,
      icon: Icons.forum_outlined,
      color: Color(0xFF1565C0),
      bgColor: Color(0xFFE3F2FD),
      route: '/assistant',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double childAspectRatio = 1.95;

        if (constraints.maxWidth >= 720) {
          crossAxisCount = 4;
          childAspectRatio = 1.4;
        } else if (constraints.maxWidth >= 500) {
          crossAxisCount = 2;
          childAspectRatio = 2.2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _actions.length,
          itemBuilder: (context, index) {
            final item = _actions[index];
            return _buildActionCard(context, item);
          },
        );
      },
    );
  }

  Widget _buildActionCard(BuildContext context, _QuickActionItem item) {
    return Semantics(
      button: true,
      label: '${item.title}. ${item.statusLabel}',
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusMd,
          side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: AppRadius.radiusMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: AppRadius.radiusSm,
                  ),
                  child: Icon(item.icon, size: 20, color: item.color),
                ),
                AppSpacing.gapH10,

                // Title and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: item.isLive ? AppColors.success : AppColors.textTertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.statusLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: item.isLive ? AppColors.success : AppColors.textSecondary,
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
          ),
        ),
      ),
    );
  }
}
