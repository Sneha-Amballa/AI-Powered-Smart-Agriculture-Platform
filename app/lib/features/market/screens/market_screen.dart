import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/farmer_components.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

class _MandiRateItem {
  final String crop;
  final String variety;
  final int currentPrice;
  final int change;
  final bool isUp;
  final String localMandi;
  final String nearbyMandi;
  final int nearbyPrice;

  const _MandiRateItem({
    required this.crop,
    required this.variety,
    required this.currentPrice,
    required this.change,
    required this.isUp,
    required this.localMandi,
    required this.nearbyMandi,
    required this.nearbyPrice,
  });
}

const List<_MandiRateItem> _sampleMandiRates = [
  _MandiRateItem(
    crop: 'Cotton (Kapas)',
    variety: 'Medium Staple',
    currentPrice: 7250,
    change: 150,
    isUp: true,
    localMandi: 'Rajkot APMC',
    nearbyMandi: 'Gondal APMC',
    nearbyPrice: 7180,
  ),
  _MandiRateItem(
    crop: 'Wheat (Gehun)',
    variety: 'Sharbati',
    currentPrice: 2480,
    change: 30,
    isUp: true,
    localMandi: 'Rajkot APMC',
    nearbyMandi: 'Amreli APMC',
    nearbyPrice: 2450,
  ),
  _MandiRateItem(
    crop: 'Soyabean',
    variety: 'Yellow',
    currentPrice: 4620,
    change: -40,
    isUp: false,
    localMandi: 'Rajkot APMC',
    nearbyMandi: 'Junagadh APMC',
    nearbyPrice: 4650,
  ),
  _MandiRateItem(
    crop: 'Groundnut (Mungfali)',
    variety: 'Bold G-20',
    currentPrice: 6350,
    change: 90,
    isUp: true,
    localMandi: 'Rajkot APMC',
    nearbyMandi: 'Gondal APMC',
    nearbyPrice: 6300,
  ),
];

/// Farmer-first APMC Mandi Market Prices screen.
/// Implements "See → Understand → Act":
/// 1. What is happening? (Live modal prices per quintal)
/// 2. What does it mean for my farm? (Comparison across nearby mandis)
/// 3. What should I do? (Clear Hold vs Sell recommendation)
class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final cropVal = authState.profile?.farmDetails.primaryCrop;
    final primaryCrop = (cropVal != null && cropVal.isNotEmpty) ? cropVal : 'Cotton';

    const marketSummary =
        'Mandi rates today: Cotton Kapas is ₹7,250 per quintal, up ₹150. Recommendation: Good time to sell.';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title / Identifier
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Mandi Market Prices',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const FarmerVoiceButton(textToSpeak: marketSummary),
                    ],
                  ),
                  AppSpacing.gapV2,
                  const Text(
                    'Live APMC rates • Updated today at 11:30 AM',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapV16,

                  // 1. Centerpiece Selling Advice Card (See → Understand → Act)
                  _buildSellingAdviceCard(primaryCrop),
                  AppSpacing.gapV16,

                  // 2. Today's Crop Mandi Rates List
                  const FarmerSectionHeader(title: "Today's Mandi Rates"),
                  AppSpacing.gapV10,
                  ..._sampleMandiRates.map((item) => _buildRateCard(item)),
                  AppSpacing.gapV16,

                  // 3. Nearby Mandi Price Comparison
                  const FarmerSectionHeader(title: 'Nearby Mandi Comparison'),
                  AppSpacing.gapV10,
                  _buildNearbyComparisonCard(),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSellingAdviceCard(String crop) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: AppRadius.radiusPill,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primaryDark),
                    SizedBox(width: 4),
                    Text(
                      'GOOD TIME TO SELL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'YOUR CROP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFFB7E4C7),
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crop,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD8F3DC),
                      ),
                    ),
                    const Text(
                      '₹7,250 / quintal',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: AppRadius.radiusPill,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 3),
                    Text(
                      '+₹150 today',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Row(
              children: [
                Icon(Icons.tips_and_updates_rounded, size: 16, color: Color(0xFFFFD166)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selling Tip: Mills are buying heavily before rain. Selling today yields ₹180-250 higher margin per quintal than last week.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCard(_MandiRateItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.crop,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.variety} • ${item.localMandi}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.currentPrice}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 13,
                      color: item.isUp ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.isUp ? '+' : ''}₹${item.change.abs()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: item.isUp ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyComparisonCard() {
    return AppCard(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mandi Name',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              Text(
                'Kapas Rate',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1, color: AppColors.cardBorder),
          _buildComparisonRow('Rajkot APMC (Your Mandi)', '₹7,250', true),
          const SizedBox(height: 8),
          _buildComparisonRow('Gondal APMC (32 km)', '₹7,180', false),
          const SizedBox(height: 8),
          _buildComparisonRow('Amreli APMC (68 km)', '₹7,110', false),
          const SizedBox(height: 8),
          _buildComparisonRow('Morbi APMC (74 km)', '₹7,220', false),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String mandi, String price, bool isBest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (isBest) ...[
                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFA000)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  mandi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isBest ? FontWeight.w800 : FontWeight.w500,
                    color: isBest ? AppColors.primaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBest ? FontWeight.w800 : FontWeight.w600,
            color: isBest ? AppColors.primaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
