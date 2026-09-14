import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/dashboard_data.dart';

/// Concise market snapshot comparing modal rates with nearby mandis for the farmer's crop.
class MarketSnapshotCard extends StatelessWidget {
  final MarketPriceSummary market;

  const MarketSnapshotCard({
    super.key,
    required this.market,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.go('/market'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.storefront_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        'Market Snapshot • ${market.localMandiName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusPill,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'APMC LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV14,

          // Primary Price Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR CROP: ${market.cropName.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      AppSpacing.gapV4,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                market.formattedCurrentPrice,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: market.isUp ? AppColors.successLight : AppColors.errorLight,
                    borderRadius: AppRadius.radiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        market.isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: 13,
                        color: market.isUp ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        market.changeFormatted,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: market.isUp ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV12,

          // Nearby Best Price Callout (High Decision-Support Value)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6), // Soft lavender tint
              borderRadius: AppRadius.radiusSm,
              border: Border.all(
                color: const Color(0xFFD1C4E9),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  size: 18,
                  color: Color(0xFF4527A0),
                ),
                AppSpacing.gapH8,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF311B92),
                      ),
                      children: [
                        const TextSpan(text: 'Nearby Best Rate: '),
                        TextSpan(
                          text: '${market.formattedBestPrice}/qtl ',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: 'at ${market.nearbyMandiName}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapV10,

          // Footer link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.go('/market'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Text(
                'View All Mandi Rates',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              label: const Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
