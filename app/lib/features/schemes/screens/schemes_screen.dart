import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';

/// Mobile-first Government Schemes & Subsidies screen designed for farmer accessibility.
class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All Schemes', 'Direct Cash', 'Insurance', 'Irrigation'];

  final List<_SchemeItem> _allSchemes = const [
    _SchemeItem(
      title: 'PM-KISAN Samman Nidhi',
      benefit: '₹6,000 / year in 3 installments',
      eligibility: 'All landholding farmer families across India',
      badge: 'DIRECT BENEFIT',
      badgeColor: AppColors.primary,
      icon: Icons.currency_rupee,
      categoryIndex: 1,
    ),
    _SchemeItem(
      title: 'PM Fasal Bima Yojana (PMFBY)',
      benefit: 'Comprehensive crop loss cover (1.5% premium)',
      eligibility: 'Food crops, oilseeds, and annual commercial crops',
      badge: 'INSURANCE',
      badgeColor: Color(0xFF0277BD),
      icon: Icons.shield_outlined,
      categoryIndex: 2,
    ),
    _SchemeItem(
      title: 'PM Krishi Sinchayee Yojana',
      benefit: 'Up to 55% subsidy on drip & sprinkler systems',
      eligibility: 'Farmers having cultivable land with water source',
      badge: 'SUBSIDY',
      badgeColor: Color(0xFFC2185B),
      icon: Icons.water_drop_outlined,
      categoryIndex: 3,
    ),
    _SchemeItem(
      title: 'Kisan Credit Card (KCC)',
      benefit: 'Concessional crop loans at 4% effective interest',
      eligibility: 'Owner cultivators, tenant farmers, and SHGs',
      badge: 'CREDIT',
      badgeColor: Color(0xFF6A1B9A),
      icon: Icons.credit_card_outlined,
      categoryIndex: 1,
    ),
  ];

  void _showSchemeDetails(_SchemeItem scheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(scheme.icon, color: scheme.badgeColor, size: 24),
                AppSpacing.gapH10,
                Expanded(
                  child: Text(
                    scheme.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            AppSpacing.gapV12,
            Text(
              'Benefit: ${scheme.benefit}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            AppSpacing.gapV8,
            Text(
              'Eligibility: ${scheme.eligibility}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            AppSpacing.gapV16,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.radiusMd,
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone, size: 18, color: AppColors.primary),
                  AppSpacing.gapH8,
                  Expanded(
                    child: Text(
                      'Toll-Free Kisan Call Center: 1800-180-1551 (6 AM - 10 PM)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapV16,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schemes = _selectedCategory == 0
        ? _allSchemes
        : _allSchemes.where((s) => s.categoryIndex == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Summary Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.schemes,
                        size: 42,
                        primaryColor: Color(0xFFC2185B),
                        secondaryColor: Color(0xFFFCE4EC),
                      ),
                    ),
                    AppSpacing.gapH14,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Government Schemes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          AppSpacing.gapV2,
                          Text(
                            'Subsidies, PM-KISAN, & Crop Insurance',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const AppBadge(label: 'GOV AID', variant: BadgeVariant.neutral),
                  ],
                ),
              ),
              AppSpacing.gapV14,

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _categories.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(_categories[index]),
                        selected: _selectedCategory == index,
                        selectedColor: const Color(0xFFC2185B),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedCategory == index ? Colors.white : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.surface,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapV14,

              // Scheme Cards
              for (final scheme in schemes) ...[
                _buildSchemeCard(scheme),
                AppSpacing.gapV10,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(_SchemeItem scheme) {
    return AppCard(
      onTap: () => _showSchemeDetails(scheme),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.badgeColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(scheme.icon, size: 20, color: scheme.badgeColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.badgeColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.radiusPill,
                ),
                child: Text(
                  scheme.badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: scheme.badgeColor,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV10,
          Text(
            scheme.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV4,
          Text(
            scheme.benefit,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.gapV2,
          Text(
            scheme.eligibility,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _SchemeItem {
  final String title;
  final String benefit;
  final String eligibility;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final int categoryIndex;

  const _SchemeItem({
    required this.title,
    required this.benefit,
    required this.eligibility,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.categoryIndex,
  });
}
