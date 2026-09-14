import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

/// Mobile-first APMC Mandi Market Prices screen designed for farmer accessibility.
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All Crops', 'Cereals', 'Cotton & Cash', 'Pulses'];

  final List<_MandiRate> _allRates = const [
    _MandiRate('Paddy (Dhan)', '₹2,300', '/Qtl', '+₹80', true, 'Kurnool APMC', Icons.grass, 1),
    _MandiRate('Cotton (Kapas)', '₹7,150', '/Qtl', '-₹20', false, 'Kurnool APMC', Icons.eco, 2),
    _MandiRate('Maize (Makka)', '₹2,100', '/Qtl', '+₹35', true, 'Nandyal Mandi', Icons.grain, 1),
    _MandiRate('Chilli (Mirchi)', '₹14,500', '/Qtl', '+₹250', true, 'Guntur APMC', Icons.flare, 2),
    _MandiRate('Bengal Gram (Chana)', '₹5,600', '/Qtl', '+₹40', true, 'Adoni Mandi', Icons.circle_outlined, 3),
    _MandiRate('Groundnut (Moongphali)', '₹5,850', '/Qtl', '+₹60', true, 'Kurnool APMC', Icons.spa, 2),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRates = _selectedCategory == 0
        ? _allRates
        : _allRates.where((r) => r.categoryIndex == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Summary Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.market,
                        size: 42,
                        primaryColor: Color(0xFF4527A0),
                        secondaryColor: Color(0xFFEDE7F6),
                      ),
                    ),
                    AppSpacing.gapH14,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'APMC Mandi Rates',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          AppSpacing.gapV2,
                          Text(
                            'Kurnool District • Daily Agmarknet Rates',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const AppBadge(label: 'TODAY', variant: BadgeVariant.success),
                  ],
                ),
              ),
              AppSpacing.gapV14,

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _categories.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(_categories[index]),
                        selected: _selectedCategory == index,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedCategory == index ? Colors.white : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.surface,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapV14,

              // Mandi Rate List Cards
              for (final rate in filteredRates) ...[
                _buildRateCard(rate),
                AppSpacing.gapV10,
              ],
              AppSpacing.gapV14,

              // Navigation to Price Prediction
              AppCard(
                backgroundColor: const Color(0xFFEDE7F6),
                borderColor: const Color(0xFF4527A0).withValues(alpha: 0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.timeline_outlined, color: Color(0xFF4527A0), size: 22),
                        AppSpacing.gapH8,
                        Expanded(
                          child: Text(
                            'Price Forecast Machine Learning',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4527A0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV6,
                    const Text(
                      'Predict upcoming 7 to 30 day commodity price trends to decide whether to sell today or hold produce.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                    ),
                    AppSpacing.gapV14,
                    AppButton(
                      label: 'Open Price Prediction Tool',
                      leadingIcon: Icons.trending_up,
                      backgroundColor: const Color(0xFF4527A0),
                      foregroundColor: Colors.white,
                      onPressed: () => context.go('/price-prediction'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRateCard(_MandiRate rate) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.5),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(rate.icon, size: 22, color: AppColors.primary),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rate.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV2,
                Text(
                  rate.mandi,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    rate.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    rate.unit,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              AppSpacing.gapV2,
              Row(
                children: [
                  Icon(
                    rate.isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: rate.isUp ? AppColors.success : AppColors.error,
                  ),
                  AppSpacing.gapH2,
                  Text(
                    rate.change,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: rate.isUp ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MandiRate {
  final String name;
  final String price;
  final String unit;
  final String change;
  final bool isUp;
  final String mandi;
  final IconData icon;
  final int categoryIndex;

  const _MandiRate(
    this.name,
    this.price,
    this.unit,
    this.change,
    this.isUp,
    this.mandi,
    this.icon,
    this.categoryIndex,
  );
}
