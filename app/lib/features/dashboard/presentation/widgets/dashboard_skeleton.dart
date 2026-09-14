import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// Clean skeleton placeholder during initial dashboard loading.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Skeleton
              Row(
                children: [
                  _shimmerBox(width: 48, height: 48, radius: AppRadius.radiusPill),
                  AppSpacing.gapH12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 160, height: 18),
                        AppSpacing.gapV4,
                        _shimmerBox(width: 220, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV20,

              // Advisory Centerpiece Skeleton
              _shimmerBox(height: 160, radius: AppRadius.radiusXl),
              AppSpacing.gapV20,

              // Weather + Crop Row Skeleton
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 640) {
                    return Row(
                      children: [
                        Expanded(child: _shimmerBox(height: 180)),
                        AppSpacing.gapH12,
                        Expanded(child: _shimmerBox(height: 180)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _shimmerBox(height: 180),
                      AppSpacing.gapV12,
                      _shimmerBox(height: 180),
                    ],
                  );
                },
              ),
              AppSpacing.gapV20,

              // Market Skeleton
              _shimmerBox(height: 140),
              AppSpacing.gapV20,

              // Quick Actions Grid Skeleton
              _shimmerBox(height: 130),
              AppSpacing.gapV20,

              // Activity Skeleton
              _shimmerBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double? width,
    required double height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardBorder.withValues(alpha: 0.5),
        borderRadius: radius ?? AppRadius.radiusLg,
      ),
    );
  }
}
