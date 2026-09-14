import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

/// Polished mobile bottom navigation bar with icons and text labels.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  static const List<String> routes = [
    '/dashboard',
    '/crop-recommendation',
    '/disease-detection',
    '/market',
    '/assistant',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex.clamp(0, 4),
        onDestinationSelected: (index) {
          if (index != currentIndex && index < routes.length) {
            context.go(routes[index]);
          }
        },
        backgroundColor: AppColors.surface,
        elevation: 0,
        indicatorColor: AppColors.sage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco, color: AppColors.primary),
            label: 'Crops',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety, color: AppColors.primary),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.primary),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum, color: AppColors.primary),
            label: 'Assistant',
          ),
        ],
      ),
    );
  }
}
