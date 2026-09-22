import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_outlined_button.dart';
import '../providers/crop_recommendation_state.dart';
import 'edit_weather_bottom_sheet.dart';

/// Dynamic Environmental & Climate Conditions Card.
///
/// Complies with strict agronomist zero-fabrication standards:
/// - If weather is available from live agromet API, shows values with "Source: Current weather".
/// - If weather is unavailable, displays "Current weather unavailable" and offers "Enter manually".
/// - When manually entered, clearly labels "Source: Manually entered".
/// - Dynamic parameters are never written back to permanent farm profile.
class EnvironmentalConditionsCard extends StatelessWidget {
  final CropRecommendationState state;
  final void Function({
    required double temperature,
    required double humidity,
    required double rainfall,
  }) onSaveWeather;

  const EnvironmentalConditionsCard({
    super.key,
    required this.state,
    required this.onSaveWeather,
  });

  void _openEditor(BuildContext context) {
    EditWeatherBottomSheet.show(
      context,
      initialTemperature: state.temperature,
      initialHumidity: state.humidity,
      initialRainfall: state.rainfall,
      onSave: onSaveWeather,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If climate data is populated (either live weather or manual)
    if (state.hasEnvironmentalData) {
      return _buildPopulatedWeatherCard(context);
    }

    // Weather is unavailable and farmer has not yet entered manually
    return _buildWeatherUnavailableCard(context);
  }

  Widget _buildPopulatedWeatherCard(BuildContext context) {
    final isManual = state.weatherSource == 'Manually entered';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.cloud_outlined, color: AppColors.primary, size: 20),
                  AppSpacing.gapH8,
                  Text(
                    'CURRENT CONDITIONS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              AppBadge(
                label: isManual ? 'MANUALLY ENTERED' : 'CURRENT WEATHER',
                variant: isManual ? BadgeVariant.warning : BadgeVariant.success,
              ),
            ],
          ),
          AppSpacing.gapV14,

          // 3-Metric Row: Temperature, Humidity, Rainfall
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Temperature',
                  value: '${state.temperature!.toStringAsFixed(1)}°C',
                  subLabel: 'Seasonal ambient',
                  icon: Icons.thermostat_outlined,
                ),
              ),
              AppSpacing.gapH8,
              Expanded(
                child: _buildMetricTile(
                  label: 'Humidity',
                  value: '${state.humidity!.toStringAsFixed(0)}%',
                  subLabel: 'Relative',
                  icon: Icons.water_drop_outlined,
                ),
              ),
              AppSpacing.gapH8,
              Expanded(
                child: _buildMetricTile(
                  label: 'Rainfall',
                  value: '${state.rainfall!.toStringAsFixed(0)} mm',
                  subLabel: 'Precipitation',
                  icon: Icons.grain_outlined,
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,

          // Footer Row: Source label & Edit action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Source: ${state.weatherSource}',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton.icon(
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.tune_rounded, size: 15, color: AppColors.primary),
                label: const Text(
                  'Edit conditions',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: const Size(0, 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherUnavailableCard(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: const Icon(Icons.cloud_off_outlined, color: AppColors.textSecondary, size: 20),
              ),
              AppSpacing.gapH10,
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current weather unavailable',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Live weather feed is not connected for this region.',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,
          const Text(
            'Temperature, humidity, and rainfall are needed to recommend the most optimal crop. Please provide estimated values for your current season.',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
          AppSpacing.gapV14,
          AppOutlinedButton(
            label: 'Enter Manually',
            leadingIcon: Icons.edit_calendar_outlined,
            onPressed: () => _openEditor(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subLabel,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              AppSpacing.gapH4,
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          AppSpacing.gapV4,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
          ),
          Text(
            subLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9.5, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
