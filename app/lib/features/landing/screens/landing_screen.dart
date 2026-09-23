import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/components/agri_feature_card.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_divider.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/app_outlined_button.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// Public-facing mobile-first landing page for the AI-Powered Smart Agriculture Platform.
/// Designed for maximum farmer accessibility, high legibility, and zero overflow.
class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isAuthenticated = authState.isAuthenticated;

    return PopScope(
      canPop: !isAuthenticated,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isAuthenticated) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const AppLogo(size: 24),
          titleSpacing: 8,
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: isAuthenticated
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  tooltip: 'Back to Dashboard',
                  onPressed: () => context.go('/dashboard'),
                )
              : null,
        actions: [
          if (isAuthenticated) ...[
            TextButton.icon(
              icon: const Icon(Icons.logout, size: 15, color: AppColors.error),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(64, 36),
              ),
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
            AppSpacing.gapH4,
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(72, 36),
                shape: AppRadius.shapeMd,
              ),
              child: const Text(
                'Dashboard',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            AppSpacing.gapH8,
          ] else ...[
            TextButton(
              onPressed: () => context.push('/login'),
              style: TextButton.styleFrom(
                minimumSize: const Size(54, 36),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
            AppSpacing.gapH4,
            ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: const Size(70, 36),
                shape: AppRadius.shapeMd,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            AppSpacing.gapH8,
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeroSection(context),
            _buildCoreFeaturesSection(context),
            _buildHowItWorksSection(context),
            _buildAssistantBanner(context),
            _buildTrustSection(context),
            _buildFinalCtaSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    ),
  );
}

  // 1. HERO SECTION (Mobile-First, Zero Truncation, Zero Overflow)
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: AppRadius.radiusPill,
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.psychology, size: 16, color: AppColors.primaryDark),
                    AppSpacing.gapH8,
                    Flexible(
                      child: Text(
                        'AI FOR PRECISION AGRICULTURE',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Primary Headline
              const Text(
                'Smarter Decisions.\nBetter Farming.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.15,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV12,

              // Plain-Language Concise Subheading (No wall of text)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: const Text(
                  'Predict high-yielding crops from soil test numbers, detect leaf diseases early, track live mandi rates, and receive 24/7 expert farm advisory.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              AppSpacing.gapV24,

              // CTA Action Buttons: Responsive Wrap that NEVER truncates
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 420;
                  return isNarrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppButton(
                              label: 'Start Crop Test',
                              leadingIcon: Icons.eco_outlined,
                              trailingIcon: Icons.arrow_forward,
                              onPressed: () => context.go('/crop-recommendation'),
                            ),
                            AppSpacing.gapV12,
                            AppOutlinedButton(
                              label: 'Explore Platform',
                              leadingIcon: Icons.dashboard_outlined,
                              onPressed: () => context.go('/dashboard'),
                            ),
                          ],
                        )
                      : Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            SizedBox(
                              width: 210,
                              child: AppButton(
                                label: 'Start Crop Test',
                                leadingIcon: Icons.eco_outlined,
                                trailingIcon: Icons.arrow_forward,
                                onPressed: () => context.go('/crop-recommendation'),
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: AppOutlinedButton(
                                label: 'Explore Platform',
                                leadingIcon: Icons.dashboard_outlined,
                                onPressed: () => context.go('/dashboard'),
                              ),
                            ),
                          ],
                        );
                },
              ),
              AppSpacing.gapV24,

              // HERO SHOWCASE SECTION (Responsive cards: never overflow horizontally!)
              _buildResponsiveHeroShowcase(context),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive Hero Showcase: Replaces the overflowing 3-column row
  Widget _buildResponsiveHeroShowcase(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 650;

        final statItems = [
          _HeroShowcaseItem(
            icon: Icons.psychology_rounded,
            color: AppColors.primary,
            bgColor: AppColors.successLight,
            title: 'Machine Learning',
            subtitle: 'Tested on Indian soils',
            badge: 'LIVE ML',
          ),
          _HeroShowcaseItem(
            icon: Icons.cloud_outlined,
            color: const Color(0xFF0277BD),
            bgColor: const Color(0xFFE1F5FE),
            title: 'Hyper-Local Weather',
            subtitle: 'Agromet rain & spray guide',
            badge: 'HOURLY',
          ),
          _HeroShowcaseItem(
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF6A1B9A),
            bgColor: const Color(0xFFEDE7F6),
            title: 'APMC Mandi Rates',
            subtitle: 'Live commodity tracking',
            badge: 'DAILY',
          ),
        ];

        if (isWide) {
          return AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            backgroundColor: AppColors.background,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < statItems.length; i++) ...[
                  if (i > 0)
                    Container(
                      height: 48,
                      width: 1,
                      color: AppColors.cardBorder,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  Expanded(child: _buildShowcaseTile(statItems[i])),
                ],
              ],
            ),
          );
        }

        // Mobile layout: Vertical stack of compact responsive cards with zero overflow
        return AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          backgroundColor: AppColors.background,
          child: Column(
            children: [
              for (int i = 0; i < statItems.length; i++) ...[
                if (i > 0) const AppDivider(height: 16),
                _buildShowcaseTileHorizontal(statItems[i]),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildShowcaseTile(_HeroShowcaseItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 24, color: item.color),
          ),
          AppSpacing.gapV8,
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV2,
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowcaseTileHorizontal(_HeroShowcaseItem item) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: item.bgColor,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Icon(item.icon, size: 22, color: item.color),
        ),
        AppSpacing.gapH12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV2,
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH8,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: item.bgColor,
            borderRadius: AppRadius.radiusPill,
          ),
          child: Text(
            item.badge,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: item.color,
            ),
          ),
        ),
      ],
    );
  }

  // 2. CORE FEATURES / LAUNCHPAD (7 Primary Farm Actions)
  Widget _buildCoreFeaturesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Farm Tools & Services',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.gapV4,
                        Text(
                          'Tap any tool to open instant diagnostics and advisory.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH8,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      borderRadius: AppRadius.radiusPill,
                    ),
                    child: const Text(
                      '7 MODULES',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV16,

              // 7 Large Accessible Feature Cards
              AgriFeatureCard(
                title: 'Crop Recommendation',
                subtitle: 'Find the highest-yielding crop for your soil test',
                illustrationType: AgriIllustrationType.crop,
                fallbackIcon: Icons.eco,
                accentColor: AppColors.primary,
                lightBgColor: const Color(0xFFE8F5E9),
                badgeLabel: 'LIVE ML',
                badgeVariant: BadgeVariant.success,
                onTap: () => context.go('/crop-recommendation'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'Plant Disease Detection',
                subtitle: 'Take a photo of diseased leaves for instant diagnosis',
                illustrationType: AgriIllustrationType.disease,
                fallbackIcon: Icons.biotech,
                accentColor: const Color(0xFF00796B),
                lightBgColor: const Color(0xFFE0F2F1),
                badgeLabel: 'CAMERA SCAN',
                badgeVariant: BadgeVariant.info,
                onTap: () => context.go('/disease-detection'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'Pest Identification',
                subtitle: 'Spot harmful bugs early & get organic remedy tips',
                illustrationType: AgriIllustrationType.pest,
                fallbackIcon: Icons.bug_report,
                accentColor: const Color(0xFFE65100),
                lightBgColor: const Color(0xFFFFF3E0),
                badgeLabel: 'PEST SHIELD',
                badgeVariant: BadgeVariant.neutral,
                onTap: () => context.go('/pest-detection'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'Live Weather & Rain Advisory',
                subtitle: '7-day local rain forecast & safe spraying hours',
                illustrationType: AgriIllustrationType.weather,
                fallbackIcon: Icons.cloud,
                accentColor: const Color(0xFF0277BD),
                lightBgColor: const Color(0xFFE1F5FE),
                badgeLabel: 'HOURLY',
                badgeVariant: BadgeVariant.info,
                onTap: () => context.go('/weather'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'APMC Mandi Market Prices',
                subtitle: 'Today’s commodity prices and market price trends',
                illustrationType: AgriIllustrationType.market,
                fallbackIcon: Icons.trending_up,
                accentColor: const Color(0xFF4527A0),
                lightBgColor: const Color(0xFFEDE7F6),
                badgeLabel: 'DAILY RATES',
                badgeVariant: BadgeVariant.info,
                onTap: () => context.go('/market'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'Government Schemes & Subsidies',
                subtitle: 'Find PM-KISAN, crop insurance, and state grants',
                illustrationType: AgriIllustrationType.schemes,
                fallbackIcon: Icons.account_balance,
                accentColor: const Color(0xFFC2185B),
                lightBgColor: const Color(0xFFFCE4EC),
                badgeLabel: 'SUBSIDIES',
                badgeVariant: BadgeVariant.neutral,
                onTap: () => context.go('/government-schemes'),
              ),
              AppSpacing.gapV12,

              AgriFeatureCard(
                title: 'Kisan AI Voice & Chat Assistant',
                subtitle: 'Ask any farming question in your regional language',
                illustrationType: AgriIllustrationType.assistant,
                fallbackIcon: Icons.forum,
                accentColor: const Color(0xFF1565C0),
                lightBgColor: const Color(0xFFE3F2FD),
                badgeLabel: '24/7 HELPLINE',
                badgeVariant: BadgeVariant.info,
                onTap: () => context.go('/assistant'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. HOW IT WORKS (3 Simple Visual Steps)
  Widget _buildHowItWorksSection(BuildContext context) {
    final steps = [
      const _SimpleStep(
        number: '1',
        icon: Icons.camera_alt_outlined,
        title: 'Input Soil or Photo',
        desc: 'Enter soil test values or take a leaf photo.',
      ),
      const _SimpleStep(
        number: '2',
        icon: Icons.psychology_outlined,
        title: 'AI Analyzes Instantly',
        desc: 'ML models calculate optimal recommendations.',
      ),
      const _SimpleStep(
        number: '3',
        icon: Icons.check_circle_outline,
        title: 'Take Confident Action',
        desc: 'Apply specific fertilizer, spray, or mandi plan.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              const Text(
                'How KisanAI Works',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV4,
              const Text(
                'Simple 3-step workflow designed for every farmer.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              AppSpacing.gapV20,
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 650;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: steps
                              .map((s) => Expanded(child: _buildStepItem(s)))
                              .toList(),
                        )
                      : Column(
                          children: steps.map((s) => _buildStepItem(s)).toList(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(_SimpleStep step) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(step.icon, color: Colors.white, size: 22),
          ),
          AppSpacing.gapH14,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'STEP ${step.number}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV2,
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV2,
                Text(
                  step.desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. ASSISTANT BANNER
  Widget _buildAssistantBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: AppCard(
            backgroundColor: AppColors.primaryDark,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: AppRadius.radiusSm,
                      ),
                      child: const Icon(Icons.forum_outlined, color: Colors.white, size: 20),
                    ),
                    AppSpacing.gapH10,
                    const Expanded(
                      child: Text(
                        'Need Immediate Help in Your Field?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapV10,
                const Text(
                  'Talk to the 24/7 Kisan AI Agronomist in Hindi, Telugu, Tamil, Marathi, or English for instant remedies.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                AppSpacing.gapV16,
                AppButton(
                  label: 'Ask AI Agronomist',
                  leadingIcon: Icons.chat_bubble_outline,
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  onPressed: () => context.go('/assistant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 5. TRUST / QUALITY SECTION
  Widget _buildTrustSection(BuildContext context) {
    final values = [
      const _SimpleValue(Icons.verified_outlined, 'Trained on Indian Soil', 'Calibrated to Indian NPK and weather cycles.'),
      const _SimpleValue(Icons.bolt_outlined, 'Instant Live Prediction', 'Results in under 2 seconds via Render ML API.'),
      const _SimpleValue(Icons.translate_outlined, 'Regional Language Ready', 'Designed for voice and vernacular accessibility.'),
      const _SimpleValue(Icons.shield_outlined, 'Zero Cost & Ad-Free', 'Academic major project dedicated to farmers.'),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Built for Real Farming Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV16,
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTrustTile(values[0]),
                                  AppSpacing.gapV12,
                                  _buildTrustTile(values[2]),
                                ],
                              ),
                            ),
                            AppSpacing.gapH16,
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTrustTile(values[1]),
                                  AppSpacing.gapV12,
                                  _buildTrustTile(values[3]),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            for (int i = 0; i < values.length; i++) ...[
                              if (i > 0) AppSpacing.gapV12,
                              _buildTrustTile(values[i]),
                            ],
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustTile(_SimpleValue v) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.sage,
              borderRadius: AppRadius.radiusSm,
            ),
            child: Icon(v.icon, color: AppColors.primary, size: 20),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.gapV2,
                Text(
                  v.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 6. FINAL CTA
  Widget _buildFinalCtaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.forestDeep,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const Text(
                'Ready to Test Your Soil?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              AppSpacing.gapV8,
              const Text(
                'Access live machine learning crop recommendations in seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              AppSpacing.gapV20,
              AppButton(
                label: 'Get Crop Recommendation',
                backgroundColor: AppColors.primaryLight,
                foregroundColor: Colors.white,
                trailingIcon: Icons.arrow_forward,
                onPressed: () => context.go('/crop-recommendation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 7. RESPONSIVE FOOTER
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  const AppLogo(size: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _buildFooterLink(context, 'Dashboard', '/dashboard'),
                      _buildFooterLink(context, 'Live ML', '/crop-recommendation'),
                      _buildFooterLink(context, 'Profile', '/profile'),
                    ],
                  ),
                ],
              ),
              const AppDivider(height: 24),
              const Text(
                '© 2026 KisanAI • AI-Powered Smart Agriculture Platform',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String title, String path) {
    return InkWell(
      onTap: () => context.go(path),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _HeroShowcaseItem {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String badge;

  const _HeroShowcaseItem({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

class _SimpleStep {
  final String number;
  final IconData icon;
  final String title;
  final String desc;

  const _SimpleStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _SimpleValue {
  final IconData icon;
  final String title;
  final String desc;

  const _SimpleValue(this.icon, this.title, this.desc);
}
