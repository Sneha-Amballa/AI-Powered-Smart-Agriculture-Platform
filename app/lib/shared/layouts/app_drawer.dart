import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../widgets/app_divider.dart';
import '../widgets/app_logo.dart';

/// Commercial-grade navigation drawer structured logically without emojis.
class AppDrawer extends ConsumerWidget {
  final String currentPath;

  const AppDrawer({
    super.key,
    this.currentPath = '/dashboard',
  });

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your farmer account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final farmerName = authState.user?.fullName.isNotEmpty == true
        ? authState.user!.fullName
        : 'AI Agriculture Platform';
    final mobileNumber = authState.user?.phoneNumber.isNotEmpty == true
        ? '+91 ${authState.user!.phoneNumber}'
        : 'Precision Farming & Agronomy';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(size: 32),
                  AppSpacing.gapV12,
                  Text(
                    farmerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapV4,
                  Text(
                    mobileNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const AppDivider(height: 1),

            // Scrollable Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                children: [
                  _buildSectionHeader('MAIN'),
                  _buildNavItem(
                    context: context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    path: '/dashboard',
                  ),

                  _buildSectionHeader('FARMING'),
                  _buildNavItem(
                    context: context,
                    title: 'Crop Recommendation',
                    icon: Icons.eco_outlined,
                    path: '/crop-recommendation',
                    isLive: true,
                  ),
                  _buildNavItem(
                    context: context,
                    title: 'Disease Detection',
                    icon: Icons.biotech_outlined,
                    path: '/disease-detection',
                  ),

                  _buildSectionHeader('INSIGHTS'),
                  _buildNavItem(
                    context: context,
                    title: 'Weather & Advisory',
                    icon: Icons.cloud_outlined,
                    path: '/weather',
                  ),
                  _buildNavItem(
                    context: context,
                    title: 'Market Prices',
                    icon: Icons.trending_up_outlined,
                    path: '/market',
                  ),
                  _buildNavItem(
                    context: context,
                    title: 'Price Prediction',
                    icon: Icons.timeline_outlined,
                    path: '/price-prediction',
                  ),

                  _buildSectionHeader('SUPPORT'),
                  _buildNavItem(
                    context: context,
                    title: 'Government Schemes',
                    icon: Icons.account_balance_outlined,
                    path: '/government-schemes',
                  ),
                  _buildNavItem(
                    context: context,
                    title: 'AI Assistant',
                    icon: Icons.forum_outlined,
                    path: '/assistant',
                  ),

                  _buildSectionHeader('ACCOUNT'),
                  _buildNavItem(
                    context: context,
                    title: 'Farmer Profile',
                    icon: Icons.person_outline,
                    path: '/profile',
                  ),
                  _buildNavItem(
                    context: context,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    path: '/settings',
                  ),
                ],
              ),
            ),

            const AppDivider(height: 1),
            // Footer: Logout / Public Home
            ListTile(
              leading: const Icon(Icons.home_outlined, color: AppColors.textSecondary, size: 22),
              title: const Text(
                'Public Landing Page',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
              minVerticalPadding: 12,
              minLeadingWidth: 28,
              onTap: () {
                Navigator.of(context).pop();
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error, size: 22),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
              minVerticalPadding: 12,
              minLeadingWidth: 28,
              onTap: () {
                Navigator.of(context).pop();
                _showLogoutDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.xxs,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String path,
    bool isLive = false,
  }) {
    final isSelected = currentPath == path;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.sage.withValues(alpha: 0.6) : Colors.transparent,
        borderRadius: AppRadius.radiusMd,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        minLeadingWidth: 28,
        minVerticalPadding: 8,
        leading: Icon(
          icon,
          size: 22,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
          ),
        ),
        trailing: isLive
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.radiusPill,
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              )
            : null,
        shape: AppRadius.shapeMd,
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          if (!isSelected) {
            context.go(path);
          }
        },
      ),
    );
  }
}
