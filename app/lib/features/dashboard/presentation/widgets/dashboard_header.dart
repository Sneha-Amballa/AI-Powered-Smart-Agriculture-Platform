import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../authentication/domain/models/farmer_profile_model.dart';
import '../../../authentication/domain/models/user_model.dart';

/// Personalized farmer greeting header with dynamic profile status and incomplete warning.
class DashboardHeader extends ConsumerWidget {
  final UserModel? user;
  final FarmerProfile? profile;
  final bool isProfileComplete;

  const DashboardHeader({
    super.key,
    required this.user,
    required this.profile,
    required this.isProfileComplete,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getFarmerName() {
    if (user != null && user!.fullName.trim().isNotEmpty) {
      final first = user!.fullName.trim().split(' ').first;
      return first;
    }
    return 'Farmer';
  }

  String _getLocationSummary() {
    if (profile != null && profile!.location.district.isNotEmpty) {
      final loc = profile!.location;
      final area = profile!.farmDetails.landArea;
      final unit = profile!.farmDetails.areaUnit;
      if (area > 0) {
        return '${loc.district} District • $area $unit';
      }
      return '${loc.district}, ${loc.state}';
    }
    return 'Kurnool District • Kharif Season 2026';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLang = ref.watch(localeNotifierProvider);
    final greeting = activeLang.greeting;
    final name = _getFarmerName();
    final locationText = _getLocationSummary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Row: Greeting & Quick Profile Access
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Farmer Avatar (Accessible touch target to /profile)
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryDark,
                  size: 26,
                ),
              ),
            ),
            AppSpacing.gapH12,

            // Greeting + Context
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapV2,
                  Text(
                    locationText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH8,

            // Active Farm Season Indicator (Replaces duplicate profile button)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusPill,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Kharif 2026',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Incomplete Profile Banner (Only shown if farmer profile needs completion)
        if (!isProfileComplete) ...[
          AppSpacing.gapV14,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), // Warm amber background
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: const Color(0xFFFFD54F), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFFF57F17),
                  size: 26,
                ),
                AppSpacing.gapH12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Complete your farm profile',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Add land area & soil details for laboratory-grade advice.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF5D4037),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapH8,
                ElevatedButton(
                  onPressed: () => context.go('/profile-setup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: const Size(0, 34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusSm,
                    ),
                  ),
                  child: const Text(
                    'Setup',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
