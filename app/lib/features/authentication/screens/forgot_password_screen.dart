import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/layouts/app_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_outlined_button.dart';

/// Password recovery information screen providing official Kisan Helpline support.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      onBackPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/login');
        }
      },
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppLogo(size: 40)),
                AppSpacing.gapV20,
                const Text(
                  'Password Assistance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV8,
                const Text(
                  'Self-service SMS password reset is being enhanced for maximum security and will be released in an upcoming update.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                AppSpacing.gapV24,

                // Kisan Toll-Free Card
                AppCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.sage.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.support_agent_outlined,
                          size: 32,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      AppSpacing.gapV12,
                      const Text(
                        'Kisan Call Center (KCC)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      AppSpacing.gapV4,
                      const Text(
                        'Government of India Agricultural Helpline',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      AppSpacing.gapV16,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_in_talk, color: AppColors.primary, size: 22),
                            AppSpacing.gapH8,
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '1800-180-1551',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gapV12,
                      const Text(
                        'Toll-Free • 6:00 AM - 10:00 PM • All 7 Days • In 22 Local Languages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapV20,

                // Alternative: Re-register hint
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                      AppSpacing.gapH12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Need Immediate Advisory Access?',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            AppSpacing.gapV2,
                            const Text(
                              'You can register a new profile with your farm details to immediately access crop recommendations.',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapV24,

                AppButton(
                  label: 'Back to Sign In',
                  onPressed: () => context.go('/login'),
                ),
                AppSpacing.gapV12,
                AppOutlinedButton(
                  label: 'Register New Account',
                  onPressed: () => context.go('/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

