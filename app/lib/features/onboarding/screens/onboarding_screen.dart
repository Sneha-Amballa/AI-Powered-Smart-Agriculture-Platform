import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: 'Personalized Crop Recommendations',
      description:
          'Utilize state-of-the-art machine learning to match your exact soil nitrogen, phosphorus, potassium, and climate data with optimal crops.',
      icon: Icons.eco,
      badgeText: 'Live Machine Learning',
    ),
    _OnboardingItem(
      title: 'AI Plant Health Diagnostics',
      description:
          'Scan crop leaves and identify biological infestations or fungal diseases early with immediate organic and chemical mitigation remedies.',
      icon: Icons.biotech,
      badgeText: 'Computer Vision',
    ),
    _OnboardingItem(
      title: 'Weather & Mandi Intelligence',
      description:
          'Access hyper-local agromet forecasts and APMC market price trends to sell produce at the right time and avoid weather risks.',
      icon: Icons.trending_up,
      badgeText: 'Market Intelligence',
    ),
    _OnboardingItem(
      title: 'Conversational Farm Assistant',
      description:
          'Consult your 24/7 AI agronomist in your preferred vernacular language using voice or chat for round-the-clock farming decisions.',
      icon: Icons.forum,
      badgeText: 'AI Agronomist',
    ),
  ];

  void _onNext() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/dashboard');
    }
  }

  void _onSkip() {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          AppSpacing.gapH16,
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: const BoxDecoration(
                              color: AppColors.sage,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              size: 42,
                              color: AppColors.primary,
                            ),
                          ),
                          AppSpacing.gapV16,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: AppRadius.radiusPill,
                            ),
                            child: Text(
                              item.badgeText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                          AppSpacing.gapV12,
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          AppSpacing.gapV8,
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Progress
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.cardBorder,
                          borderRadius: AppRadius.radiusPill,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.gapV24,
                  AppButton(
                    label: _currentPage == _items.length - 1 ? 'Get Started' : 'Continue',
                    onPressed: _onNext,
                    trailingIcon: Icons.arrow_forward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final String badgeText;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeText,
  });
}
