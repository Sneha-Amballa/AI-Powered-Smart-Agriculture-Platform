import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/layouts/app_scaffold.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../presentation/providers/auth_provider.dart';

/// Commercial-grade farmer login screen with 10-digit Indian mobile validation.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final success = await ref.read(authNotifierProvider.notifier).login(
          phoneNumber: phone,
          password: password,
        );

    if (success && mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.isProfileComplete) {
        context.go('/dashboard');
      } else {
        context.go('/profile-setup');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return AppScaffold(
      showBackButton: true,
      onBackPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 40)),
                  AppSpacing.gapV20,
                  const Text(
                    'Farmer Sign In',
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
                    'Access precision crop advisories, soil intelligence, and market trends.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  AppSpacing.gapV24,

                  // Error banner
                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: AppRadius.radiusMd,
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                          AppSpacing.gapH12,
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(fontSize: 13, color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapV16,
                  ],

                  // Mobile Number
                  AppTextField(
                    label: 'Registered Mobile Number',
                    hintText: '10-digit number (e.g. 9876543210)',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Mobile number is required';
                      var cleaned = v.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                      if (cleaned.startsWith('+91')) cleaned = cleaned.substring(3);
                      if (cleaned.startsWith('0') && cleaned.length == 11) cleaned = cleaned.substring(1);
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
                        return 'Enter a valid 10-digit Indian mobile number';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapV16,

                  // Password
                  AppTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      return null;
                    },
                  ),
                  AppSpacing.gapV8,

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.gapV16,

                  // Submit Button
                  AppButton(
                    label: 'Sign In',
                    isLoading: authState.isLoading,
                    onPressed: _handleLogin,
                  ),
                  AppSpacing.gapV24,

                  // Demo quick hint
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.sage.withValues(alpha: 0.3),
                      borderRadius: AppRadius.radiusSm,
                      border: Border.all(color: AppColors.sage.withValues(alpha: 0.6)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.primaryDark),
                        AppSpacing.gapH8,
                        Expanded(
                          child: Text(
                            'Demo account: 9876543210 (any password)',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV24,

                  // Register Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      InkWell(
                        onTap: () => context.go('/register'),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Text(
                            'Register as New Farmer',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

