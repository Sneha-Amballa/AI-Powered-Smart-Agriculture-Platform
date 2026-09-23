import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../authentication/domain/models/farmer_profile_model.dart';
import '../../../authentication/domain/models/user_model.dart';

/// Clean, minimal personalized farmer greeting header.
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

  String _getFarmerName() {
    if (user != null && user!.fullName.trim().isNotEmpty) {
      return user!.fullName.trim().split(' ').first;
    }
    return 'Farmer';
  }

  String _getLocationSummary() {
    if (profile != null && profile!.location.district.isNotEmpty) {
      final loc = profile!.location;
      final area = profile!.farmDetails.landArea;
      final unit = profile!.farmDetails.areaUnit;
      if (area > 0) {
        return '${loc.district} • $area $unit';
      }
      return '${loc.district}, ${loc.state}';
    }
    return 'Kurnool • 5.2 Acres';
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Farmer Avatar
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryDark,
                  size: 24,
                ),
              ),
            ),
            AppSpacing.gapH12,

            // Greeting + Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapV2,
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapH8,

            // Season Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.radiusPill,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
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

        if (!isProfileComplete) ...[
          AppSpacing.gapV12,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: const Color(0xFFFFD54F), width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFFF57F17),
                  size: 22,
                ),
                AppSpacing.gapH10,
                const Expanded(
                  child: Text(
                    'Complete farm details for precision agronomy.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/profile-setup'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: const Color(0xFFE65100),
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
