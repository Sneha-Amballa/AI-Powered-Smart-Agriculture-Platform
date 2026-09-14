import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/layouts/app_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/app_outlined_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../domain/models/farmer_profile_model.dart';
import '../presentation/providers/auth_provider.dart';

/// Guided 3-step farmer onboarding wizard for precision agricultural profile.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // Step 1: Location Controllers
  String _selectedState = 'Andhra Pradesh';
  final _districtController = TextEditingController();
  final _villageController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Step 2: Farm Info Controllers
  final _landAreaController = TextEditingController();
  String _areaUnit = 'Acres';
  bool _hasSoilReport = false;
  String _selectedSoilType = 'Black Cotton Soil';
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _phController = TextEditingController();

  // Step 3: Farming Details Controllers
  String _irrigationType = 'Borewell';
  String? _selectedPrimaryCrop = 'Cotton';
  final _experienceController = TextEditingController();

  static const List<String> _indianStates = [
    'Andhra Pradesh',
    'Bihar',
    'Chhattisgarh',
    'Gujarat',
    'Haryana',
    'Karnataka',
    'Madhya Pradesh',
    'Maharashtra',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
  ];

  static const List<String> _soilTypes = [
    'Black Cotton Soil',
    'Red Sandy Loam',
    'Alluvial Soil',
    'Clayey Soil',
    'Laterite Soil',
    'Sandy Loam',
    'Other / General Soil',
  ];

  static const List<String> _irrigationOptions = [
    'Borewell',
    'Canal',
    'Drip Irrigation',
    'Sprinkler',
    'Rainfed',
  ];

  static const List<String> _commonCrops = [
    'Rice / Paddy',
    'Wheat',
    'Cotton',
    'Maize',
    'Tomato',
    'Soybean',
    'Chilli',
    'Pulses / Gram',
    'Sugarcane',
    'Groundnut',
    'Other Crop',
  ];

  @override
  void dispose() {
    _districtController.dispose();
    _villageController.dispose();
    _pincodeController.dispose();
    _landAreaController.dispose();
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_formKeyStep1.currentState!.validate()) return;
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (!_formKeyStep2.currentState!.validate()) return;
      setState(() => _currentStep = 2);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      // Exit wizard confirmation
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Exit Setup?'),
          content: const Text(
            'Your profile setup is required to access personalized crop advisories.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Continue Setup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(authNotifierProvider.notifier).logout();
                context.go('/login');
              },
              child: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleComplete() async {
    if (!_formKeyStep3.currentState!.validate()) return;

    final location = FarmerLocation(
      state: _selectedState,
      district: _districtController.text.trim(),
      village: _villageController.text.trim(),
      pincode: _pincodeController.text.trim().isNotEmpty
          ? _pincodeController.text.trim()
          : null,
    );

    final landArea = double.tryParse(_landAreaController.text.trim()) ?? 1.0;
    final expYears = int.tryParse(_experienceController.text.trim());

    FarmDetails farmDetails;
    if (_hasSoilReport) {
      farmDetails = FarmDetails(
        landArea: landArea,
        areaUnit: _areaUnit,
        hasSoilReport: true,
        ph: double.tryParse(_phController.text.trim()),
        nitrogen: double.tryParse(_nController.text.trim()),
        phosphorus: double.tryParse(_pController.text.trim()),
        potassium: double.tryParse(_kController.text.trim()),
        irrigationType: _irrigationType,
        primaryCrop: _selectedPrimaryCrop,
        farmingExperienceYears: expYears,
      );
    } else {
      // No fake NPK values generated!
      farmDetails = FarmDetails(
        landArea: landArea,
        areaUnit: _areaUnit,
        hasSoilReport: false,
        soilType: _selectedSoilType,
        irrigationType: _irrigationType,
        primaryCrop: _selectedPrimaryCrop,
        farmingExperienceYears: expYears,
      );
    }

    final success = await ref.read(authNotifierProvider.notifier).saveFarmerProfile(
          location: location,
          farmDetails: farmDetails,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm profile created successfully! Welcome to KisanAI.'),
          backgroundColor: AppColors.primaryDark,
          duration: Duration(seconds: 2),
        ),
      );
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return AppScaffold(
      showBackButton: true,
      onBackPressed: _prevStep,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(authState.user?.fullName),
                AppSpacing.gapV20,
                _buildStepIndicator(),
                AppSpacing.gapV24,
                if (authState.errorMessage != null) ...[
                  _buildErrorBanner(authState.errorMessage!),
                  AppSpacing.gapV16,
                ],
                _buildCurrentStepCard(),
                AppSpacing.gapV24,
                _buildActionButtons(authState.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String? userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.6),
            borderRadius: AppRadius.radiusPill,
          ),
          child: const Text(
            'FARM REGISTRATION • 3 EASY STEPS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        AppSpacing.gapV12,
        Text(
          userName != null && userName.isNotEmpty
              ? 'Namaste, $userName'
              : 'Set Up Your Farm Profile',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.gapV6,
        const Text(
          'Provide your location and farm characteristics for precision agronomic advisories.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      ('1', 'Location'),
      ('2', 'Farm & Soil'),
      ('3', 'Farming Details'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.radiusMd,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: List.generate(steps.length, (index) {
              final isCurrent = _currentStep == index;
              final isCompleted = _currentStep > index;

              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isCompleted
                          ? AppColors.primary
                          : isCurrent
                              ? AppColors.primaryDark
                              : AppColors.cardBorder,
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text(
                              steps[index].$1,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                    ),
                    if (!isCompact || isCurrent) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          steps[index].$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCurrent
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStepCard() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Location();
      case 1:
        return _buildStep2FarmAndSoil();
      case 2:
      default:
        return _buildStep3FarmingDetails();
    }
  }

  // STEP 1: LOCATION
  Widget _buildStep1Location() {
    return AppCard(
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on_outlined, color: AppColors.primary, size: 22),
                AppSpacing.gapH8,
                Expanded(
                  child: Text(
                    'Step 1: Farm Location',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            AppSpacing.gapV4,
            const Text(
              'No GPS permission requested. Enter your agricultural district manually.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            AppSpacing.gapV20,
            AppDropdown<String>(
              label: 'State / Union Territory *',
              value: _selectedState,
              prefixIcon: Icons.map_outlined,
              items: _indianStates.map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedState = val);
              },
            ),
            AppSpacing.gapV16,
            AppTextField(
              label: 'District *',
              hintText: 'e.g. Kurnool, Guntur, Solapur',
              prefixIcon: Icons.apartment_outlined,
              controller: _districtController,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'District is required' : null,
            ),
            AppSpacing.gapV16,
            AppTextField(
              label: 'Village / Mandal *',
              hintText: 'e.g. Nandyal Mandal, Alur',
              prefixIcon: Icons.holiday_village_outlined,
              controller: _villageController,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Village/Mandal is required' : null,
            ),
            AppSpacing.gapV16,
            AppTextField(
              label: 'Pincode (Optional)',
              hintText: '6-digit postal code',
              prefixIcon: Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
              controller: _pincodeController,
              validator: (v) {
                if (v != null && v.trim().isNotEmpty) {
                  if (!RegExp(r'^\d{6}$').hasMatch(v.trim())) {
                    return 'Please enter a valid 6-digit PIN code';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: FARM & SOIL INFO
  Widget _buildStep2FarmAndSoil() {
    return AppCard(
      child: Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.landscape_outlined, color: AppColors.primary, size: 22),
                AppSpacing.gapH8,
                Expanded(
                  child: Text(
                    'Step 2: Land & Soil Info',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            AppSpacing.gapV4,
            const Text(
              'Accurate farm area ensures precise fertilizer and pesticide dose calculations.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            AppSpacing.gapV20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    label: 'Total Farm Land Area *',
                    hintText: 'e.g. 5.5',
                    prefixIcon: Icons.crop_square_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _landAreaController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter farm land area';
                      final parsed = double.tryParse(v.trim());
                      if (parsed == null || parsed <= 0) return 'Enter a valid area > 0';
                      return null;
                    },
                  ),
                ),
                AppSpacing.gapH12,
                Expanded(
                  flex: 2,
                  child: AppDropdown<String>(
                    label: 'Unit',
                    value: _areaUnit,
                    items: const [
                      DropdownMenuItem(value: 'Acres', child: Text('Acres')),
                      DropdownMenuItem(value: 'Hectares', child: Text('Hectares')),
                      DropdownMenuItem(value: 'Bigha', child: Text('Bigha')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _areaUnit = val);
                    },
                  ),
                ),
              ],
            ),
            AppSpacing.gapV20,
            const Divider(height: 1),
            AppSpacing.gapV16,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.science_outlined, color: AppColors.primary, size: 24),
                  AppSpacing.gapH12,
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have a Soil Health Card / Lab Test?',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Tested values yield laboratory-grade recommendations.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _hasSoilReport,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _hasSoilReport = val);
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.gapV16,
            if (_hasSoilReport) ...[
              const Text(
                'Enter Soil Lab Test Values (N, P, K & pH)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
              ),
              AppSpacing.gapV12,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Nitrogen (N)',
                      hintText: 'kg/ha (e.g. 120)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _nController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  AppSpacing.gapH12,
                  Expanded(
                    child: AppTextField(
                      label: 'Phosphorus (P)',
                      hintText: 'kg/ha (e.g. 45)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _pController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV12,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Potassium (K)',
                      hintText: 'kg/ha (e.g. 60)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _kController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  AppSpacing.gapH12,
                  Expanded(
                    child: AppTextField(
                      label: 'Soil pH',
                      hintText: '0.0 - 14.0 (e.g. 6.5)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _phController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final val = double.tryParse(v.trim());
                        if (val == null || val < 0.0 || val > 14.0) {
                          return '0.0 - 14.0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              AppDropdown<String>(
                label: 'General Soil Type in Your Region *',
                value: _selectedSoilType,
                prefixIcon: Icons.grain_outlined,
                items: _soilTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSoilType = val);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // STEP 3: FARMING DETAILS
  Widget _buildStep3FarmingDetails() {
    return AppCard(
      child: Form(
        key: _formKeyStep3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.water_drop_outlined, color: AppColors.primary, size: 22),
                AppSpacing.gapH8,
                Expanded(
                  child: Text(
                    'Step 3: Farming Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            AppSpacing.gapV4,
            const Text(
              'Select your water source and primary cultivated crop.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            AppSpacing.gapV20,
            AppDropdown<String>(
              label: 'Primary Irrigation Source *',
              value: _irrigationType,
              prefixIcon: Icons.water_outlined,
              items: _irrigationOptions.map((irr) {
                return DropdownMenuItem(value: irr, child: Text(irr));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _irrigationType = val);
              },
            ),
            AppSpacing.gapV16,
            AppDropdown<String>(
              label: 'Primary Cultivated Crop (Optional)',
              value: _selectedPrimaryCrop,
              prefixIcon: Icons.eco_outlined,
              items: _commonCrops.map((crop) {
                return DropdownMenuItem(value: crop, child: Text(crop));
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedPrimaryCrop = val);
              },
            ),
            AppSpacing.gapV16,
            AppTextField(
              label: 'Farming Experience in Years (Optional)',
              hintText: 'e.g. 10',
              prefixIcon: Icons.history_outlined,
              keyboardType: TextInputType.number,
              controller: _experienceController,
              validator: (v) {
                if (v != null && v.trim().isNotEmpty) {
                  final exp = int.tryParse(v.trim());
                  if (exp == null || exp < 0 || exp > 80) {
                    return 'Enter valid years (0-80)';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    final isLastStep = _currentStep == 2;

    return Row(
      children: [
        Expanded(
          child: AppOutlinedButton(
            label: _currentStep == 0 ? 'Cancel' : 'Previous',
            leadingIcon: _currentStep == 0 ? Icons.close : Icons.arrow_back,
            onPressed: isLoading ? null : _prevStep,
          ),
        ),
        AppSpacing.gapH16,
        Expanded(
          flex: 2,
          child: AppButton(
            label: isLastStep ? 'Complete Registration' : 'Next Step',
            trailingIcon: isLastStep ? Icons.check_circle_outline : Icons.arrow_forward,
            isLoading: isLoading,
            onPressed: isLastStep ? _handleComplete : _nextStep,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          AppSpacing.gapH12,
          Expanded(
            child: Text(
              error,
              style: const TextStyle(fontSize: 13, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

