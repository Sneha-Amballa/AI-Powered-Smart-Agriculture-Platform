import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// Spotlight card for Plant Disease Detection with direct photo/upload CTAs.
class DiseaseDetectionBanner extends StatelessWidget {
  const DiseaseDetectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Soft teal background
        borderRadius: AppRadius.radiusLg,
        border: Border.all(
          color: const Color(0xFF80CBC4),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF00796B),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 2,
                      children: [
                        Text(
                          'Plant Disease Detection',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF004D40),
                          ),
                        ),
                        _VisionBadge(),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Take a photo of your crop leaf to identify diseases and receive instant AI agronomic treatments.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF004D40),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV14,

          // Two Action Buttons (Take Photo / Upload Image)
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go('/disease-detection'),
                icon: const Icon(Icons.photo_camera_rounded, size: 16),
                label: const Text('Take Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 38),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusSm,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/disease-detection'),
                icon: const Icon(Icons.file_upload_outlined, size: 16),
                label: const Text('Upload Image'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF004D40),
                  side: const BorderSide(color: Color(0xFF00796B), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 38),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusSm,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisionBadge extends StatelessWidget {
  const _VisionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF00796B).withValues(alpha: 0.15),
        borderRadius: AppRadius.radiusPill,
      ),
      child: const Text(
        'VISION AI',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: Color(0xFF00796B),
        ),
      ),
    );
  }
}
