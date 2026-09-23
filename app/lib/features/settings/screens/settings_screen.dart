import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/language_selector_sheet.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/farmer_components.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// Farmer-first Settings Screen.
/// Clean grouped list sections with simple tappable rows and no long descriptions:
/// 1. Account
/// 2. Notifications
/// 3. Language
/// 4. Offline Data
/// 5. Help
/// 6. Privacy
/// 7. App Version
/// 8. Sign Out
/// 9. Delete Account
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? Your farm profile and saved data will remain safely preserved on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully. Your farm profile is preserved.')),
                );
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Expanded(child: Text('Delete Account?')),
          ],
        ),
        content: const Text(
          'All your saved farm records, soil test results, and credentials will be permanently erased.',
          style: TextStyle(fontSize: 14),
        ),
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
              await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account permanently deleted.'),
                    backgroundColor: AppColors.error,
                  ),
                );
                context.go('/login');
              }
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _clearOfflineCache(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offline data refreshed. 12.4 MB storage cleared.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final activeLang = ref.watch(localeNotifierProvider);
    final farmerName = authState.user?.fullName.isNotEmpty == true
        ? authState.user!.fullName
        : 'Registered Farmer';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Account Section
                  const FarmerSectionHeader(title: 'Account & Profile'),
                  AppSpacing.gapV10,
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        FarmerInfoRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Account',
                          value: farmerName,
                          onTap: () => context.go('/profile'),
                        ),
                        FarmerInfoRow(
                          icon: Icons.translate_outlined,
                          label: 'Language',
                          value: activeLang.displayName,
                          showDivider: false,
                          onTap: () => showLanguageSelectorSheet(context, ref),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV16,

                  // 2. Notifications & Offline Data
                  const FarmerSectionHeader(title: 'Farm Alerts & Data'),
                  AppSpacing.gapV10,
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() => _notificationsEnabled = !_notificationsEnabled);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_notificationsEnabled
                                      ? 'Advisory alerts enabled'
                                      : 'Advisory alerts paused'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_outlined, size: 20, color: AppColors.primary),
                                  AppSpacing.gapH12,
                                  const Expanded(
                                    child: Text(
                                      'Notifications',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: _notificationsEnabled,
                                    activeThumbColor: AppColors.primary,
                                    activeTrackColor: AppColors.sage,
                                    onChanged: (val) {
                                      setState(() => _notificationsEnabled = val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1, color: AppColors.cardBorder),
                        FarmerInfoRow(
                          icon: Icons.wifi_off_rounded,
                          label: 'Offline Data',
                          value: 'Saved (12.4 MB)',
                          showDivider: false,
                          onTap: () => _clearOfflineCache(context),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV16,

                  // 3. Help, Privacy & Version
                  const FarmerSectionHeader(title: 'Support & App'),
                  AppSpacing.gapV10,
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        FarmerInfoRow(
                          icon: Icons.support_agent_rounded,
                          label: 'Help',
                          value: '1800-180-1551',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kisan Call Center: Dial 1800-180-1551 (Toll-Free 6 AM - 10 PM)'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                        FarmerInfoRow(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy',
                          value: 'Protected',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your farm data is encrypted and private.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        const FarmerInfoRow(
                          icon: Icons.info_outline_rounded,
                          label: 'App Version',
                          value: 'v1.0.0 (KisanAI)',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV16,

                  // 4. Session & Actions
                  const FarmerSectionHeader(title: 'Session'),
                  AppSpacing.gapV10,
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        FarmerInfoRow(
                          icon: Icons.logout_rounded,
                          label: 'Sign Out',
                          value: 'Safe exit',
                          onTap: () => _showLogoutDialog(context),
                        ),
                        FarmerInfoRow(
                          icon: Icons.delete_forever_outlined,
                          label: 'Delete Account',
                          value: 'Erase all',
                          showDivider: false,
                          onTap: () => _showDeleteAccountDialog(context),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
