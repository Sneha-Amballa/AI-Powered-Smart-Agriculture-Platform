import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// "Today's Farm Actions" widget for the farmer-first dashboard.
/// Provides immediate, high-priority 1-tap operational tasks.
class TodaysFarmActions extends StatelessWidget {
  const TodaysFarmActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Farm Actions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapV10,
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 340;
            if (isNarrow) {
              return Column(
                children: [
                  _buildActionTile(
                    context,
                    icon: Icons.camera_alt_outlined,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: AppColors.primary,
                    title: 'Scan Leaf Health',
                    subtitle: 'Check spots & pests',
                    route: '/disease-detection',
                  ),
                  AppSpacing.gapV8,
                  _buildActionTile(
                    context,
                    icon: Icons.water_drop_outlined,
                    iconBg: const Color(0xFFE0F2F1),
                    iconColor: const Color(0xFF00796B),
                    title: 'Check Rain & Spray',
                    subtitle: 'Safe window today',
                    route: '/weather',
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    context,
                    icon: Icons.camera_alt_outlined,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: AppColors.primary,
                    title: 'Scan Leaf Health',
                    subtitle: 'Check spots & pests',
                    route: '/disease-detection',
                  ),
                ),
                AppSpacing.gapH10,
                Expanded(
                  child: _buildActionTile(
                    context,
                    icon: Icons.water_drop_outlined,
                    iconBg: const Color(0xFFE0F2F1),
                    iconColor: const Color(0xFF00796B),
                    title: 'Check Rain & Spray',
                    subtitle: 'Safe window today',
                    route: '/weather',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMd,
        side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              AppSpacing.gapH10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
