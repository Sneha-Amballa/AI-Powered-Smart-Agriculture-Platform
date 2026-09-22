import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../core/utils/responsive.dart';
import 'app_app_bar.dart';
import 'app_bottom_nav.dart';
import 'app_drawer.dart';

/// Responsive shell wrapper that provides BottomNav on mobile and NavigationRail on tablet/desktop,
/// fully localized with reactive translations for title and navigation destinations.
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/crop-recommendation') || location.startsWith('/crop-history')) return 1;
    if (location.startsWith('/disease-detection')) return 2;
    if (location.startsWith('/market') || location.startsWith('/price-prediction')) return 3;
    if (location.startsWith('/assistant')) return 4;
    return 0; // dashboard
  }

  String _getPageTitle(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/crop-history')) return ref.tr('title_crop_history');
    if (location.startsWith('/crop-recommendation')) return ref.tr('title_crop_recommendation');
    if (location.startsWith('/disease-detection')) return ref.tr('title_disease_detection');
    if (location.startsWith('/pest-detection')) return ref.tr('title_pest_detection');
    if (location.startsWith('/weather')) return ref.tr('title_weather');
    if (location.startsWith('/market')) return ref.tr('title_market');
    if (location.startsWith('/price-prediction')) return ref.tr('title_price_prediction');
    if (location.startsWith('/government-schemes')) return ref.tr('title_schemes');
    if (location.startsWith('/assistant')) return ref.tr('title_assistant');
    if (location.startsWith('/profile')) return ref.tr('title_profile');
    if (location.startsWith('/settings')) return ref.tr('title_settings');
    return ref.tr('title_dashboard');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktopOrTablet = Responsive.isTablet(context) || Responsive.isDesktop(context);
    final selectedIndex = _calculateSelectedIndex(context);
    final currentPath = GoRouterState.of(context).uri.path;

    final isDashboard = selectedIndex == 0;
    final isProfileScreen = currentPath.startsWith('/profile');
    final shouldShowProfileInAppBar = !isDashboard && !isProfileScreen;

    if (isDesktopOrTablet) {
      return Scaffold(
        appBar: AppAppBar(
          title: _getPageTitle(context, ref),
          showLogo: true,
          showBackButton: false,
          showProfile: shouldShowProfileInAppBar,
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                if (index < AppBottomNav.routes.length) {
                  context.go(AppBottomNav.routes[index]);
                }
              },
              labelType: NavigationRailLabelType.all,
              leading: const SizedBox(height: 12),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home, color: AppColors.primary),
                  label: Text(ref.tr('nav_home')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.eco_outlined),
                  selectedIcon: const Icon(Icons.eco, color: AppColors.primary),
                  label: Text(ref.tr('nav_crops')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.health_and_safety_outlined),
                  selectedIcon: const Icon(Icons.health_and_safety, color: AppColors.primary),
                  label: Text(ref.tr('nav_health')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.storefront_outlined),
                  selectedIcon: const Icon(Icons.storefront, color: AppColors.primary),
                  label: Text(ref.tr('nav_market')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.forum_outlined),
                  selectedIcon: const Icon(Icons.forum, color: AppColors.primary),
                  label: Text(ref.tr('nav_assistant')),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: AppColors.cardBorder),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      appBar: AppAppBar(
        title: _getPageTitle(context, ref),
        showLogo: selectedIndex == 0,
        showBackButton: selectedIndex != 0,
        showProfile: shouldShowProfileInAppBar,
      ),
      drawer: AppDrawer(currentPath: currentPath),
      body: child,
      bottomNavigationBar: AppBottomNav(currentIndex: selectedIndex),
    );
  }
}
