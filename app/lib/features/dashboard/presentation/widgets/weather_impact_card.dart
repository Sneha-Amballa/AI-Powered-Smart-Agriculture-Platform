import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/dashboard_data.dart';

/// Weather summary card paired with contextual "Farming Impact" advisory.
class WeatherImpactCard extends StatelessWidget {
  final WeatherSummary weather;

  const WeatherImpactCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.go('/weather'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Location & Weather icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    AppSpacing.gapH4,
                    Flexible(
                      child: Text(
                        weather.locationName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.wb_sunny_rounded,
                size: 26,
                color: Color(0xFFFFA000), // Rich amber
              ),
            ],
          ),
          AppSpacing.gapV12,

          // Temperature & Condition
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${weather.temperature.toStringAsFixed(0)}°C',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -1.0,
                ),
              ),
              AppSpacing.gapH10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.condition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Feels like ${weather.feelsLike.toStringAsFixed(0)}°C',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,

          // Telemetry Row: Humidity, Rain, Wind
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusSm,
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTelemetryItem(
                  Icons.water_drop_outlined,
                  'Humidity',
                  '${weather.humidity}%',
                ),
                Container(height: 20, width: 1, color: AppColors.cardBorder),
                _buildTelemetryItem(
                  Icons.grain_rounded,
                  'Rain',
                  '${weather.rainProbability}%',
                ),
                Container(height: 20, width: 1, color: AppColors.cardBorder),
                _buildTelemetryItem(
                  Icons.air_rounded,
                  'Wind',
                  '${weather.windSpeed.toInt()} km/h',
                ),
              ],
            ),
          ),
          AppSpacing.gapV14,

          // FARMING IMPACT (Actionable Agronomic Value)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.35),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.tips_and_updates_rounded,
                  size: 18,
                  color: AppColors.primaryDark,
                ),
                AppSpacing.gapH8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Farming Impact',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        weather.farmingImpact,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ],
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
              onPressed: () => context.go('/weather'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Text(
                'View Forecast',
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

  Widget _buildTelemetryItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
}
