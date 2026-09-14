import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'app_app_bar.dart';
import 'app_bottom_nav.dart';
import 'app_drawer.dart';

/// Responsive shell wrapper that provides BottomNav on mobile and NavigationRail on tablet/desktop.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/crop-recommendation')) return 1;
    if (location.startsWith('/disease-detection')) return 2;
    if (location.startsWith('/market') || location.startsWith('/price-prediction')) return 3;
    if (location.startsWith('/assistant')) return 4;
    return 0; // dashboard
  }

  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/crop-recommendation')) return 'Crop Recommendation';
    if (location.startsWith('/disease-detection')) return 'Plant Disease Detection';
    if (location.startsWith('/pest-detection')) return 'Pest Identification';
    if (location.startsWith('/weather')) return 'Weather & Advisory';
    if (location.startsWith('/market')) return 'Market Mandi Rates';
    if (location.startsWith('/price-prediction')) return 'Price Prediction';
    if (location.startsWith('/government-schemes')) return 'Government Schemes';
    if (location.startsWith('/assistant')) return 'AI Agriculture Assistant';
    if (location.startsWith('/profile')) return 'Farmer Profile';
    if (location.startsWith('/settings')) return 'Settings';
    return 'Farm Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopOrTablet = Responsive.isTablet(context) || Responsive.isDesktop(context);
    final selectedIndex = _calculateSelectedIndex(context);
    final currentPath = GoRouterState.of(context).uri.path;

    if (isDesktopOrTablet) {
      return Scaffold(
        appBar: AppAppBar(
          title: _getPageTitle(context),
          showLogo: true,
          showBackButton: false,
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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppColors.primary),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.eco_outlined),
                  selectedIcon: Icon(Icons.eco, color: AppColors.primary),
                  label: Text('Crops'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.health_and_safety_outlined),
                  selectedIcon: Icon(Icons.health_and_safety, color: AppColors.primary),
                  label: Text('Health'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront, color: AppColors.primary),
                  label: Text('Market'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.forum_outlined),
                  selectedIcon: Icon(Icons.forum, color: AppColors.primary),
                  label: Text('Assistant'),
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
        title: _getPageTitle(context),
        showLogo: selectedIndex == 0,
        showBackButton: selectedIndex != 0,
      ),
      drawer: AppDrawer(currentPath: currentPath),
      body: child,
      bottomNavigationBar: AppBottomNav(currentIndex: selectedIndex),
    );
  }
}
