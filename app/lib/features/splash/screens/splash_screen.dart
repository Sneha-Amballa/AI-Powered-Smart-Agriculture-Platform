import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../authentication/presentation/providers/auth_provider.dart';
import '../../authentication/presentation/providers/auth_state.dart';

/// Professional splash screen with elegant branding and session checking.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Transition based on restored auth session
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        final authState = authStateListenable.value;
        if (authState.status == AuthStatus.profileComplete) {
          context.go('/dashboard');
        } else if (authState.status == AuthStatus.profileIncomplete) {
          context.go('/profile-setup');
        } else {
          context.go('/');
        }
      }
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadius.radiusXl,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.eco,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                        AppSpacing.gapV24,
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              TextSpan(text: 'Kisan'),
                              TextSpan(
                                text: 'AI',
                                style: TextStyle(color: AppColors.primaryLight),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.gapV8,
                        const Text(
                          'AI-Powered Precision Agriculture Platform',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.gapV32,
                        const Text(
                          'A Unified Conversational Platform for Smart Farming',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        AppSpacing.gapV16,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
