import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_dropdown.dart';
import '../../../../shared/widgets/app_outlined_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

enum SoilSaveScope {
  thisRecommendationOnly,
  saveToFarmProfile,
}

/// Clean bottom sheet modal allowing farmers to edit N, P, K, pH, and soil type.
/// Explicitly distinguishes between one-time recommendation overrides (default)
/// and permanent updates to their registered farm profile.
class EditSoilBottomSheet extends StatefulWidget {
  final double? initialN;
  final double? initialP;
  final double? initialK;
  final double? initialPh;
  final String? initialSoilType;
  final bool hasExistingProfile;
  final void Function({
    required double n,
    required double p,
    required double k,
    required double ph,
    String? soilType,
    required bool updateProfile,
  }) onSave;

  const EditSoilBottomSheet({
    super.key,
    this.initialN,
    this.initialP,
    this.initialK,
    this.initialPh,
    this.initialSoilType,
    this.hasExistingProfile = true,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    double? initialN,
    double? initialP,
    double? initialK,
    double? initialPh,
    String? initialSoilType,
    bool hasExistingProfile = true,
    required void Function({
      required double n,
      required double p,
      required double k,
      required double ph,
      String? soilType,
      required bool updateProfile,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => EditSoilBottomSheet(
        initialN: initialN,
        initialP: initialP,
        initialK: initialK,
        initialPh: initialPh,
        initialSoilType: initialSoilType,
        hasExistingProfile: hasExistingProfile,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditSoilBottomSheet> createState() => _EditSoilBottomSheetState();
}

class _EditSoilBottomSheetState extends State<EditSoilBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nController;
  late final TextEditingController _pController;
  late final TextEditingController _kController;
  late final TextEditingController _phController;
  late String _selectedSoilType;

  SoilSaveScope _selectedScope = SoilSaveScope.thisRecommendationOnly;

  static const List<String> _soilTypes = [
    'Black Cotton Soil',
    'Red Sandy Loam',
    'Alluvial Soil',
    'Clayey Soil',
    'Laterite Soil',
    'Sandy Loam',
    'Other / General Soil',
  ];

  @override
  void initState() {
    super.initState();
    _nController = TextEditingController(
      text: widget.initialN != null ? widget.initialN!.toStringAsFixed(0) : '',
    );
    _pController = TextEditingController(
      text: widget.initialP != null ? widget.initialP!.toStringAsFixed(0) : '',
    );
    _kController = TextEditingController(
      text: widget.initialK != null ? widget.initialK!.toStringAsFixed(0) : '',
    );
    _phController = TextEditingController(
      text: widget.initialPh != null ? widget.initialPh!.toStringAsFixed(1) : '',
    );

    final initialType = widget.initialSoilType;
    if (initialType != null && _soilTypes.contains(initialType)) {
      _selectedSoilType = initialType;
    } else {
      _selectedSoilType = _soilTypes.first;
    }
  }

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final n = double.tryParse(_nController.text) ?? 0.0;
    final p = double.tryParse(_pController.text) ?? 0.0;
    final k = double.tryParse(_kController.text) ?? 0.0;
    final ph = double.tryParse(_phController.text) ?? 7.0;

    Navigator.pop(context);

    widget.onSave(
      n: n,
      p: p,
      k: k,
      ph: ph,
      soilType: _selectedSoilType,
      updateProfile: _selectedScope == SoilSaveScope.saveToFarmProfile,
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
                        Icon(Icons.science_outlined, color: AppColors.primary, size: 22),
                        AppSpacing.gapH8,
                        Text(
                          'Edit Soil Information',
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

                // Soil Type
                AppDropdown<String>(
                  label: 'Soil Type',
                  value: _selectedSoilType,
                  items: _soilTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSoilType = val);
                  },
                ),
                AppSpacing.gapV14,

                // NPK Inputs
                const Text(
                  'Nutrient Values (kg/ha)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV8,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Nitrogen (N)',
                        hintText: 'e.g. 80',
                        prefixIcon: Icons.eco_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: _nController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final val = double.tryParse(v);
                          if (val == null || val < 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.gapH10,
                    Expanded(
                      child: AppTextField(
                        label: 'Phosphorus (P)',
                        hintText: 'e.g. 40',
                        prefixIcon: Icons.science_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: _pController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final val = double.tryParse(v);
                          if (val == null || val < 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.gapH10,
                    Expanded(
                      child: AppTextField(
                        label: 'Potassium (K)',
                        hintText: 'e.g. 30',
                        prefixIcon: Icons.grain_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: _kController,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final val = double.tryParse(v);
                          if (val == null || val < 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV14,

                // Soil pH
                AppTextField(
                  label: 'Soil pH (0 - 14)',
                  hintText: 'e.g. 6.5',
                  prefixIcon: Icons.speed_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _phController,
                  helperText: 'Neutral agricultural soil is around 6.5 - 7.5',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Soil pH is required';
                    final val = double.tryParse(v);
                    if (val == null || val < 0 || val > 14) return 'Enter 0 - 14';
                    return null;
                  },
                ),
                AppSpacing.gapV20,

                // Scope Choice: "Use for this recommendation only" vs "Update my farm profile"
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apply Changes To:',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.gapV6,
                      _buildScopeOption(
                        title: 'Use for this recommendation only (Recommended)',
                        subtitle: 'Preserves your saved farm profile data unchanged.',
                        scope: SoilSaveScope.thisRecommendationOnly,
                      ),
                      AppSpacing.gapV8,
                      _buildScopeOption(
                        title: 'Save changes to farm profile',
                        subtitle: 'Permanently updates your registered farm soil details.',
                        scope: SoilSaveScope.saveToFarmProfile,
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapV20,

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
                        label: _selectedScope == SoilSaveScope.saveToFarmProfile
                            ? 'Update & Apply'
                            : 'Apply for Recommendation',
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

  Widget _buildScopeOption({
    required String title,
    required String subtitle,
    required SoilSaveScope scope,
  }) {
    final isSelected = _selectedScope == scope;

    return InkWell(
      onTap: () => setState(() => _selectedScope = scope),
      borderRadius: AppRadius.radiusSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sage.withValues(alpha: 0.3) : AppColors.surface,
          borderRadius: AppRadius.radiusSm,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.4 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            AppSpacing.gapH10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
