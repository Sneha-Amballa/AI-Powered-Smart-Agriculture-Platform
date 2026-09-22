import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/crop_history_provider.dart';
import 'crop_history_card.dart';

/// Complete Crop History view displaying previous recommendation audits
/// or an agricultural empty state with quick action to get a recommendation.
class CropHistoryView extends ConsumerWidget {
  final VoidCallback onGetRecommendation;

  const CropHistoryView({
    super.key,
    required this.onGetRecommendation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(cropHistoryNotifierProvider);

    if (historyState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (historyState.items.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crop History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Review your previous crop recommendations (${historyState.items.length}).',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 20),
              tooltip: 'Refresh History',
              onPressed: () => ref.read(cropHistoryNotifierProvider.notifier).loadHistory(),
            ),
          ],
        ),
        AppSpacing.gapV14,
        ...historyState.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CropHistoryCard(item: item),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_edu_outlined,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.gapV16,
            const Text(
              'Your crop history is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV6,
            const Text(
              'Your previous recommendations will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapV24,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: AppButton(
                label: 'Get Crop Recommendation',
                leadingIcon: Icons.psychology_outlined,
                onPressed: onGetRecommendation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
