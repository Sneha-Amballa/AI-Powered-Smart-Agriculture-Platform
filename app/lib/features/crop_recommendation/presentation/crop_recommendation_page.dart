import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_state.dart';
import 'providers/crop_history_provider.dart';
import 'providers/crop_history_state.dart';
import 'providers/crop_recommendation_provider.dart';
import 'providers/crop_recommendation_state.dart';
import 'widgets/crop_history_detail_sheet.dart';
import 'widgets/crop_history_view.dart';
import 'widgets/environmental_conditions_card.dart';
import 'widgets/ready_recommendation_card.dart';
import 'widgets/recommendation_result_card.dart';
import 'widgets/soil_information_card.dart';

/// Production-quality Crops Hub & Zero Re-entry Recommendation Screen.
///
/// Automatically hydrates farmer profile data (NPK, pH, Soil Type, Location, Landholding).
/// Implements transparent climate separation, progressive disclosure review,
/// immutable audit-trailed Crop History, and responsible AI trust messaging.
class CropRecommendationPage extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const CropRecommendationPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<CropRecommendationPage> createState() => _CropRecommendationPageState();
}

class _CropRecommendationPageState extends ConsumerState<CropRecommendationPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatShortDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final recState = ref.watch(cropRecommendationNotifierProvider);
    final historyState = ref.watch(cropHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Crops Hub Segmented Tab Selector
                  _buildCropsHubHeader(historyState.items.length),
                  AppSpacing.gapV16,

                  if (_tabController.index == 0) ...[
                    // Tab 0: Zero Re-entry Crop Recommendation Flow
                    _buildRecommendationTab(context, recState, historyState),
                  ] else ...[
                    // Tab 1: Crop History Audit Trail
                    CropHistoryView(
                      onGetRecommendation: () {
                        _tabController.animateTo(0);
                      },
                    ),
                  ],
                  AppSpacing.gapV32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCropsHubHeader(int historyCount) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              index: 0,
              label: 'Recommendation',
              icon: Icons.psychology_outlined,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              index: 1,
              label: 'Crop History',
              icon: Icons.history_rounded,
              badgeCount: historyCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String label,
    required IconData icon,
    int? badgeCount,
  }) {
    final isSelected = _tabController.index == index;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () {
          _tabController.animateTo(index);
        },
        borderRadius: AppRadius.radiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.radiusSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              AppSpacing.gapH6,
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
              if (badgeCount != null && badgeCount > 0) ...[
                AppSpacing.gapH6,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.sage.withValues(alpha: 0.5),
                    borderRadius: AppRadius.radiusPill,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationTab(
    BuildContext context,
    CropRecommendationState recState,
    CropHistoryState historyState,
  ) {
    final hasLatest = historyState.latestItem != null;
    final latest = historyState.latestItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Recent Recommendation Banner (Requirement 26)
        if (hasLatest && latest != null && recState.result == null) ...[
          _buildRecentRecommendationBanner(context, latest),
          AppSpacing.gapV14,
        ],

        // Farm Profile Pre-fill Header (Requirement 3 & 18)
        _buildFarmProfileStatusBanner(recState),
        AppSpacing.gapV14,

        // Premium Soil Information Section (Requirement 4 & 5)
        SoilInformationCard(
          state: recState,
          onSaveSoil: ({
            required double n,
            required double p,
            required double k,
            required double ph,
            String? soilType,
            required bool updateProfile,
          }) {
            ref.read(cropRecommendationNotifierProvider.notifier).updateSoilInputs(
                  n: n,
                  p: p,
                  k: k,
                  ph: ph,
                  soilType: soilType,
                  updateProfile: updateProfile,
                );
          },
          onNavigateToProfile: () {
            context.go('/profile');
          },
        ),
        AppSpacing.gapV14,

        // Dynamic Environmental & Climate Conditions Section (Requirement 6)
        EnvironmentalConditionsCard(
          state: recState,
          onSaveWeather: ({
            required double temperature,
            required double humidity,
            required double rainfall,
          }) {
            ref.read(cropRecommendationNotifierProvider.notifier).setManualWeather(
                  temperature: temperature,
                  humidity: humidity,
                  rainfall: rainfall,
                );
          },
        ),
        AppSpacing.gapV16,

        // Review Before Recommending & Primary CTA (Requirement 7 & 8)
        ReadyRecommendationCard(
          state: recState,
          isLoading: recState.recommendationStatus == RecommendationProcessStatus.loading,
          onGetRecommendation: () {
            ref.read(cropRecommendationNotifierProvider.notifier).getRecommendation();
          },
        ),
        AppSpacing.gapV20,

        // Recommendation Result or Error Banner
        if (recState.recommendationStatus == RecommendationProcessStatus.loading) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ] else if (recState.errorMessage != null) ...[
          AppErrorState(
            title: 'Recommendation Unavailable',
            message: recState.errorMessage!,
            retryLabel: 'Retry',
            onRetry: () {
              ref.read(cropRecommendationNotifierProvider.notifier).getRecommendation();
            },
          ),
        ] else if (recState.result != null) ...[
          RecommendationResultCard(
            result: recState.result!,
            state: recState,
            onViewHistory: () {
              _tabController.animateTo(1);
            },
            onRunAgain: () {
              ref.read(cropRecommendationNotifierProvider.notifier).resetResult();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFarmProfileStatusBanner(CropRecommendationState recState) {
    final location = [recState.village, recState.district, recState.state]
        .where((s) => s.isNotEmpty)
        .join(', ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.35),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Icon(Icons.person_pin_outlined, color: AppColors.primary, size: 18),
          ),
          AppSpacing.gapH10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Farm Parameters Loaded',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV2,
                Text(
                  location.isNotEmpty
                      ? '$location • ${recState.landArea > 0 ? "${recState.landArea.toStringAsFixed(1)} ${recState.areaUnit}" : "Land details ready"}'
                      : 'Saved farm parameters loaded automatically.',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecommendationBanner(
    BuildContext context,
    dynamic latest,
  ) {
    return AppCard(
      backgroundColor: AppColors.sage.withValues(alpha: 0.2),
      borderColor: AppColors.primaryLight.withValues(alpha: 0.4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RECENT RECOMMENDATION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.textTertiary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      latest.recommendedCrop.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    AppSpacing.gapH8,
                    Text(
                      '• ${_formatShortDate(latest.createdAt)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => CropHistoryDetailSheet.show(context, latest),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              'View Details',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
