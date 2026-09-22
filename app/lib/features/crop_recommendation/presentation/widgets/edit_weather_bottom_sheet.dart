import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_outlined_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Clean bottom sheet modal allowing farmers to enter or adjust current
/// environmental parameters (Temperature, Humidity, Rainfall).
/// Clearly labeled as manual input to preserve data integrity.
class EditWeatherBottomSheet extends StatefulWidget {
  final double? initialTemperature;
  final double? initialHumidity;
  final double? initialRainfall;
  final void Function({
    required double temperature,
    required double humidity,
    required double rainfall,
  }) onSave;

  const EditWeatherBottomSheet({
    super.key,
    this.initialTemperature,
    this.initialHumidity,
    this.initialRainfall,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    double? initialTemperature,
    double? initialHumidity,
    double? initialRainfall,
    required void Function({
      required double temperature,
      required double humidity,
      required double rainfall,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => EditWeatherBottomSheet(
        initialTemperature: initialTemperature,
        initialHumidity: initialHumidity,
        initialRainfall: initialRainfall,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditWeatherBottomSheet> createState() => _EditWeatherBottomSheetState();
}

class _EditWeatherBottomSheetState extends State<EditWeatherBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tempController;
  late final TextEditingController _humidityController;
  late final TextEditingController _rainfallController;

  @override
  void initState() {
    super.initState();
    _tempController = TextEditingController(
      text: widget.initialTemperature != null
          ? widget.initialTemperature!.toStringAsFixed(1)
          : '',
    );
    _humidityController = TextEditingController(
      text: widget.initialHumidity != null
          ? widget.initialHumidity!.toStringAsFixed(0)
          : '',
    );
    _rainfallController = TextEditingController(
      text: widget.initialRainfall != null
          ? widget.initialRainfall!.toStringAsFixed(1)
          : '',
    );
  }

  @override
  void dispose() {
    _tempController.dispose();
    _humidityController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final temp = double.tryParse(_tempController.text) ?? 25.0;
    final hum = double.tryParse(_humidityController.text) ?? 70.0;
    final rain = double.tryParse(_rainfallController.text) ?? 100.0;

    Navigator.pop(context);

    widget.onSave(
      temperature: temp,
      humidity: hum,
      rainfall: rain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud_outlined, color: AppColors.primary, size: 22),
                        AppSpacing.gapH8,
                        Text(
                          'Environmental Conditions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const Divider(height: 24),

                const Text(
                  'Enter current seasonal conditions for your farm. These dynamic values are used for this recommendation without permanently saving to your farm profile.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                ),
                AppSpacing.gapV16,

                // Temperature
                AppTextField(
                  label: 'Temperature (°C)',
                  hintText: 'e.g. 28.0',
                  prefixIcon: Icons.thermostat_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _tempController,
                  helperText: 'Typical crop growing temperatures range from 15°C to 40°C',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Temperature is required';
                    final val = double.tryParse(v);
                    if (val == null || val < -10 || val > 60) return 'Enter realistic temperature (-10 to 60°C)';
                    return null;
                  },
                ),
                AppSpacing.gapV14,

                // Humidity
                AppTextField(
                  label: 'Relative Humidity (%)',
                  hintText: 'e.g. 72',
                  prefixIcon: Icons.water_drop_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _humidityController,
                  helperText: 'Standard relative humidity is between 20% and 95%',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Humidity is required';
                    final val = double.tryParse(v);
                    if (val == null || val < 0 || val > 100) return 'Enter 0 to 100%';
                    return null;
                  },
                ),
                AppSpacing.gapV14,

                // Rainfall
                AppTextField(
                  label: 'Seasonal / Annual Rainfall (mm)',
                  hintText: 'e.g. 120.0',
                  prefixIcon: Icons.grain_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _rainfallController,
                  helperText: 'Rainfall expected or measured for the planting season',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Rainfall is required';
                    final val = double.tryParse(v);
                    if (val == null || val < 0) return 'Rainfall cannot be negative';
                    return null;
                  },
                ),
                AppSpacing.gapV24,

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: 'Save Conditions',
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
