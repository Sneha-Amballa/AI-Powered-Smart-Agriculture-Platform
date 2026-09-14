import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

/// Entry banner connecting farmers directly to the Kisan AI Agriculture Assistant.
class AssistantEntryCard extends StatelessWidget {
  const AssistantEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // Soft indigo background
        borderRadius: AppRadius.radiusLg,
        border: Border.all(
          color: const Color(0xFFC5CAE9),
          width: 1.1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 420;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: const Icon(
                        Icons.forum_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    AppSpacing.gapH12,
                    const Expanded(
                      child: Text(
                        'Ask your Agriculture Assistant',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV8,
                const Text(
                  'Have a question about your crop, weather, disease, or market?',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF283593),
                    height: 1.3,
                  ),
                ),
                AppSpacing.gapV12,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/assistant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.radiusSm,
                      ),
                    ),
                    child: const Text('Ask AgriAI'),
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E),
                  borderRadius: AppRadius.radiusMd,
                ),
                child: const Icon(
                  Icons.forum_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ask your Agriculture Assistant',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Have a question about your crop, weather, disease, or market?',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF283593),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH10,
              ElevatedButton(
                onPressed: () => context.go('/assistant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: const Size(0, 36),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusSm,
                  ),
                ),
                child: const Text('Ask AgriAI'),
              ),
            ],
          );
        },
      ),
    );
  }
}
