import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/farmer_components.dart';

class _SampleDiseaseCase {
  final String label;
  final FarmerStatus status;
  final String statusText;
  final String diseaseName;
  final String cropName;
  final String impact;
  final String organicRemedy;
  final String chemicalRemedy;
  final String sprayingWindow;
  final IconData icon;

  const _SampleDiseaseCase({
    required this.label,
    required this.status,
    required this.statusText,
    required this.diseaseName,
    required this.cropName,
    required this.impact,
    required this.organicRemedy,
    required this.chemicalRemedy,
    required this.sprayingWindow,
    required this.icon,
  });
}

const List<_SampleDiseaseCase> _sampleCases = [
  _SampleDiseaseCase(
    label: 'Leaf Spot',
    status: FarmerStatus.warning,
    statusText: 'Warning • Action Needed',
    cropName: 'Cotton (Kapas)',
    diseaseName: 'Cercospora Leaf Spot',
    impact: 'Can spread across leaves during humid conditions and reduce yield by 15-20%.',
    organicRemedy: 'Spray Neem oil extract (5ml per liter) in early morning.',
    chemicalRemedy: 'Spray Copper Oxychloride 50 WP (3g per liter of water).',
    sprayingWindow: 'Thursday morning (after rain stops).',
    icon: Icons.lens_blur_rounded,
  ),
  _SampleDiseaseCase(
    label: 'Leaf Blight',
    status: FarmerStatus.urgent,
    statusText: 'Urgent • Immediate Care',
    cropName: 'Wheat (Gehun)',
    diseaseName: 'Early Leaf Blight',
    impact: 'Rapid leaf browning observed. Potential 30% yield loss if not contained.',
    organicRemedy: 'Remove and burn heavily infected bottom leaves.',
    chemicalRemedy: 'Spray Mancozeb 75 WP (2.5g per liter of clean water).',
    sprayingWindow: 'Within next 48 hours.',
    icon: Icons.warning_rounded,
  ),
  _SampleDiseaseCase(
    label: 'Healthy Leaf',
    status: FarmerStatus.good,
    statusText: 'Good • Healthy Plant',
    cropName: 'Chilli (Mirchi)',
    diseaseName: 'No Disease Detected',
    impact: 'Leaf chlorophyll and cellular structure are optimal. No immediate risk.',
    organicRemedy: 'Maintain balanced neem cake application at root zone.',
    chemicalRemedy: 'No chemical treatment needed.',
    sprayingWindow: 'Continue regular field monitoring.',
    icon: Icons.check_circle_rounded,
  ),
];

/// Farmer-first crop disease diagnosis screen.
/// Implements "See → Understand → Act":
/// 1. What is happening? (Visual status badge + disease identification)
/// 2. What does it mean for my farm? (Yield impact in simple words)
/// 3. What should I do? (Clear organic & chemical remedy + safe time)
class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  int _selectedSampleIndex = 0;
  bool _isAnalyzing = false;

  void _analyzeSample(int index) {
    setState(() {
      _selectedSampleIndex = index;
      _isAnalyzing = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Check Crop Leaf',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapV16,
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 28),
                title: const Text('Take Leaf Photo with Camera', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Point camera closely at affected leaf'),
                onTap: () {
                  Navigator.pop(ctx);
                  _analyzeSample(0);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary, size: 28),
                title: const Text('Choose Photo from Gallery', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Select existing leaf picture'),
                onTap: () {
                  Navigator.pop(ctx);
                  _analyzeSample(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCase = _sampleCases[_selectedSampleIndex];
    final readAloudText =
        'Crop: ${currentCase.cropName}. Condition: ${currentCase.diseaseName}. Status: ${currentCase.statusText}. Action: ${currentCase.chemicalRemedy}';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title / Identifier
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Crop Health & Leaf Scanner',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FarmerVoiceButton(textToSpeak: readAloudText),
                    ],
                  ),
                  AppSpacing.gapV14,

                  // Camera Action Centerpiece
                  _buildCameraPromptCard(),
                  AppSpacing.gapV16,

                  // Sample Leaf Selector Chips
                  const FarmerSectionHeader(title: 'Or Test Sample Leaf'),
                  AppSpacing.gapV10,
                  _buildSampleChipsRow(),
                  AppSpacing.gapV16,

                  // Diagnosis Result: See → Understand → Act
                  if (_isAnalyzing)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: FarmerLoadingState(message: 'Scanning leaf spots and patterns...'),
                    )
                  else
                    _buildDiagnosisResultCard(currentCase),
                  AppSpacing.gapV24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPromptCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
              ),
              AppSpacing.gapH12,
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Take a Leaf Photo',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Get instant diagnosis and exact remedy in seconds',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD8F3DC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapV14,
          FarmerPrimaryButton(
            label: 'Take Photo',
            icon: Icons.camera_alt_rounded,
            height: 48,
            onPressed: _showImageSourceDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSampleChipsRow() {
    return Row(
      children: List.generate(_sampleCases.length, (index) {
        final item = _sampleCases[index];
        final isSelected = index == _selectedSampleIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < _sampleCases.length - 1 ? 8.0 : 0.0,
            ),
            child: InkWell(
              onTap: () => _analyzeSample(index),
              borderRadius: AppRadius.radiusSm,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: AppRadius.radiusSm,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDiagnosisResultCard(_SampleDiseaseCase item) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. WHAT IS HAPPENING?
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.cropName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.diseaseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              FarmerStatusBadge(status: item.status, customLabel: item.statusText),
            ],
          ),
          AppSpacing.gapV14,

          // 2. WHAT DOES IT MEAN FOR MY FARM?
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                AppSpacing.gapH10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Farm Impact',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.impact,
                        style: const TextStyle(
                          fontSize: 12.5,
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
          AppSpacing.gapV14,

          // 3. WHAT SHOULD I DO? (Action steps)
          const Text(
            'Recommended Treatment',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.gapV8,
          _buildRemedyRow(
            icon: Icons.eco_rounded,
            iconColor: const Color(0xFF2E7D32),
            type: 'Organic Solution',
            content: item.organicRemedy,
          ),
          const SizedBox(height: 8),
          _buildRemedyRow(
            icon: Icons.science_outlined,
            iconColor: AppColors.primary,
            type: 'Chemical Treatment',
            content: item.chemicalRemedy,
          ),
          const SizedBox(height: 8),
          _buildRemedyRow(
            icon: Icons.schedule_rounded,
            iconColor: const Color(0xFFE65100),
            type: 'Best Application Time',
            content: item.sprayingWindow,
          ),
          AppSpacing.gapV16,

          // Kisan Helpline Call Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: AppRadius.radiusSm,
            ),
            child: const Row(
              children: [
                Icon(Icons.phone_in_talk_rounded, color: AppColors.primaryDark, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speak with Government Agronomist',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        'Free Helpline: 1800-180-1551 (6 AM - 10 PM)',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemedyRow({
    required IconData icon,
    required Color iconColor,
    required String type,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusSm,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          AppSpacing.gapH10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
}
