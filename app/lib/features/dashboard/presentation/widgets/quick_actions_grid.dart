import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class _QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;
  final String? badge;

  const _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
    this.badge,
  });
}

/// Coherent quick actions grid adhering to the agricultural design system.
/// Guaranteed zero emojis, responsive columns, and minimum 56dp touch targets.
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const List<_QuickActionItem> _actions = [
    _QuickActionItem(
      title: 'Crop Recommendation',
      subtitle: 'Live ML Prediction',
      icon: Icons.eco_rounded,
      color: AppColors.primary,
      bgColor: Color(0xFFE8F5E9),
      route: '/crop-recommendation',
      badge: 'LIVE ML',
    ),
    _QuickActionItem(
      title: 'Disease Detection',
      subtitle: 'Scan Crop Leaf',
      icon: Icons.biotech_rounded,
      color: Color(0xFF00796B),
      bgColor: Color(0xFFE0F2F1),
      route: '/disease-detection',
      badge: 'VISION AI',
    ),
    _QuickActionItem(
      title: 'Weather & Rain',
      subtitle: '7-Day Agronomy',
      icon: Icons.cloud_outlined,
      color: Color(0xFF0277BD),
      bgColor: Color(0xFFE1F5FE),
      route: '/weather',
    ),
    _QuickActionItem(
      title: 'Market Mandi',
      subtitle: 'Live APMC Rates',
      icon: Icons.storefront_rounded,
      color: Color(0xFF4527A0),
      bgColor: Color(0xFFEDE7F6),
      route: '/market',
    ),
    _QuickActionItem(
      title: 'Government Schemes',
      subtitle: 'PM-KISAN & Grants',
      icon: Icons.account_balance_outlined,
      color: Color(0xFFC2185B),
      bgColor: Color(0xFFFCE4EC),
      route: '/government-schemes',
    ),
    _QuickActionItem(
      title: 'Kisan AI Assistant',
      subtitle: '24/7 Vernacular Help',
      icon: Icons.forum_rounded,
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
        double childAspectRatio = 1.9;

        if (constraints.maxWidth >= 800) {
          crossAxisCount = 6;
          childAspectRatio = 1.3;
        } else if (constraints.maxWidth >= 550) {
          crossAxisCount = 3;
          childAspectRatio = 1.6;
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
      label: '${item.title}. ${item.subtitle}',
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusMd,
          side: const BorderSide(color: AppColors.cardBorder, width: 1.1),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: AppRadius.radiusSm,
                  ),
                  child: Icon(item.icon, size: 22, color: item.color),
                ),
                AppSpacing.gapH10,

                // Title and subtitle
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
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: item.color,
                          fontWeight: FontWeight.w600,
                        ),
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
