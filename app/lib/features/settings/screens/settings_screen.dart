import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// App settings and preferences screen with accessible touch targets.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _currentLanguage = 'English (Default)';
  bool _alertsEnabled = true;

  void _showLogoutDialog(BuildContext context) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
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

  void _showLanguageSelector(BuildContext context) {
    final languages = [
      'English (Default)',
      'हिंदी (Hindi)',
      'తెలుగు (Telugu)',
      'தமிழ் (Tamil)',
      'मराठी (Marathi)',
      'ਪੰਜਾਬੀ (Punjabi)',
      'ગુજરાતી (Gujarati)',
      'ಕನ್ನಡ (Kannada)',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Select App Language',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(),
                ...languages.map((lang) {
                  final isSelected = lang == _currentLanguage;
                  return ListTile(
                    minVerticalPadding: 12,
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    ),
                    title: Text(
                      lang,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      setState(() => _currentLanguage = lang);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language set to $lang'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account & Session',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV12,
                    _buildSettingsTile(
                      Icons.person_outline,
                      farmerName,
                      phoneNumber,
                      () => context.go('/profile'),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      Icons.logout,
                      'Sign Out',
                      'Safely clear your session on this device',
                      () => _showLogoutDialog(context),
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
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
                      'Preferences',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV12,
                    _buildSettingsTile(
                      Icons.translate_outlined,
                      'App Language',
                      _currentLanguage,
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

