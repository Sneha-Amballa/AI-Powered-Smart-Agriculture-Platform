import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../widgets/app_logo.dart';

/// Reusable application AppBar with brand title, actions, and notification badge.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBackButton;
  final bool showNotification;
  final bool showProfile;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const AppAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBackButton = true,
    this.showNotification = true,
    this.showProfile = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.surface,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: onBackPressed ??
                  () {
                    if (canPop) {
                      context.pop();
                    } else {
                      context.go('/dashboard');
                    }
                  },
            )
          : null,
      title: showLogo
          ? const AppLogo(size: 28)
          : Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
      actions: [
        if (actions != null) ...actions!,
        if (showNotification)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textPrimary),
                tooltip: 'Notifications',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Farm advisory & weather alerts are active'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        if (showProfile)
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.sage,
              child: Icon(Icons.person, size: 18, color: AppColors.primaryDark),
            ),
            tooltip: 'Farmer Profile',
            onPressed: () => context.push('/profile'),
          ),
        AppSpacing.gapH8,
      ],
    );
  }
}
