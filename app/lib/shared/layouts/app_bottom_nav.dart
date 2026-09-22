import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../core/localization/app_translations.dart';

/// Polished mobile bottom navigation bar with icons and reactive vernacular text labels.
class AppBottomNav extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: ref.tr('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.eco_outlined),
            selectedIcon: const Icon(Icons.eco, color: AppColors.primary),
            label: ref.tr('nav_crops'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.health_and_safety_outlined),
            selectedIcon: const Icon(Icons.health_and_safety, color: AppColors.primary),
            label: ref.tr('nav_health'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront, color: AppColors.primary),
            label: ref.tr('nav_market'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.forum_outlined),
            selectedIcon: const Icon(Icons.forum, color: AppColors.primary),
            label: ref.tr('nav_assistant'),
          ),
        ],
      ),
    );
  }
}
