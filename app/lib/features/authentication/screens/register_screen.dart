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

/// Frictionless farmer registration screen: Name, 10-Digit Mobile, Password, Confirm Password.
/// Zero-cost: No OTP, no email, no bank/Aadhaar details required.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _password = '';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Password strength calculation: 0 (Weak), 1 (Medium), 2 (Strong)
  int _getPasswordStrength(String password) {
    if (password.length < 6) return 0;
    final hasNumberOrSpecial = RegExp(r'[0-9!@#\$&*~]').hasMatch(password);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    if (password.length >= 8 && hasNumberOrSpecial && hasLetter) return 2;
    return 1;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final success = await ref.read(authNotifierProvider.notifier).register(
          fullName: name,
          phoneNumber: phone,
          password: password,
        );

    if (success && mounted) {
      context.go('/profile-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final strength = _getPasswordStrength(_password);

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
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: 40)),
                  AppSpacing.gapV16,
                  const Text(
                    'Create Farmer Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapV6,
                  const Text(
                    'Quick, free registration for Indian farmers. No OTP or bank details required.',
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

                  // Full Name
                  AppTextField(
                    label: 'Farmer Full Name *',
                    hintText: 'e.g. Rajesh Sharma / Savita Devi',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Please enter your full name';
                      if (v.trim().length < 2) return 'Name must be at least 2 characters';
                      return null;
                    },
                  ),
                  AppSpacing.gapV16,

                  // Mobile Number
                  AppTextField(
                    label: 'Mobile Number *',
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
                    label: 'Create Password *',
                    hintText: 'Minimum 6 characters',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (val) {
                      setState(() => _password = val);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  AppSpacing.gapV8,

                  // Password Strength Indicator
                  if (_password.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: strength >= 0 ? AppColors.warning : AppColors.cardBorder,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: strength >= 1 ? AppColors.primary : AppColors.cardBorder,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: strength >= 2 ? AppColors.success : AppColors.cardBorder,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          strength == 0
                              ? 'Weak'
                              : strength == 1
                                  ? 'Medium'
                                  : 'Strong',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: strength == 0
                                ? AppColors.warning
                                : strength == 1
                                    ? AppColors.primaryDark
                                    : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapV12,
                  ],

                  // Confirm Password
                  AppTextField(
                    label: 'Confirm Password *',
                    hintText: 'Re-enter your password',
                    prefixIcon: Icons.lock_clock_outlined,
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
                      if (v != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  AppSpacing.gapV24,

                  // Submit Button
                  AppButton(
                    label: 'Register & Continue to Farm Setup',
                    trailingIcon: Icons.arrow_forward,
                    isLoading: authState.isLoading,
                    onPressed: _handleRegister,
                  ),
                  AppSpacing.gapV20,

                  // Sign In Link
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      InkWell(
                        onTap: () => context.go('/login'),
                        borderRadius: BorderRadius.circular(4),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Text(
                            'Sign In',
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

