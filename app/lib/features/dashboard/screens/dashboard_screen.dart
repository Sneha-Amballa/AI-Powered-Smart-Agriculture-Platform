import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import '../presentation/providers/dashboard_provider.dart';
import '../presentation/widgets/assistant_entry_card.dart';
import '../presentation/widgets/crop_recommendation_card.dart';
import '../presentation/widgets/dashboard_error_banner.dart';
import '../presentation/widgets/dashboard_header.dart';
import '../presentation/widgets/dashboard_skeleton.dart';
import '../presentation/widgets/disease_detection_banner.dart';
import '../presentation/widgets/farm_advisory_card.dart';
import '../presentation/widgets/government_schemes_card.dart';
import '../presentation/widgets/market_snapshot_card.dart';
import '../presentation/widgets/quick_actions_grid.dart';
import '../presentation/widgets/recent_activity_section.dart';
import '../presentation/widgets/weather_impact_card.dart';

/// Production Farmer Dashboard: The central agronomic decision-support home screen.
/// Answers the core questions:
/// 1. "How is my farm today?"
/// 2. "What should I do today?"
/// 3. "What should I watch?"
/// 4. "Where can I get help?"
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final dashboardState = ref.watch(dashboardNotifierProvider);

    // If no data loaded yet, show skeleton or critical error
    if (dashboardState.data == null) {
      if (dashboardState.hasError) {
        return _buildCriticalErrorView(context, ref, dashboardState.errorMessage);
      }
      return const DashboardSkeleton();
    }

    final data = dashboardState.data!;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Personalized Farmer Welcome & Profile Header
                DashboardHeader(
                  user: authState.user,
                  profile: authState.profile,
                  isProfileComplete: data.isProfileComplete,
                ),

                // Non-blocking error banner on background refresh failure
                if (dashboardState.errorMessage != null) ...[
                  AppSpacing.gapV14,
                  DashboardErrorBanner(
                    message: dashboardState.errorMessage!,
                    onRetry: () =>
                        ref.read(dashboardNotifierProvider.notifier).retry(),
                  ),
                ],
                AppSpacing.gapV20,

                // 2. Today's Farm Advisory (The Visual Centerpiece)
                FarmAdvisoryCard(advisory: data.advisory),
                AppSpacing.gapV20,

                // 3 & 4. Weather + Farming Impact & Crop Recommendation Summary
                // Responsive side-by-side on tablet/desktop, stacked on mobile
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 640;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: WeatherImpactCard(weather: data.weather),
                          ),
                          AppSpacing.gapH14,
                          Expanded(
                            child: CropRecommendationSummaryCard(crop: data.crop),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        WeatherImpactCard(weather: data.weather),
                        AppSpacing.gapV14,
                        CropRecommendationSummaryCard(crop: data.crop),
                      ],
                    );
                  },
                ),
                AppSpacing.gapV20,

                // 5. Market Snapshot for Farmer's Primary Crop
                MarketSnapshotCard(market: data.market),
                AppSpacing.gapV20,

                // 6. Quick Action Navigation Grid
                const _SectionTitle(title: 'Quick Farm Tools'),
                AppSpacing.gapV10,
                const QuickActionsGrid(),
                AppSpacing.gapV20,

                // 7. Plant Disease Detection Spotlight
                const DiseaseDetectionBanner(),
                AppSpacing.gapV20,

                // 8. Government Support & Scheme Eligibility Preview
                GovernmentSchemesCard(schemes: data.schemes),
                AppSpacing.gapV20,

                // 9. Recent Agricultural Activity Timeline
                RecentActivitySection(activities: data.recentActivity),
                AppSpacing.gapV20,

                // 10. AI Agriculture Assistant Direct Access Banner
                const AssistantEntryCard(),
                AppSpacing.gapV24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalErrorView(
    BuildContext context,
    WidgetRef ref,
    String? error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            AppSpacing.gapV16,
            const Text(
              'Unable to Load Farm Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV6,
            Text(
              error ?? 'Check your network connection and try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            AppSpacing.gapV20,
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(dashboardNotifierProvider.notifier).retry(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }
}
