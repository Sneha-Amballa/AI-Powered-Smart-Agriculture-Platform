import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_outlined_button.dart';

/// Mobile-first Pest Identification screen designed for farmer accessibility.
class PestDetectionScreen extends StatelessWidget {
  const PestDetectionScreen({super.key});

  void _showNotice(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action will be activated with pest scan models in the upcoming release.'),
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
                        color: const Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE65100).withValues(alpha: 0.2)),
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.pest,
                        size: 58,
                        primaryColor: Color(0xFFE65100),
                        secondaryColor: Color(0xFFFFF3E0),
                      ),
                    ),
                    AppSpacing.gapV16,
                    const Text(
                      'Pest Identification',
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
                      label: 'PEST SHIELD • COMING SOON',
                      variant: BadgeVariant.neutral,
                    ),
                    AppSpacing.gapV12,
                    const Text(
                      'Scan insects or larvae on your crops to identify pest species and receive safe remedy recommendations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    AppSpacing.gapV24,
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 420;
                        return isNarrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AppButton(
                                    label: 'Scan Pest in Field',
                                    leadingIcon: Icons.camera_alt_outlined,
                                    backgroundColor: const Color(0xFFE65100),
                                    foregroundColor: Colors.white,
                                    onPressed: () => _showNotice(context, 'Pest field scan'),
                                  ),
                                  AppSpacing.gapV12,
                                  AppOutlinedButton(
                                    label: 'Upload Bug Photo',
                                    leadingIcon: Icons.photo_library_outlined,
                                    borderColor: const Color(0xFFE65100),
                                    textColor: const Color(0xFFE65100),
                                    onPressed: () => _showNotice(context, 'Bug photo upload'),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      label: 'Scan Pest in Field',
                                      leadingIcon: Icons.camera_alt_outlined,
                                      backgroundColor: const Color(0xFFE65100),
                                      foregroundColor: Colors.white,
                                      onPressed: () => _showNotice(context, 'Pest field scan'),
                                    ),
                                  ),
                                  AppSpacing.gapH12,
                                  Expanded(
                                    child: AppOutlinedButton(
                                      label: 'Upload Bug Photo',
                                      leadingIcon: Icons.photo_library_outlined,
                                      borderColor: const Color(0xFFE65100),
                                      textColor: const Color(0xFFE65100),
                                      onPressed: () => _showNotice(context, 'Bug photo upload'),
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

              // Common Target Pests
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Common Crop Pests Identified',
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
                        _PestChip('Fall Armyworm', Icons.bug_report),
                        _PestChip('Aphids & Thrips', Icons.coronavirus),
                        _PestChip('Bollworm', Icons.pest_control),
                        _PestChip('Whitefly', Icons.air),
                        _PestChip('Stem Borer', Icons.grass),
                        _PestChip('Leafminer', Icons.spa),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Organic Remedy Guide
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Integrated Pest Management (IPM)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV12,
                    _buildRemedyRow(Icons.eco_outlined, 'Neem Oil Spray', '5ml per liter water for early sucking pests.'),
                    AppSpacing.gapV10,
                    _buildRemedyRow(Icons.lightbulb_outline, 'Yellow Sticky Traps', 'Install 6-8 traps per acre for whiteflies and aphids.'),
                    AppSpacing.gapV10,
                    _buildRemedyRow(Icons.shield_outlined, 'Pheromone Traps', 'Early monitoring for bollworm and borer moths.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemedyRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Icon(icon, size: 18, color: const Color(0xFFE65100)),
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

class _PestChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PestChip(this.label, this.icon);

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
          Icon(icon, size: 14, color: const Color(0xFFE65100)),
          AppSpacing.gapH6,
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
