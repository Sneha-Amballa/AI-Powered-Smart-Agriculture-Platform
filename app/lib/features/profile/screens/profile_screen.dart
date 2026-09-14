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
import '../../authentication/domain/models/farmer_profile_model.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// Complete live farmer profile screen with editing capabilities and secure logout.
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
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your farmer account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
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

  void _showEditProfileSheet(BuildContext context, FarmerProfile profile) {
    final formKey = GlobalKey<FormState>();
    final districtCtrl = TextEditingController(text: profile.location.district);
    final villageCtrl = TextEditingController(text: profile.location.village);
    final pincodeCtrl = TextEditingController(text: profile.location.pincode ?? '');
    final landAreaCtrl = TextEditingController(text: profile.farmDetails.landArea.toString());
    final expCtrl = TextEditingController(text: profile.farmDetails.farmingExperienceYears?.toString() ?? '');

    String selectedState = profile.location.state;
    String areaUnit = profile.farmDetails.areaUnit;
    String irrigation = profile.farmDetails.irrigationType;
    String? crop = profile.farmDetails.primaryCrop;
    bool hasReport = profile.farmDetails.hasSoilReport;
    String soilType = profile.farmDetails.soilType ?? 'Black Cotton Soil';

    final nCtrl = TextEditingController(text: profile.farmDetails.nitrogen?.toString() ?? '');
    final pCtrl = TextEditingController(text: profile.farmDetails.phosphorus?.toString() ?? '');
    final kCtrl = TextEditingController(text: profile.farmDetails.potassium?.toString() ?? '');
    final phCtrl = TextEditingController(text: profile.farmDetails.ph?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Edit Farm Profile',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        const Divider(),
                        AppSpacing.gapV12,

                        // Location
                        const Text('Location Details', style: TextStyle(fontWeight: FontWeight.w700)),
                        AppSpacing.gapV8,
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
                        AppTextField(
                          label: 'District',
                          controller: districtCtrl,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        AppSpacing.gapV12,
                        AppTextField(
                          label: 'Village / Mandal',
                          controller: villageCtrl,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        AppSpacing.gapV12,
                        AppTextField(
                          label: 'Pincode',
                          controller: pincodeCtrl,
                          keyboardType: TextInputType.number,
                        ),
                        AppSpacing.gapV16,

                        // Farm details
                        const Text('Farm Parameters', style: TextStyle(fontWeight: FontWeight.w700)),
                        AppSpacing.gapV8,
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppTextField(
                                label: 'Land Area',
                                controller: landAreaCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (v) => (v == null || double.tryParse(v) == null) ? 'Invalid' : null,
                              ),
                            ),
                            AppSpacing.gapH12,
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
                        AppSpacing.gapV16,

                        // Soil
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Soil Health Report Available'),
                          value: hasReport,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => setModalState(() => hasReport = v),
                        ),
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
                          AppSpacing.gapV12,
                          AppTextField(
                            label: 'pH Level',
                            controller: phCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ] else ...[
                          AppDropdown<String>(
                            label: 'Soil Type',
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
                        AppSpacing.gapV16,

                        // Irrigation & Crop
                        AppDropdown<String>(
                          label: 'Irrigation Facility',
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
                        AppSpacing.gapV16,
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
                        AppSpacing.gapV16,
                        AppTextField(
                          label: 'Farming Experience (Years)',
                          controller: expCtrl,
                          keyboardType: TextInputType.number,
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
                                const SnackBar(content: Text('Farm profile updated successfully!')),
                              );
                            }
                          },
                        ),
                        AppSpacing.gapV20,
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profile = authState.profile;

    final farmerName = user?.fullName.isNotEmpty == true ? user!.fullName : 'Farmer Rajesh Sharma';
    final farmerPhone = user?.phoneNumber.isNotEmpty == true ? user!.phoneNumber : '9876543210';
    final locationText = profile != null ? profile.location.summary : 'Nandyal, Kurnool, Andhra Pradesh';
    final landText = profile != null ? profile.farmDetails.landAreaSummary : '5.2 Acres';
    final soilText = profile != null ? profile.farmDetails.soilSummary : 'Red Sandy Loam (pH 6.5)';
    final irrigationText = profile != null ? profile.farmDetails.irrigationType : 'Borewell';
    final cropText = profile?.farmDetails.primaryCrop ?? 'Cotton / Chilli';
    final expText = profile?.farmDetails.farmingExperienceYears != null
        ? '${profile!.farmDetails.farmingExperienceYears} Years'
        : '12 Years';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.sage,
                      child: Icon(Icons.person, size: 42, color: AppColors.primaryDark),
                    ),
                    AppSpacing.gapV12,
                    Text(
                      farmerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    AppSpacing.gapV4,
                    Text(
                      '+91 $farmerPhone • $locationText',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    AppSpacing.gapV16,
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        if (profile != null) ...[
                          AppOutlinedButton(
                            label: 'Edit Farm Info',
                            leadingIcon: Icons.edit_outlined,
                            onPressed: () => _showEditProfileSheet(context, profile),
                          ),
                        ] else ...[
                          AppButton(
                            label: 'Complete Setup',
                            leadingIcon: Icons.app_registration,
                            onPressed: () => context.go('/profile-setup'),
                          ),
                        ],
                        AppOutlinedButton(
                          label: 'Sign Out',
                          leadingIcon: Icons.logout,
                          textColor: AppColors.error,
                          borderColor: AppColors.error,
                          onPressed: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                    AppSpacing.gapV20,
                    const Divider(height: 1),
                    AppSpacing.gapV16,

                    _buildProfileItem(Icons.landscape_outlined, 'Farm Land Size', landText),
                    _buildProfileItem(Icons.science_outlined, 'Soil Classification', soilText),
                    _buildProfileItem(Icons.water_drop_outlined, 'Irrigation Facility', irrigationText),
                    _buildProfileItem(Icons.eco_outlined, 'Primary Cultivated Crop', cropText),
                    _buildProfileItem(Icons.history_outlined, 'Farming Experience', expText),
                    _buildProfileItem(Icons.translate_outlined, 'Preferred Language', 'English / Regional'),

                    AppSpacing.gapV16,
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppRadius.radiusMd,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.phone_in_talk, size: 22, color: AppColors.primary),
                          AppSpacing.gapH12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kisan Call Center Helpline',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '1800-180-1551 • Free Expert Agronomist Support (6 AM - 10 PM)',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.5),
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                AppSpacing.gapV2,
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

