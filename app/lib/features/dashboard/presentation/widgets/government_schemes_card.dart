import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/dashboard_data.dart';

/// Compact government schemes summary showing farmer eligibility highlights.
class GovernmentSchemesCard extends StatelessWidget {
  final GovernmentSchemeSummary schemes;

  const GovernmentSchemesCard({
    super.key,
    required this.schemes,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.go('/government-schemes'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      size: 18,
                      color: Color(0xFFC2185B), // Deep rose
                    ),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        'Government Support & Subsidies',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC),
                  borderRadius: AppRadius.radiusPill,
                ),
                child: Text(
                  '${schemes.eligibleCount} ELIGIBLE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFC2185B),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapV8,
          Text(
            schemes.note,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          AppSpacing.gapV12,

          // Scheme pills
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: schemes.highlightSchemes.map((scheme) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadius.radiusSm,
                  border: Border.all(color: AppColors.cardBorder, width: 0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_outlined,
                      size: 13,
                      color: Color(0xFFC2185B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scheme,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          AppSpacing.gapV10,

          // Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.go('/government-schemes'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              label: const Text(
                'View All Schemes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
