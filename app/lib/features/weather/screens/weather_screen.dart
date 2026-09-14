import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';

/// Mobile-first Weather & Agromet Advisory screen designed for farmer accessibility.
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
              // Live Current Weather Card
              AppCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 18, color: AppColors.primary),
                              AppSpacing.gapH6,
                              Flexible(
                                child: Text(
                                  'Kurnool, AP',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        AppBadge(label: 'LIVE WEATHER', variant: BadgeVariant.success),
                      ],
                    ),
                    AppSpacing.gapV16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '28.5°C',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              AppSpacing.gapV2,
                              Text(
                                'Partly Cloudy • Feels like 30°C',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5FE),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0277BD).withValues(alpha: 0.2)),
                          ),
                          alignment: Alignment.center,
                          child: const AgriIllustration(
                            type: AgriIllustrationType.weather,
                            size: 42,
                            primaryColor: Color(0xFF0277BD),
                            secondaryColor: Color(0xFFE1F5FE),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV16,
                    // Metrics Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Row(
                        children: const [
                          Expanded(child: _WeatherMetric(Icons.water_drop_outlined, 'Humidity', '65%')),
                          Expanded(child: _WeatherMetric(Icons.air, 'Wind', '12 km/h')),
                          Expanded(child: _WeatherMetric(Icons.umbrella_outlined, 'Rain', '15%')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Agromet Advisory Banner (Spray & Irrigation advice)
              AppCard(
                backgroundColor: AppColors.sage.withValues(alpha: 0.4),
                borderColor: AppColors.primaryLight.withValues(alpha: 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.tips_and_updates, color: AppColors.primary, size: 20),
                        AppSpacing.gapH8,
                        Expanded(
                          child: Text(
                            'Farming Advisory for Today',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV8,
                    const Text(
                      '• Safe window for fertilizer broadcasting and pesticide spray until 11:30 AM.\n'
                      '• Wind speed is calm (<15 km/h). No heavy rain anticipated for the next 48 hours.\n'
                      '• Morning drip irrigation recommended for standing vegetable crops.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // 7-Day Forecast Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '7-Day Rain & Temperature Forecast',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV12,
                    _buildForecastRow('Today', 'Partly Cloudy', '29° / 22°', '15% rain', Icons.cloud_outlined),
                    const Divider(height: 1),
                    _buildForecastRow('Tomorrow', 'Sunny & Clear', '31° / 23°', '5% rain', Icons.wb_sunny_outlined),
                    const Divider(height: 1),
                    _buildForecastRow('Wednesday', 'Light Showers', '27° / 21°', '60% rain', Icons.grain_outlined),
                    const Divider(height: 1),
                    _buildForecastRow('Thursday', 'Overcast Sky', '28° / 22°', '35% rain', Icons.cloud_queue_outlined),
                    const Divider(height: 1),
                    _buildForecastRow('Friday', 'Clear Sunshine', '30° / 23°', '10% rain', Icons.wb_sunny_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastRow(String day, String condition, String temp, String rain, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          AppSpacing.gapH10,
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(
                  condition,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              temp,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5FE),
              borderRadius: AppRadius.radiusPill,
            ),
            child: Text(
              rain,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0277BD)),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherMetric(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0277BD)),
        AppSpacing.gapV4,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
