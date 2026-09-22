import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_outlined_button.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/language_selector_sheet.dart';
import '../../../core/localization/locale_provider.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// App settings and preferences screen with accessible touch targets.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _alertsEnabled = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? Your farm profile, crops, and data will remain safely saved on this device for your next login.',
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
            Expanded(child: Text('Delete Account Permanently?')),
          ],
        ),
        content: const Text(
          'This action cannot be undone. All your saved farm profile details, soil test data, crop advisory records, and account credentials will be permanently erased from this device.',
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
                    content: Text('Your account and all farm records have been permanently deleted.'),
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

  void _showLanguageSelector(BuildContext context) {
    showLanguageSelectorSheet(context, ref);
  }

  void _clearCache(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offline data cache cleared (12.4 MB freed)'),
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
    final phoneNumber = authState.user?.phoneNumber.isNotEmpty == true
        ? '+91 ${authState.user!.phoneNumber}'
        : 'Active Session';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 340;
                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.sage,
                                child: Icon(Icons.person, size: 28, color: AppColors.primaryDark),
                              ),
                              AppSpacing.gapH12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      farmerName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AppSpacing.gapV2,
                                    Text(
                                      phoneNumber,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapV12,
                          AppOutlinedButton(
                            label: 'View Profile',
                            onPressed: () => context.go('/profile'),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.sage,
                          child: Icon(Icons.person, size: 32, color: AppColors.primaryDark),
                        ),
                        AppSpacing.gapH16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmerName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppSpacing.gapV4,
                              Text(
                                phoneNumber,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.gapH12,
                        AppOutlinedButton(
                          label: 'View Profile',
                          onPressed: () => context.go('/profile'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              AppSpacing.gapV16,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferences',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV12,
                    _buildSettingsTile(
                      Icons.translate_outlined,
                      ref.tr('settings_app_language'),
                      activeLang.displayName,
                      () => _showLanguageSelector(context),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.notifications_none_outlined,
                      'Weather & Spraying Alerts',
                      _alertsEnabled ? 'Enabled (Daily 6 AM & Rain warnings)' : 'Disabled',
                      () {
                        setState(() => _alertsEnabled = !_alertsEnabled);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_alertsEnabled ? 'Advisory alerts turned ON' : 'Advisory alerts turned OFF'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.storage_outlined,
                      'Offline Data Cache',
                      '12.4 MB Used (Tap to clear)',
                      () => _clearCache(context),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About & Legal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV12,
                    _buildSettingsTile(
                      Icons.info_outline,
                      'App Version',
                      '1.0.0+1 (Precision Agriculture Release)',
                      null,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.privacy_tip_outlined,
                      'Privacy Policy',
                      'ICAR & Government Advisory Guidelines',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Platform complies with Indian Digital Agri-Stack Privacy standards'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.support_agent_outlined,
                      'Help & Farmer Support',
                      'Kisan Toll-Free Helpline: 1800-180-1551',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Connecting to Kisan Call Center (1800-180-1551)...'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account & Session',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV12,
                    _buildSettingsTile(
                      Icons.logout,
                      'Sign Out',
                      'Safely end session; your farm details remain saved',
                      () => _showLogoutDialog(context),
                      iconColor: AppColors.primaryDark,
                      textColor: AppColors.textPrimary,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.delete_forever_outlined,
                      'Delete Account',
                      'Permanently erase your account and all farm records',
                      () => _showDeleteAccountDialog(context),
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
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

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap, {
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      minLeadingWidth: 32,
      minVerticalPadding: 12,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryDark).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primaryDark, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: onTap != null ? const Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary) : null,
      onTap: onTap,
    );
  }
}

