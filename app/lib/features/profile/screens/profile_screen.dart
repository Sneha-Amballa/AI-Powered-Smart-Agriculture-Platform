import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/app_outlined_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/language_selector_sheet.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../shared/widgets/farmer_components.dart';
import '../../authentication/domain/models/farmer_profile_model.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import '../../../core/services/location_service.dart';

/// Premium, high-aesthetic Farmer Profile Screen.
/// Features:
/// 1. Hero Farmer Identity Card with organic evergreen gradient and verification badges
/// 2. 4-Metric Farm Overview Grid (Land, Primary Crop, Soil Profile, Irrigation Source)
/// 3. Precision Soil Health & N-P-K Nutrient Visualizer
/// 4. Categorized Farm & Geographical Specifications
/// 5. Language Preferences & Support Helpline
/// 6. Secure Account & Session Management
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out? Your farm profile, crops, and data will remain safely saved on this device for your next login.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully. Your farm profile is preserved.')),
                );
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Account Permanently?',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ],
        ),
        content: const Text(
          'This action cannot be undone. All your saved farm profile details, soil test data, crop advisory records, and account credentials will be permanently erased from this device.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your account and all farm records have been permanently deleted.'),
                    backgroundColor: AppColors.error,
                  ),
                );
                context.go('/login');
              }
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, FarmerProfile profile) {
    final formKey = GlobalKey<FormState>();
    final districtCtrl = TextEditingController(text: profile.location.district);
    final villageCtrl = TextEditingController(text: profile.location.village);
    final pincodeCtrl = TextEditingController(text: profile.location.pincode ?? '');
    final landAreaCtrl = TextEditingController(text: profile.farmDetails.landArea.toString());
    final expCtrl = TextEditingController(text: profile.farmDetails.farmingExperienceYears?.toString() ?? '');

    String selectedState = profile.location.state.isNotEmpty ? profile.location.state : 'Andhra Pradesh';
    String areaUnit = profile.farmDetails.areaUnit;
    String irrigation = profile.farmDetails.irrigationType;
    String? crop = profile.farmDetails.primaryCrop;
    bool hasReport = profile.farmDetails.hasSoilReport;
    String soilType = profile.farmDetails.soilType ?? 'Red Sandy Loam';

    final nCtrl = TextEditingController(text: profile.farmDetails.nitrogen?.toString() ?? '120');
    final pCtrl = TextEditingController(text: profile.farmDetails.phosphorus?.toString() ?? '45');
    final kCtrl = TextEditingController(text: profile.farmDetails.potassium?.toString() ?? '60');
    final phCtrl = TextEditingController(text: profile.farmDetails.ph?.toString() ?? '6.5');

    double? updatedLat = profile.location.latitude;
    double? updatedLon = profile.location.longitude;
    bool isDetectingGps = false;
    String? gpsMsg;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.cardBorder,
                              borderRadius: AppRadius.radiusPill,
                            ),
                          ),
                        ),
                        AppSpacing.gapV14,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Edit Farm Profile',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        AppSpacing.gapV8,

                        // Location Section Header
                        _buildModalSectionHeader('1. Geographical Location', Icons.location_on_outlined),
                        AppSpacing.gapV10,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: AppRadius.radiusSm,
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.gps_fixed, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  gpsMsg ??
                                      (updatedLat != null
                                          ? 'Farm GPS: ${updatedLat!.toStringAsFixed(2)}, ${updatedLon!.toStringAsFixed(2)}'
                                          : 'GPS coordinates not set'),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: isDetectingGps
                                    ? null
                                    : () async {
                                        setModalState(() => isDetectingGps = true);
                                        final loc = ref.read(locationServiceProvider);
                                        final res = await loc.requestPosition();
                                        if (res.isSuccess) {
                                          setModalState(() {
                                            updatedLat = res.latitude;
                                            updatedLon = res.longitude;
                                            isDetectingGps = false;
                                            gpsMsg = 'Farm GPS Updated ✓';
                                          });
                                        } else {
                                          setModalState(() {
                                            isDetectingGps = false;
                                            gpsMsg = res.errorMessage ?? 'Permission denied';
                                          });
                                        }
                                      },
                                child: Text(
                                  isDetectingGps ? 'Detecting...' : 'Update GPS',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.gapV10,
                        AppDropdown<String>(
                          label: 'State',
                          value: selectedState,
                          items: const [
                            DropdownMenuItem(value: 'Andhra Pradesh', child: Text('Andhra Pradesh')),
                            DropdownMenuItem(value: 'Bihar', child: Text('Bihar')),
                            DropdownMenuItem(value: 'Chhattisgarh', child: Text('Chhattisgarh')),
                            DropdownMenuItem(value: 'Gujarat', child: Text('Gujarat')),
                            DropdownMenuItem(value: 'Haryana', child: Text('Haryana')),

                            DropdownMenuItem(value: 'Karnataka', child: Text('Karnataka')),
                            DropdownMenuItem(value: 'Madhya Pradesh', child: Text('Madhya Pradesh')),
                            DropdownMenuItem(value: 'Maharashtra', child: Text('Maharashtra')),
                            DropdownMenuItem(value: 'Odisha', child: Text('Odisha')),
                            DropdownMenuItem(value: 'Punjab', child: Text('Punjab')),
                            DropdownMenuItem(value: 'Rajasthan', child: Text('Rajasthan')),
                            DropdownMenuItem(value: 'Tamil Nadu', child: Text('Tamil Nadu')),
                            DropdownMenuItem(value: 'Telangana', child: Text('Telangana')),
                            DropdownMenuItem(value: 'Uttar Pradesh', child: Text('Uttar Pradesh')),
                            DropdownMenuItem(value: 'West Bengal', child: Text('West Bengal')),
                          ],
                          onChanged: (v) {
                            if (v != null) setModalState(() => selectedState = v);
                          },
                        ),
                        AppSpacing.gapV12,
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'District',
                                controller: districtCtrl,
                                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                              ),
                            ),
                            AppSpacing.gapH10,
                            Expanded(
                              child: AppTextField(
                                label: 'Village / Mandal',
                                controller: villageCtrl,
                                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapV12,
                        AppTextField(
                          label: 'Pincode (Optional)',
                          controller: pincodeCtrl,
                          keyboardType: TextInputType.number,
                        ),
                        AppSpacing.gapV16,

                        // Farm Parameters Section
                        _buildModalSectionHeader('2. Landholding & Irrigation', Icons.landscape_outlined),
                        AppSpacing.gapV10,
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppTextField(
                                label: 'Landholding Size',
                                controller: landAreaCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Enter valid number' : null,
                              ),
                            ),
                            AppSpacing.gapH10,
                            Expanded(
                              flex: 2,
                              child: AppDropdown<String>(
                                label: 'Unit',
                                value: areaUnit,
                                items: const [
                                  DropdownMenuItem(value: 'Acres', child: Text('Acres')),
                                  DropdownMenuItem(value: 'Hectares', child: Text('Hectares')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setModalState(() => areaUnit = v);
                                },
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapV12,
                        AppDropdown<String>(
                          label: 'Irrigation System',
                          value: irrigation,
                          items: const [
                            DropdownMenuItem(value: 'Borewell', child: Text('Borewell')),
                            DropdownMenuItem(value: 'Canal', child: Text('Canal')),
                            DropdownMenuItem(value: 'Drip Irrigation', child: Text('Drip Irrigation')),
                            DropdownMenuItem(value: 'Sprinkler', child: Text('Sprinkler')),
                            DropdownMenuItem(value: 'Rainfed', child: Text('Rainfed')),
                          ],
                          onChanged: (v) {
                            if (v != null) setModalState(() => irrigation = v);
                          },
                        ),
                        AppSpacing.gapV12,
                        AppTextField(
                          label: 'Farming Experience (Years)',
                          controller: expCtrl,
                          keyboardType: TextInputType.number,
                        ),
                        AppSpacing.gapV16,

                        // Soil & Crop Parameters Section
                        _buildModalSectionHeader('3. Soil Health & Primary Crop', Icons.science_outlined),
                        AppSpacing.gapV10,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: AppRadius.radiusMd,
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Soil Health Card Available',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            subtitle: const Text(
                              'Include N-P-K nutrient & pH lab values',
                              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                            ),
                            value: hasReport,
                            activeThumbColor: AppColors.primary,
                            activeTrackColor: AppColors.sage,
                            onChanged: (v) => setModalState(() => hasReport = v),
                          ),
                        ),
                        AppSpacing.gapV12,
                        if (hasReport) ...[
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Nitrogen (N)',
                                  controller: nCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              AppSpacing.gapH8,
                              Expanded(
                                child: AppTextField(
                                  label: 'Phosphorus (P)',
                                  controller: pCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              AppSpacing.gapH8,
                              Expanded(
                                child: AppTextField(
                                  label: 'Potassium (K)',
                                  controller: kCtrl,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapV10,
                          AppTextField(
                            label: 'Soil pH Level (e.g. 6.5)',
                            controller: phCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ] else ...[
                          AppDropdown<String>(
                            label: 'Primary Soil Type',
                            value: soilType,
                            items: const [
                              DropdownMenuItem(value: 'Black Cotton Soil', child: Text('Black Cotton Soil')),
                              DropdownMenuItem(value: 'Red Sandy Loam', child: Text('Red Sandy Loam')),
                              DropdownMenuItem(value: 'Alluvial Soil', child: Text('Alluvial Soil')),
                              DropdownMenuItem(value: 'Clayey Soil', child: Text('Clayey Soil')),
                              DropdownMenuItem(value: 'Laterite Soil', child: Text('Laterite Soil')),
                              DropdownMenuItem(value: 'Sandy Loam', child: Text('Sandy Loam')),
                              DropdownMenuItem(value: 'Other / General Soil', child: Text('Other / General Soil')),
                            ],
                            onChanged: (v) {
                              if (v != null) setModalState(() => soilType = v);
                            },
                          ),
                        ],
                        AppSpacing.gapV12,
                        AppDropdown<String>(
                          label: 'Primary Cultivated Crop',
                          value: crop ?? 'Cotton',
                          items: const [
                            DropdownMenuItem(value: 'Cotton', child: Text('Cotton')),
                            DropdownMenuItem(value: 'Rice / Paddy', child: Text('Rice / Paddy')),
                            DropdownMenuItem(value: 'Wheat', child: Text('Wheat')),
                            DropdownMenuItem(value: 'Maize', child: Text('Maize')),
                            DropdownMenuItem(value: 'Tomato', child: Text('Tomato')),
                            DropdownMenuItem(value: 'Chilli', child: Text('Chilli')),
                            DropdownMenuItem(value: 'Groundnut', child: Text('Groundnut')),
                            DropdownMenuItem(value: 'Sugarcane', child: Text('Sugarcane')),
                          ],
                          onChanged: (v) {
                            if (v != null) setModalState(() => crop = v);
                          },
                        ),
                        AppSpacing.gapV24,

                        AppButton(
                          label: 'Save Changes',
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            final updated = profile.copyWith(
                              location: profile.location.copyWith(
                                state: selectedState,
                                district: districtCtrl.text.trim(),
                                village: villageCtrl.text.trim(),
                                pincode: pincodeCtrl.text.trim().isNotEmpty ? pincodeCtrl.text.trim() : null,
                                latitude: updatedLat,
                                longitude: updatedLon,
                              ),

                              farmDetails: profile.farmDetails.copyWith(
                                landArea: double.tryParse(landAreaCtrl.text.trim()) ?? profile.farmDetails.landArea,
                                areaUnit: areaUnit,
                                hasSoilReport: hasReport,
                                soilType: hasReport ? null : soilType,
                                nitrogen: hasReport ? double.tryParse(nCtrl.text.trim()) : null,
                                phosphorus: hasReport ? double.tryParse(pCtrl.text.trim()) : null,
                                potassium: hasReport ? double.tryParse(kCtrl.text.trim()) : null,
                                ph: hasReport ? double.tryParse(phCtrl.text.trim()) : null,
                                irrigationType: irrigation,
                                primaryCrop: crop,
                                farmingExperienceYears: int.tryParse(expCtrl.text.trim()),
                              ),
                              updatedAt: DateTime.now(),
                            );

                            await ref.read(authNotifierProvider.notifier).updateProfile(updated);
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Farm profile updated successfully!'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            }
                          },
                        ),
                        AppSpacing.gapV24,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final activeLang = ref.watch(localeNotifierProvider);
    final user = authState.user;
    final profile = authState.profile;

    final farmerName = user?.fullName.isNotEmpty == true ? user!.fullName : 'Farmer Rajesh Sharma';
    final farmerPhone = user?.phoneNumber.isNotEmpty == true ? user!.phoneNumber : '9876543210';
    final locationText = profile != null ? profile.location.summary : 'Nandyal, Kurnool, Andhra Pradesh';
    final landText = profile != null ? profile.farmDetails.landAreaSummary : '5.2 Acres';
    final soilText = profile != null ? profile.farmDetails.soilSummary : 'Red Sandy Loam (pH 6.5)';
    final irrigationText = profile != null ? profile.farmDetails.irrigationType : 'Borewell';
    final cropText = profile?.farmDetails.primaryCrop ?? 'Cotton / Chilli';
    final experienceYears = profile?.farmDetails.farmingExperienceYears ?? 12;

    // Land category calculation
    final landArea = profile?.farmDetails.landArea ?? 5.2;
    String landCategory = 'Small';
    if (landArea < 2.5) {
      landCategory = 'Marginal';
    } else if (landArea <= 5.0) {
      landCategory = 'Small';
    } else if (landArea <= 10.0) {
      landCategory = 'Medium';
    } else {
      landCategory = 'Large';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  // 1. Premium Hero Identity Card
                  _buildHeroFarmerCard(
                    context: context,
                    farmerName: farmerName,
                    farmerPhone: farmerPhone,
                    locationText: locationText,
                    profile: profile,
                  ),
                  AppSpacing.gapV16,

                  // 2. 4-Metric Key Farm Overview Grid
                  _buildMetricsGrid(
                    landText: landText,
                    landCategory: landCategory,
                    cropText: cropText,
                    soilText: soilText,
                    irrigationText: irrigationText,
                    profile: profile,
                  ),
                  AppSpacing.gapV16,

                  // 3. Precision Soil Health & NPK Visualizer Card
                  _buildSoilHealthVisualizerCard(context, profile),
                  AppSpacing.gapV16,

                  // 4. Detailed Farm & Operational Specifications Card
                  _buildFarmSpecificationsCard(
                    context: context,
                    profile: profile,
                    farmerName: farmerName,
                    locationText: locationText,
                    landText: landText,
                    soilText: soilText,
                    irrigationText: irrigationText,
                    cropText: cropText,
                    experienceYears: experienceYears,
                    activeLang: activeLang,
                  ),
                  AppSpacing.gapV16,

                  // 5. Edit CTA or Complete Setup
                  if (profile != null)
                    FarmerPrimaryButton(
                      label: 'Edit Farm Details',
                      icon: Icons.edit_outlined,
                      onPressed: () => _showEditProfileSheet(context, profile),
                    )
                  else
                    FarmerPrimaryButton(
                      label: 'Complete Farm Setup',
                      icon: Icons.app_registration,
                      onPressed: () => context.go('/profile-setup'),
                    ),
                  AppSpacing.gapV16,

                  // 6. Kisan Support Hotline Card
                  _buildSupportHotlineCard(),
                  AppSpacing.gapV16,

                  // 7. Security & Session Management Card
                  _buildSecurityCard(context),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Hero Farmer Card with evergreen gradient, verified badges, and quick edit
  Widget _buildHeroFarmerCard({
    required BuildContext context,
    required String farmerName,
    required String farmerPhone,
    required String locationText,
    required FarmerProfile? profile,
  }) {
    // Generate initials for avatar (e.g. RS for Rajesh Sharma)
    final nameParts = farmerName.trim().split(RegExp(r'\s+'));
    String initials = 'K';
    if (nameParts.length >= 2) {
      initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      initials = nameParts[0].substring(0, nameParts[0].length >= 2 ? 2 : 1).toUpperCase();
    }

    final kisanId = profile?.userId.isNotEmpty == true
        ? 'KA-${profile!.userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').padRight(4, '0').substring(0, 4).toUpperCase()}'
        : 'KA-2026';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            Color(0xFF133626),
            AppColors.forestDeep,
          ],
        ),
        borderRadius: AppRadius.radiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient circular glow
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sage.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Main Card Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Tag Row: Kisan ID & Verified Status
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: AppRadius.radiusPill,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.badge_outlined, size: 13, color: AppColors.sage),
                          const SizedBox(width: 5),
                          Text(
                            'KISAN ID: #$kisanId',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.85),
                        borderRadius: AppRadius.radiusPill,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Verified Farmer',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV16,

                // Farmer Profile Middle Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar with badge
                    Stack(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.sage.withValues(alpha: 0.6),
                              width: 2.2,
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2D6A4F),
                                Color(0xFF1B4332),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH12,

                    // Farmer Name & Contact Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.phone_iphone_rounded, size: 14, color: AppColors.sage),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '+91 $farmerPhone',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE2E8E2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.sage),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  locationText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFB7E4C7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV16,

                // Quick Action Bar on Card
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: AppRadius.radiusSm,
                        child: InkWell(
                          onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
                          borderRadius: AppRadius.radiusSm,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
                                AppSpacing.gapH6,
                                Flexible(
                                  child: Text(
                                    profile != null ? 'Edit Profile' : 'Setup Profile',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.gapH10,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: AppRadius.radiusSm,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.sage),
                          SizedBox(width: 4),
                          Text(
                            'Kharif 2026',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.sage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. 4-Metric Key Farm Overview Grid (Responsive)
  Widget _buildMetricsGrid({
    required String landText,
    required String landCategory,
    required String cropText,
    required String soilText,
    required String irrigationText,
    required FarmerProfile? profile,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        final items = [
          _MetricCardItem(
            title: 'Landholding',
            value: landText,
            badge: landCategory,
            icon: Icons.landscape_rounded,
            accentColor: AppColors.primary,
            bgColor: const Color(0xFFE8F5E9),
          ),
          _MetricCardItem(
            title: 'Primary Crop',
            value: cropText,
            badge: 'Crop',
            icon: Icons.grass_rounded,
            accentColor: const Color(0xFFB45309),
            bgColor: const Color(0xFFFFFBEB),
          ),
          _MetricCardItem(
            title: 'Soil Profile',
            value: profile?.farmDetails.ph != null
                ? 'pH ${profile!.farmDetails.ph!.toStringAsFixed(1)}'
                : (profile?.farmDetails.soilType ?? 'Red Loam'),
            badge: profile?.farmDetails.hasSoilReport == true ? 'Tested' : 'Est.',
            icon: Icons.science_rounded,
            accentColor: const Color(0xFF00796B),
            bgColor: const Color(0xFFE0F2F1),
          ),
          _MetricCardItem(
            title: 'Irrigation',
            value: irrigationText,
            badge: 'Water',
            icon: Icons.water_drop_rounded,
            accentColor: const Color(0xFF0284C7),
            bgColor: const Color(0xFFE0F2FE),
          ),
        ];

        if (isWide) {
          return Row(
            children: items.map((item) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: items.indexOf(item) < items.length - 1 ? 10.0 : 0.0,
                  ),
                  child: _buildMetricTile(item),
                ),
              );
            }).toList(),
          );
        }

        // Mobile 2x2 grid
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildMetricTile(items[0])),
                AppSpacing.gapH10,
                Expanded(child: _buildMetricTile(items[1])),
              ],
            ),
            AppSpacing.gapV10,
            Row(
              children: [
                Expanded(child: _buildMetricTile(items[2])),
                AppSpacing.gapH10,
                Expanded(child: _buildMetricTile(items[3])),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile(_MetricCardItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: item.bgColor,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(item.icon, size: 17, color: item.accentColor),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: AppRadius.radiusPill,
                  ),
                  child: Text(
                    item.badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.0,
                      fontWeight: FontWeight.w700,
                      color: item.accentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV8,
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Precision Soil Health & NPK Visualizer Card
  Widget _buildSoilHealthVisualizerCard(BuildContext context, FarmerProfile? profile) {
    final hasReport = profile?.farmDetails.hasSoilReport == true;
    final n = profile?.farmDetails.nitrogen;
    final p = profile?.farmDetails.phosphorus;
    final k = profile?.farmDetails.potassium;
    final ph = profile?.farmDetails.ph;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.biotech_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Soil Health & Nutrients',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasReport ? AppColors.successLight : AppColors.warningLight,
                  borderRadius: AppRadius.radiusPill,
                ),
                child: Text(
                  hasReport ? 'Certified' : 'Estimated',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: hasReport ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV12,

          if (hasReport && (n != null || p != null || k != null || ph != null)) ...[
            Text(
              'Government Soil Health Card linked. Precision nutrient telemetry active.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: 0.9)),
            ),
            AppSpacing.gapV14,

            // N-P-K Visualizer Bars
            _buildNutrientBar(
              label: 'Nitrogen (N)',
              value: '${n?.toStringAsFixed(0) ?? "--"} kg/ha',
              progress: ((n ?? 120) / 300).clamp(0.1, 1.0),
              status: (n ?? 120) >= 140 ? 'High' : ((n ?? 120) >= 80 ? 'Optimal' : 'Low'),
              statusColor: (n ?? 120) >= 80 ? AppColors.primary : AppColors.warning,
            ),
            AppSpacing.gapV10,
            _buildNutrientBar(
              label: 'Phosphorus (P)',
              value: '${p?.toStringAsFixed(0) ?? "--"} kg/ha',
              progress: ((p ?? 45) / 100).clamp(0.1, 1.0),
              status: (p ?? 45) >= 50 ? 'High' : ((p ?? 45) >= 25 ? 'Optimal' : 'Low'),
              statusColor: (p ?? 45) >= 25 ? AppColors.primary : AppColors.warning,
            ),
            AppSpacing.gapV10,
            _buildNutrientBar(
              label: 'Potassium (K)',
              value: '${k?.toStringAsFixed(0) ?? "--"} kg/ha',
              progress: ((k ?? 60) / 150).clamp(0.1, 1.0),
              status: (k ?? 60) >= 70 ? 'High' : ((k ?? 60) >= 40 ? 'Optimal' : 'Low'),
              statusColor: (k ?? 60) >= 40 ? AppColors.primary : AppColors.warning,
            ),
            AppSpacing.gapV10,
            _buildNutrientBar(
              label: 'pH Level',
              value: '${ph?.toStringAsFixed(1) ?? "6.5"} pH',
              progress: (((ph ?? 6.5) - 4.0) / 5.0).clamp(0.1, 1.0),
              status: ((ph ?? 6.5) >= 6.0 && (ph ?? 6.5) <= 7.5) ? 'Ideal' : ((ph ?? 6.5) < 6.0 ? 'Acidic' : 'Alkaline'),
              statusColor: ((ph ?? 6.5) >= 6.0 && (ph ?? 6.5) <= 7.5) ? AppColors.primary : AppColors.warning,
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 22, color: AppColors.primary),
                  AppSpacing.gapH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Soil Health Card Not Linked Yet',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Add your lab test N-P-K and pH values to receive pinpoint fertilizer recommendations.',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
                          child: const Text(
                            '+ Enter Soil Test Numbers',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientBar({
    required String label,
    required String value,
    required double progress,
    required String status,
    required Color statusColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '• $status',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: AppRadius.radiusPill,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.cardBorder,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),
        ),
      ],
    );
  }

  /// 4. Categorized Farm Specifications and Details Card
  Widget _buildFarmSpecificationsCard({
    required BuildContext context,
    required FarmerProfile? profile,
    required String farmerName,
    required String locationText,
    required String landText,
    required String soilText,
    required String irrigationText,
    required String cropText,
    required int experienceYears,
    required AppLanguage activeLang,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FarmerSectionHeader(title: 'Farm Details'),
        AppSpacing.gapV10,
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              FarmerInfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Farmer Name',
                value: farmerName,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Farm Location',
                value: locationText,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.landscape_outlined,
                label: 'Farm Land Size',
                value: landText,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.science_outlined,
                label: 'Soil Classification',
                value: soilText,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.water_drop_outlined,
                label: 'Irrigation Facility',
                value: irrigationText,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.eco_outlined,
                label: 'Primary Cultivated Crop',
                value: cropText,
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.work_outline_rounded,
                label: 'Farming Experience',
                value: '$experienceYears Years',
                onTap: profile != null ? () => _showEditProfileSheet(context, profile) : null,
              ),
              FarmerInfoRow(
                icon: Icons.translate_outlined,
                label: ref.tr('profile_preferred_language'),
                value: activeLang.displayName,
                showDivider: true,
                onTap: () => showLanguageSelectorSheet(context, ref),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                child: FarmerSecondaryButton(
                  label: ref.tr('profile_change_language'),
                  icon: Icons.translate,
                  height: 44,
                  onPressed: () => showLanguageSelectorSheet(context, ref),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 5. Kisan Support Hotline Card
  Widget _buildSupportHotlineCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.sageMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 20),
          ),
          AppSpacing.gapH12,
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      'Kisan Call Center Helpline',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      '• Toll-Free',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  '1800-180-1551 (6:00 AM - 10:00 PM Daily)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  'Free agronomy guidance & pest diagnosis from government scientists',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 6. Account Security Card
  Widget _buildSecurityCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Management',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV12,
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  label: 'Sign Out',
                  leadingIcon: Icons.logout,
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: AppOutlinedButton(
                  label: 'Delete Account',
                  leadingIcon: Icons.delete_forever_outlined,
                  textColor: AppColors.error,
                  borderColor: AppColors.error,
                  onPressed: () => _showDeleteAccountDialog(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCardItem {
  final String title;
  final String value;
  final String badge;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;

  const _MetricCardItem({
    required this.title,
    required this.value,
    required this.badge,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
  });
}
