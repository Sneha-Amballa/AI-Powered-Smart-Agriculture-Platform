import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_outlined_button.dart';

enum AgriModule {
  diseaseDetection,
  market,
  pricePrediction,
  weather,
  schemes,
  assistant,
}

class _CapabilityItem {
  final IconData icon;
  final String title;
  final String description;

  const _CapabilityItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ModuleInProgressView extends StatefulWidget {
  final AgriModule module;

  const ModuleInProgressView({
    super.key,
    required this.module,
  });

  @override
  State<ModuleInProgressView> createState() => _ModuleInProgressViewState();
}

class _ModuleInProgressViewState extends State<ModuleInProgressView> {
  bool _isNotified = false;

  String get _title {
    switch (widget.module) {
      case AgriModule.diseaseDetection:
        return 'Crop Health & Leaf Scanner';
      case AgriModule.market:
        return 'Mandi Market Prices';
      case AgriModule.pricePrediction:
        return 'Price Trend Forecasting';
      case AgriModule.weather:
        return 'Agronomy Weather & Rain';
      case AgriModule.schemes:
        return 'Government Schemes & Grants';
      case AgriModule.assistant:
        return 'Kisan AI Agronomist';
    }
  }

  String get _shortDescription {
    switch (widget.module) {
      case AgriModule.diseaseDetection:
        return 'Camera vision diagnosis for regional crop diseases and targeted remedies is undergoing agronomist calibration.';
      case AgriModule.market:
        return 'Live APMC mandi modal rates and district price tracking are being integrated with official state market feeds.';
      case AgriModule.pricePrediction:
        return 'Machine learning price forecasting models to help plan harvesting and storage are currently in field testing.';
      case AgriModule.weather:
        return 'High-resolution village weather forecasts and precision spray advisory timing are connecting to meteorological radars.';
      case AgriModule.schemes:
        return 'Automated eligibility verification for central and state agriculture subsidies is currently in development.';
      case AgriModule.assistant:
        return 'Conversational voice agronomist supporting vernacular regional languages is being trained with agricultural research institutes.';
    }
  }

  IconData get _icon {
    switch (widget.module) {
      case AgriModule.diseaseDetection:
        return Icons.health_and_safety_outlined;
      case AgriModule.market:
        return Icons.storefront_outlined;
      case AgriModule.pricePrediction:
        return Icons.trending_up_rounded;
      case AgriModule.weather:
        return Icons.cloud_outlined;
      case AgriModule.schemes:
        return Icons.account_balance_outlined;
      case AgriModule.assistant:
        return Icons.forum_outlined;
    }
  }

  List<_CapabilityItem> get _capabilities {
    switch (widget.module) {
      case AgriModule.diseaseDetection:
        return const [
          _CapabilityItem(
            icon: Icons.photo_camera_outlined,
            title: 'Leaf Photograph Diagnosis',
            description: 'Instant visual detection of fungal, bacterial, and pest damage on leaves.',
          ),
          _CapabilityItem(
            icon: Icons.medication_outlined,
            title: 'Targeted Spray Guidance',
            description: 'Dosage recommendations balancing chemical protection and organic neem remedies.',
          ),
          _CapabilityItem(
            icon: Icons.offline_bolt_outlined,
            title: 'Field-Ready Offline Mode',
            description: 'Capture crop images even without mobile network connectivity in remote fields.',
          ),
        ];
      case AgriModule.market:
        return const [
          _CapabilityItem(
            icon: Icons.currency_rupee,
            title: 'Live APMC Mandi Rates',
            description: 'Direct commodity price feeds updated daily across regional market yards.',
          ),
          _CapabilityItem(
            icon: Icons.compare_arrows_rounded,
            title: 'Nearby Mandi Comparison',
            description: 'Compare modal rates across neighboring mandis after accounting for transport costs.',
          ),
          _CapabilityItem(
            icon: Icons.notifications_active_outlined,
            title: 'Price Target Alerts',
            description: 'Get notified when your primary crop reaches your desired selling price.',
          ),
        ];
      case AgriModule.pricePrediction:
        return const [
          _CapabilityItem(
            icon: Icons.auto_graph_rounded,
            title: '30-Day Trend Forecasting',
            description: 'Predictive seasonal price curves based on historical yield and mandi volumes.',
          ),
          _CapabilityItem(
            icon: Icons.warehouse_outlined,
            title: 'Sell vs. Store Advisor',
            description: 'Decision guidance comparing storage costs against expected future prices.',
          ),
          _CapabilityItem(
            icon: Icons.analytics_outlined,
            title: 'Arrival Volume Sensitivity',
            description: 'Estimated price impact as state-wide harvesting season peaks.',
          ),
        ];
      case AgriModule.weather:
        return const [
          _CapabilityItem(
            icon: Icons.water_drop_outlined,
            title: 'Village-Level Rainfall Radar',
            description: 'Precision precipitation timing and millimeter rain forecasts for your village.',
          ),
          _CapabilityItem(
            icon: Icons.air_rounded,
            title: 'Optimal Spray Windows',
            description: 'Favorable wind, temperature, and humidity periods for safe pesticide application.',
          ),
          _CapabilityItem(
            icon: Icons.calendar_month_outlined,
            title: '14-Day Agromet Advisory',
            description: 'Extended weather outlook paired with crop stage specific agronomy advice.',
          ),
        ];
      case AgriModule.schemes:
        return const [
          _CapabilityItem(
            icon: Icons.verified_outlined,
            title: 'Holding-Based Matching',
            description: 'Instantly filtered by landholding size, crop category, and state jurisdiction.',
          ),
          _CapabilityItem(
            icon: Icons.description_outlined,
            title: 'Clear Document Checklist',
            description: 'Concise requirements for Aadhaar, land passbook, and bank mandate verification.',
          ),
          _CapabilityItem(
            icon: Icons.support_agent_outlined,
            title: 'Kisan Kendra Linkages',
            description: 'Direct contact details for local agriculture officers and CSC facilitation centers.',
          ),
        ];
      case AgriModule.assistant:
        return const [
          _CapabilityItem(
            icon: Icons.mic_none_outlined,
            title: 'Vernacular Voice Support',
            description: 'Speak your farming queries in Telugu, Hindi, Kannada, and Marathi.',
          ),
          _CapabilityItem(
            icon: Icons.science_outlined,
            title: 'Verified Agronomy Knowledge',
            description: 'Evidence-based advice referenced from agricultural university research.',
          ),
          _CapabilityItem(
            icon: Icons.history_edu_outlined,
            title: 'Farm Profile Awareness',
            description: 'Answers tailored to your exact soil type, irrigation setup, and primary crops.',
          ),
        ];
    }
  }

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isNotified
              ? 'You will be notified when $_title is available for your farm.'
              : 'Notification preference removed.',
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    // Icon Circle
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _icon,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapV14,

                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.4),
                        borderRadius: AppRadius.radiusPill,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'UNDER DEVELOPMENT',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapV12,

                    // Title
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.gapV8,

                    // Subtitle / Description
                    Text(
                      _shortDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Upcoming Capabilities
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'UPCOMING CAPABILITIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              AppSpacing.gapV10,

              // Capabilities List
              ..._capabilities.map((cap) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm + 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.radiusMd,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: AppRadius.radiusSm,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              cap.icon,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          AppSpacing.gapH12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cap.title,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                AppSpacing.gapV2,
                                Text(
                                  cap.description,
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
                    ),
                  )),

              AppSpacing.gapV16,

              // Action Buttons
              AppButton(
                label: 'Use Crop Recommendation (Active)',
                leadingIcon: Icons.eco_rounded,
                onPressed: () => context.go('/crop-recommendation'),
              ),
              AppSpacing.gapV10,

              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      label: _isNotified ? 'Notification Enabled' : 'Notify When Live',
                      leadingIcon: _isNotified ? Icons.check_rounded : Icons.notifications_none_rounded,
                      onPressed: _toggleNotification,
                    ),
                  ),
                  AppSpacing.gapH10,
                  Expanded(
                    child: AppOutlinedButton(
                      label: 'Back to Home',
                      leadingIcon: Icons.home_outlined,
                      onPressed: () => context.go('/dashboard'),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapV24,
            ],
          ),
        ),
      ),
    );
  }
}
