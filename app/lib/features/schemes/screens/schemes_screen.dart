import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/farmer_components.dart';

class _SchemeItem {
  final String title;
  final String category;
  final String benefit;
  final String eligibility;
  final String deadline;
  final String status;

  const _SchemeItem({
    required this.title,
    required this.category,
    required this.benefit,
    required this.eligibility,
    required this.deadline,
    required this.status,
  });
}

const List<_SchemeItem> _schemes = [
  _SchemeItem(
    title: 'PM-KISAN Samman Nidhi',
    category: 'Direct Income Support',
    benefit: '₹6,000 / year in 3 direct bank transfers of ₹2,000 each',
    eligibility: 'All landholding farmer families with cultivable land',
    deadline: 'Ongoing • Next installment in October',
    status: 'Eligible',
  ),
  _SchemeItem(
    title: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
    category: 'Crop Insurance',
    benefit: 'Comprehensive loss cover for Kharif cotton & foodgrains at 2% premium',
    eligibility: 'Farmers cultivating notified crops in notified areas',
    deadline: 'July 31 for Kharif season',
    status: 'Enrolled',
  ),
  _SchemeItem(
    title: 'Per Drop More Crop (Drip & Sprinkler)',
    category: 'Irrigation Subsidy',
    benefit: '55% subsidy for small & marginal farmers on drip irrigation sets',
    eligibility: 'Farmers with borewell/canal water source and land title',
    deadline: 'Open year-round at District Agri Office',
    status: 'Eligible',
  ),
  _SchemeItem(
    title: 'Kisan Credit Card (KCC) Low-Interest Loan',
    category: 'Credit Facility',
    benefit: 'Short-term credit at 4% effective interest rate with prompt repayment',
    eligibility: 'All farmers, tenant farmers, and oral lessees',
    deadline: 'Apply at any rural bank branch',
    status: 'Eligible',
  ),
];

/// Farmer-first Government Schemes and Subsidies screen.
/// Implements "See → Understand → Act":
/// 1. What is happening? (Subsidies available for your farm)
/// 2. What does it mean for my farm? (Exact financial benefit)
/// 3. What should I do? (Clear 1-tap claim steps and Helpline)
class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  void _showSchemeDetails(BuildContext context, _SchemeItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppSpacing.gapV16,
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV4,
              Text(
                item.category,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.gapV14,
              _buildDetailRow('Financial Benefit', item.benefit),
              AppSpacing.gapV10,
              _buildDetailRow('Eligibility', item.eligibility),
              AppSpacing.gapV10,
              _buildDetailRow('Application Timing', item.deadline),
              AppSpacing.gapV16,
              const Text(
                'Required Documents:',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                '1. Aadhaar Card linked with mobile\n2. Bank passbook with active DBT\n3. Land record (7/12 or RoR / Khasra)',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              AppSpacing.gapV20,
              FarmerPrimaryButton(
                label: 'Call Kisan Helpline (1800-180-1551)',
                icon: Icons.phone,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const schemesSummary =
        'Government agricultural subsidies: You are eligible for PM-KISAN, Crop Insurance, and 55% Drip Irrigation subsidy.';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title / Identifier
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Government Schemes & Grants',
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
                      const FarmerVoiceButton(textToSpeak: schemesSummary),
                    ],
                  ),
                  AppSpacing.gapV2,
                  const Text(
                    'Central & State agriculture subsidies matched for your landholding',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapV16,

                  // Kisan Call Center Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: AppRadius.radiusMd,
                      border: Border.all(color: const Color(0xFFA5D6A7)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.headset_mic_rounded, color: AppColors.primaryDark, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Free Agronomist & Scheme Assistance',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                'Call Toll-Free 1800-180-1551 (6:00 AM - 10:00 PM)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV16,

                  // Scheme Cards List
                  const FarmerSectionHeader(title: 'Recommended Subsidies'),
                  AppSpacing.gapV10,
                  ..._schemes.map((item) => _buildSchemeCard(context, item)),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, _SchemeItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () => _showSchemeDetails(context, item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: AppRadius.radiusPill,
                    border: Border.all(color: const Color(0xFFA5D6A7)),
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapV6,
            Text(
              item.benefit,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            AppSpacing.gapV8,
            Row(
              children: [
                const Icon(Icons.schedule, size: 13, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.deadline,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
