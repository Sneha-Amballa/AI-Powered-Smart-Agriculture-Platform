import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/farmer_components.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// Farmer-first detailed weather and agromet advisory screen.
/// Answers:
/// 1. What is happening? (Current temperature, condition, rain %)
/// 2. What does it mean for my farm? (Soil moisture, humidity, wind)
/// 3. What should I do? (Spraying and irrigation windows)
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final district = authState.profile?.location.district.isNotEmpty == true
        ? authState.profile!.location.district
        : 'Kurnool';
    final state = authState.profile?.location.state.isNotEmpty == true
        ? authState.profile!.location.state
        : 'Andhra Pradesh';

    const forecastSummary =
        '31°C, Partly Cloudy with Showers. Rain probability 65%. Spraying not safe today. Delay irrigation by 24 hours.';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title / Identifier for test invariant and farmer clarity
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Agronomy Weather & Rain',
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
                      const FarmerVoiceButton(textToSpeak: forecastSummary),
                    ],
                  ),
                  AppSpacing.gapV2,
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$district, $state',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapV16,

                  // 1. Centerpiece Today's Weather Card
                  _buildCurrentWeatherCard(),
                  AppSpacing.gapV16,

                  // 2. Critical Farming Windows: Spraying & Irrigation (Action-Oriented)
                  const FarmerSectionHeader(title: 'Farm Action Windows'),
                  AppSpacing.gapV10,
                  _buildFarmingWindowsCard(),
                  AppSpacing.gapV16,

                  // 3. Hourly Forecast (Next 24 Hours)
                  const FarmerSectionHeader(title: 'Hourly Rain Forecast'),
                  AppSpacing.gapV10,
                  _buildHourlyForecastStrip(),
                  AppSpacing.gapV16,

                  // 4. Farm Field Telemetry (Simple metrics)
                  const FarmerSectionHeader(title: 'Field Conditions'),
                  AppSpacing.gapV10,
                  _buildFieldConditionsGrid(),
                  AppSpacing.gapV16,

                  // 5. 7-Day Farm Weather Outlook
                  const FarmerSectionHeader(title: '7-Day Outlook'),
                  AppSpacing.gapV10,
                  _build7DayForecastList(),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '31°C',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const Text(
                      'Partly Cloudy • Rain Showers',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD8F3DC),
                      ),
                    ),
                    AppSpacing.gapV4,
                    const Text(
                      'Feels like 34°C • High 33° / Low 24°',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB7E4C7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.wb_cloudy_rounded,
                size: 48,
                color: Color(0xFFFFD166),
              ),
            ],
          ),
          AppSpacing.gapV14,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Row(
              children: [
                Icon(Icons.water_drop_rounded, size: 16, color: Color(0xFF90CAF9)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rain Probability: 65% expected tomorrow afternoon',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildFarmingWindowsCard() {
    return AppCard(
      child: Column(
        children: [
          _buildWindowRow(
            icon: Icons.cancel_outlined,
            iconColor: AppColors.error,
            title: 'Pesticide & Fertilizer Spraying',
            status: 'Not Safe Today',
            statusColor: AppColors.error,
            advice: 'Hold spraying until rain passes to prevent chemical runoff and wasted expense.',
          ),
          const Divider(height: 20, thickness: 1, color: AppColors.cardBorder),
          _buildWindowRow(
            icon: Icons.pause_circle_outline_rounded,
            iconColor: AppColors.warning,
            title: 'Drip / Flood Irrigation',
            status: 'Delay 24 Hours',
            statusColor: const Color(0xFFE65100),
            advice: 'Expected shower of 18mm will recharge root moisture adequately.',
          ),
          const Divider(height: 20, thickness: 1, color: AppColors.cardBorder),
          _buildWindowRow(
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.primary,
            title: 'Best Spray Window',
            status: 'Thursday Morning',
            statusColor: AppColors.primary,
            advice: 'Clear skies and dry winds forecast from 7:00 AM to 11:30 AM.',
          ),
        ],
      ),
    );
  }

  Widget _buildWindowRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String status,
    required Color statusColor,
    required String advice,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        AppSpacing.gapH12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 2,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV4,
              Text(
                advice,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecastStrip() {
    final hours = [
      {'time': '6 AM', 'temp': '25°C', 'icon': Icons.wb_sunny_outlined, 'rain': '10%'},
      {'time': '9 AM', 'temp': '28°C', 'icon': Icons.wb_cloudy_outlined, 'rain': '25%'},
      {'time': '12 PM', 'temp': '32°C', 'icon': Icons.cloud_outlined, 'rain': '45%'},
      {'time': '3 PM', 'temp': '31°C', 'icon': Icons.thunderstorm_outlined, 'rain': '65%'},
      {'time': '6 PM', 'temp': '29°C', 'icon': Icons.grain_outlined, 'rain': '60%'},
      {'time': '9 PM', 'temp': '26°C', 'icon': Icons.nights_stay_outlined, 'rain': '30%'},
    ];

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = hours[index];
          return Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  item['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Icon(item['icon'] as IconData, size: 22, color: AppColors.primary),
                Text(
                  item['temp'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.water_drop, size: 10, color: AppColors.sky),
                    const SizedBox(width: 2),
                    Text(
                      item['rain'] as String,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sky,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldConditionsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTelemetryTile(Icons.water_drop_outlined, 'Humidity', '78%', 'High')),
            AppSpacing.gapH8,
            Expanded(child: _buildTelemetryTile(Icons.air_rounded, 'Wind Speed', '14 km/h', 'Moderate')),
          ],
        ),
        AppSpacing.gapV8,
        Row(
          children: [
            Expanded(child: _buildTelemetryTile(Icons.grain_rounded, 'Rain Expected', '18 mm', 'Showers')),
            AppSpacing.gapH8,
            Expanded(child: _buildTelemetryTile(Icons.eco_outlined, 'Soil Moisture', '62%', 'Adequate')),
          ],
        ),
      ],
    );
  }

  Widget _buildTelemetryTile(IconData icon, String label, String value, String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              Text(
                badge,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.gapV6,
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build7DayForecastList() {
    final days = [
      {'day': 'Tomorrow', 'cond': 'Rain Showers', 'rain': '65%', 'range': '32° / 24°', 'icon': Icons.grain},
      {'day': 'Thursday', 'cond': 'Mostly Sunny', 'rain': '15%', 'range': '34° / 23°', 'icon': Icons.wb_sunny_outlined},
      {'day': 'Friday', 'cond': 'Clear Sky', 'rain': '5%', 'range': '35° / 24°', 'icon': Icons.wb_sunny},
      {'day': 'Saturday', 'cond': 'Partly Cloudy', 'rain': '20%', 'range': '33° / 23°', 'icon': Icons.wb_cloudy_outlined},
      {'day': 'Sunday', 'cond': 'Light Rain', 'rain': '40%', 'range': '31° / 22°', 'icon': Icons.grain_outlined},
    ];

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: days.map((d) {
          final isLast = days.indexOf(d) == days.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(d['icon'] as IconData, size: 20, color: AppColors.primary),
                    AppSpacing.gapH12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['day'] as String,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            d['cond'] as String,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.water_drop, size: 12, color: AppColors.sky),
                        const SizedBox(width: 2),
                        Text(
                          d['rain'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sky,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH16,
                    Text(
                      d['range'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, thickness: 1, color: AppColors.cardBorder),
            ],
          );
        }).toList(),
      ),
    );
  }
}
