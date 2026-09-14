import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_outlined_button.dart';

/// Mobile-first Plant Disease Detection screen designed for farmer accessibility.
class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  void _showNotice(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action will be activated with camera integration in the upcoming release.'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
              // Hero Visual Card
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF00796B).withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.disease,
                        size: 58,
                        primaryColor: Color(0xFF00796B),
                        secondaryColor: Color(0xFFE0F2F1),
                      ),
                    ),
                    AppSpacing.gapV16,
                    const Text(
                      'Plant Disease Detection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    AppSpacing.gapV6,
                    const AppBadge(
                      label: 'CAMERA SCAN • COMING SOON',
                      variant: BadgeVariant.info,
                    ),
                    AppSpacing.gapV12,
                    const Text(
                      'Take a clear picture of diseased crop leaves for fast AI diagnosis and treatment remedies.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    AppSpacing.gapV24,
                    // Action buttons
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 420;
                        return isNarrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AppButton(
                                    label: 'Take Photo of Leaf',
                                    leadingIcon: Icons.camera_alt_outlined,
                                    backgroundColor: const Color(0xFF00796B),
                                    foregroundColor: Colors.white,
                                    onPressed: () => _showNotice(context, 'Leaf camera scan'),
                                  ),
                                  AppSpacing.gapV12,
                                  AppOutlinedButton(
                                    label: 'Choose from Gallery',
                                    leadingIcon: Icons.photo_library_outlined,
                                    borderColor: const Color(0xFF00796B),
                                    textColor: const Color(0xFF00796B),
                                    onPressed: () => _showNotice(context, 'Gallery upload'),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label: 'Take Photo of Leaf',
                                      leadingIcon: Icons.camera_alt_outlined,
                                      backgroundColor: const Color(0xFF00796B),
                                      foregroundColor: Colors.white,
                                      onPressed: () => _showNotice(context, 'Leaf camera scan'),
                                    ),
                                  ),
                                  AppSpacing.gapH12,
                                  Expanded(
                                    child: AppOutlinedButton(
                                      label: 'Choose from Gallery',
                                      leadingIcon: Icons.photo_library_outlined,
                                      borderColor: const Color(0xFF00796B),
                                      textColor: const Color(0xFF00796B),
                                      onPressed: () => _showNotice(context, 'Gallery upload'),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Simple 3-Step Photo Guide
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Photo Tips for High Accuracy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV12,
                    _buildTipRow(Icons.wb_sunny_outlined, 'Bright Daylight', 'Ensure leaf is well-lit without dark shadows.'),
                    AppSpacing.gapV10,
                    _buildTipRow(Icons.center_focus_strong_outlined, 'Close Focus', 'Hold phone 15-20 cm away from spots.'),
                    AppSpacing.gapV10,
                    _buildTipRow(Icons.grass_outlined, 'Single Leaf', 'Focus on one diseased leaf at a time.'),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Supported Crops
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Supported Crops in Next Release',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV12,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _CropChip('Tomato', Icons.eco),
                        _CropChip('Rice Paddy', Icons.grass),
                        _CropChip('Cotton', Icons.spa),
                        _CropChip('Potato', Icons.circle_outlined),
                        _CropChip('Corn / Maize', Icons.grain),
                        _CropChip('Wheat', Icons.yard),
                      ],
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

  Widget _buildTipRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF00796B)),
        ),
        AppSpacing.gapH12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CropChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CropChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.radiusPill,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          AppSpacing.gapH6,
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
