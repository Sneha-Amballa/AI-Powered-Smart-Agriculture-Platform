import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';

/// Mobile-first Price Trend Forecasting screen designed for farmer accessibility.
class PricePredictionScreen extends StatefulWidget {
  const PricePredictionScreen({super.key});

  @override
  State<PricePredictionScreen> createState() => _PricePredictionScreenState();
}

class _PricePredictionScreenState extends State<PricePredictionScreen> {
  int _selectedCropIndex = 0;
  final List<String> _crops = ['Paddy (Rice)', 'Cotton', 'Maize', 'Chilli'];

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6A1B9A).withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.market,
                        size: 52,
                        primaryColor: Color(0xFF6A1B9A),
                        secondaryColor: Color(0xFFEDE7F6),
                      ),
                    ),
                    AppSpacing.gapV16,
                    const Text(
                      'Crop Price Forecasting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    AppSpacing.gapV6,
                    const AppBadge(
                      label: 'APMC MANDI • ML FORECAST',
                      variant: BadgeVariant.info,
                    ),
                    AppSpacing.gapV10,
                    const Text(
                      'Analyze historical mandi arrivals and price cycles to determine the optimal time to sell your harvest.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Commodity Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _crops.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(_crops[index]),
                        selected: _selectedCropIndex == index,
                        selectedColor: const Color(0xFF6A1B9A),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedCropIndex == index ? Colors.white : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.surface,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCropIndex = index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapV16,

              // Projected Horizons Cards
              const Text(
                'Projected Price Horizons (APMC Mandi Model)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              AppSpacing.gapV10,

              _buildForecastHorizonCard(
                '7 Days Ahead',
                '₹2,380 / Qtl',
                '+₹80 (+3.5%)',
                true,
                'Hold Advice: Prices trending upwards due to lower local mandi arrivals.',
                const Color(0xFFE8F5E9),
                AppColors.success,
              ),
              AppSpacing.gapV10,

              _buildForecastHorizonCard(
                '15 Days Ahead',
                '₹2,440 / Qtl',
                '+₹140 (+6.1%)',
                true,
                'Peak Window: Expected optimal sell window for highest profit margin.',
                const Color(0xFFEDE7F6),
                const Color(0xFF6A1B9A),
              ),
              AppSpacing.gapV10,

              _buildForecastHorizonCard(
                '30 Days Ahead',
                '₹2,390 / Qtl',
                '+₹90 (+3.9%)',
                true,
                'Stable Plateau: Wholesale procurement rates stabilize across regional hubs.',
                AppColors.background,
                AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastHorizonCard(
    String horizon,
    String price,
    String trend,
    bool isUp,
    String advice,
    Color bgColor,
    Color accentColor,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: accentColor),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        horizon,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isUp ? AppColors.successLight : AppColors.errorLight,
                  borderRadius: AppRadius.radiusPill,
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isUp ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV10,
          Text(
            price,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV4,
          Text(
            advice,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
