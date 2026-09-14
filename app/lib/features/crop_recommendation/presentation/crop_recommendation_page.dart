import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../data/crop_recommendation_model.dart';
import '../data/crop_recommendation_repository.dart';

/// Production-ready Crop Recommendation UI wired to the deployed Render ML service.
class CropRecommendationPage extends StatefulWidget {
  const CropRecommendationPage({super.key});

  @override
  State<CropRecommendationPage> createState() => _CropRecommendationPageState();
}

class _CropRecommendationPageState extends State<CropRecommendationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController(text: '90');
  final _pController = TextEditingController(text: '42');
  final _kController = TextEditingController(text: '43');
  final _tempController = TextEditingController(text: '20.87');
  final _humidityController = TextEditingController(text: '82.0');
  final _phController = TextEditingController(text: '6.5');
  final _rainfallController = TextEditingController(text: '202.93');

  bool _isLoading = false;
  String? _errorMessage;
  CropRecommendationResult? _result;

  late final CropRecommendationRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = CropRecommendationRepositoryImpl();
  }

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _tempController.dispose();
    _humidityController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  void _loadPreset(
    double n,
    double p,
    double k,
    double temp,
    double hum,
    double ph,
    double rain,
  ) {
    setState(() {
      _nController.text = n.toString();
      _pController.text = p.toString();
      _kController.text = k.toString();
      _tempController.text = temp.toString();
      _humidityController.text = hum.toString();
      _phController.text = ph.toString();
      _rainfallController.text = rain.toString();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final input = CropRecommendationInput(
      nitrogen: double.tryParse(_nController.text) ?? 90.0,
      phosphorus: double.tryParse(_pController.text) ?? 42.0,
      potassium: double.tryParse(_kController.text) ?? 43.0,
      temperature: double.tryParse(_tempController.text) ?? 20.87,
      humidity: double.tryParse(_humidityController.text) ?? 82.0,
      ph: double.tryParse(_phController.text) ?? 6.5,
      rainfall: double.tryParse(_rainfallController.text) ?? 202.93,
    );

    try {
      final res = await _repository.getRecommendation(input);
      setState(() {
        _result = res;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildModelStatusBanner(),
              AppSpacing.gapV16,
              _buildPresetRow(),
              AppSpacing.gapV16,
              _buildInputForm(),
              AppSpacing.gapV24,
              if (_isLoading) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ] else if (_errorMessage != null) ...[
                AppErrorState(
                  title: 'Recommendation Service Notice',
                  message:
                      'The ML service on Render is starting up or temporarily busy. Please retry in a few moments.',
                  onRetry: _submit,
                ),
              ] else if (_result != null) ...[
                _buildResultCard(_result!),
              ],
              AppSpacing.gapV32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelStatusBanner() {
    return AppCard(
      backgroundColor: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 22),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      child: Text(
                        'Live Production ML Model',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    AppSpacing.gapH6,
                    AppBadge(label: 'ONLINE', variant: BadgeVariant.success),
                  ],
                ),
                AppSpacing.gapV2,
                const Text(
                  'Connected to Render Cloud API • Instant Soil Analysis',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text(
            'Quick Presets:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
          AppSpacing.gapH8,
          ActionChip(
            label: const Text('Rice / Paddy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            avatar: const Icon(Icons.grass, size: 16, color: AppColors.primary),
            backgroundColor: AppColors.surface,
            onPressed: () => _loadPreset(90, 42, 43, 20.87, 82.0, 6.5, 202.93),
          ),
          AppSpacing.gapH8,
          ActionChip(
            label: const Text('Cotton', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            avatar: const Icon(Icons.eco, size: 16, color: AppColors.harvestGold),
            backgroundColor: AppColors.surface,
            onPressed: () => _loadPreset(120, 40, 20, 25.5, 60.0, 7.2, 85.0),
          ),
          AppSpacing.gapH8,
          ActionChip(
            label: const Text('Maize', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            avatar: const Icon(Icons.grain, size: 16, color: AppColors.sky),
            backgroundColor: AppColors.surface,
            onPressed: () => _loadPreset(80, 40, 40, 24.0, 65.0, 6.8, 110.0),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        return AppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: const [
                    Icon(Icons.science_outlined, size: 18, color: AppColors.primary),
                    AppSpacing.gapH8,
                    Expanded(
                      child: Text(
                        'Soil Nutrients (kg/ha)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV12,
                if (isNarrow) ...[
                  AppTextField(
                    label: 'Nitrogen (N)',
                    hintText: 'e.g. 90',
                    prefixIcon: Icons.eco_outlined,
                    keyboardType: TextInputType.number,
                    controller: _nController,
                  ),
                  AppSpacing.gapV12,
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Phosphorus (P)',
                          hintText: 'e.g. 42',
                          prefixIcon: Icons.science_outlined,
                          keyboardType: TextInputType.number,
                          controller: _pController,
                        ),
                      ),
                      AppSpacing.gapH12,
                      Expanded(
                        child: AppTextField(
                          label: 'Potassium (K)',
                          hintText: 'e.g. 43',
                          prefixIcon: Icons.grain_outlined,
                          keyboardType: TextInputType.number,
                          controller: _kController,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Nitrogen (N)',
                          hintText: 'e.g. 90',
                          prefixIcon: Icons.eco_outlined,
                          keyboardType: TextInputType.number,
                          controller: _nController,
                        ),
                      ),
                      AppSpacing.gapH12,
                      Expanded(
                        child: AppTextField(
                          label: 'Phosphorus (P)',
                          hintText: 'e.g. 42',
                          prefixIcon: Icons.science_outlined,
                          keyboardType: TextInputType.number,
                          controller: _pController,
                        ),
                      ),
                      AppSpacing.gapH12,
                      Expanded(
                        child: AppTextField(
                          label: 'Potassium (K)',
                          hintText: 'e.g. 43',
                          prefixIcon: Icons.grain_outlined,
                          keyboardType: TextInputType.number,
                          controller: _kController,
                        ),
                      ),
                    ],
                  ),
                ],
                AppSpacing.gapV20,
                Row(
                  children: const [
                    Icon(Icons.cloud_outlined, size: 18, color: AppColors.primary),
                    AppSpacing.gapH8,
                    Expanded(
                      child: Text(
                        'Climate & Environment',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV12,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Temperature (°C)',
                        hintText: 'e.g. 20.87',
                        prefixIcon: Icons.thermostat_outlined,
                        keyboardType: TextInputType.number,
                        controller: _tempController,
                      ),
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      child: AppTextField(
                        label: 'Humidity (%)',
                        hintText: 'e.g. 82.0',
                        prefixIcon: Icons.water_drop_outlined,
                        keyboardType: TextInputType.number,
                        controller: _humidityController,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV12,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Soil pH (0-14)',
                        hintText: 'e.g. 6.5',
                        prefixIcon: Icons.speed_outlined,
                        keyboardType: TextInputType.number,
                        controller: _phController,
                      ),
                    ),
                    AppSpacing.gapH12,
                    Expanded(
                      child: AppTextField(
                        label: 'Rainfall (mm)',
                        hintText: 'e.g. 202.93',
                        prefixIcon: Icons.grain_outlined,
                        keyboardType: TextInputType.number,
                        controller: _rainfallController,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV24,
                AppButton(
                  label: _isLoading ? 'Analyzing Parameters...' : 'Predict Recommended Crop',
                  leadingIcon: Icons.psychology_outlined,
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard(CropRecommendationResult result) {
    return AppCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        'Prediction Result',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppBadge(
                label: result.recommendations.isNotEmpty
                    ? '${result.recommendations.first.confidence.toStringAsFixed(1)}% Match'
                    : 'Optimal',
                variant: BadgeVariant.success,
              ),
            ],
          ),
          AppSpacing.gapV16,
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppRadius.radiusMd,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.eco, size: 30, color: AppColors.primary),
              ),
              AppSpacing.gapH14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.recommendedCrop.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV2,
                    const Text(
                      'Highest yielding crop for your soil and weather profile.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (result.recommendations.isNotEmpty) ...[
            AppSpacing.gapV20,
            const Text(
              'Model Confidence Rankings:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            AppSpacing.gapV8,
            ...result.recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rec.crop.toUpperCase(),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${rec.confidence.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    AppSpacing.gapV4,
                    LinearProgressIndicator(
                      value: (rec.confidence / 100).clamp(0.0, 1.0),
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        rec == result.recommendations.first
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                      minHeight: 6,
                      borderRadius: AppRadius.radiusPill,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
