import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/illustrations/agri_illustrations.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_card.dart';

/// Mobile-first Conversational AI Farm Assistant screen designed for farmer accessibility.
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Namaste Farmer Rajesh! I am your Kisan AI Agronomist. You can ask me any crop questions in your regional language or tap the microphone to speak.',
      isUser: false,
      time: '09:00 AM',
    ),
    const _ChatMessage(
      text: 'Rice leaves are turning yellow with brown spots. What should I spray?',
      isUser: true,
      time: '09:02 AM',
    ),
    const _ChatMessage(
      text: 'This indicates initial Cercospora leaf spot or Nitrogen deficit. Ensure standing field water is regulated. If spots have grey centers, apply Mancozeb (2g/L water) or organic neem cake soil amendment.',
      isUser: false,
      time: '09:03 AM',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, time: 'Just now'));
      if (textToSend == null) _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _messages.add(
            const _ChatMessage(
              text: 'Understood. Based on your Kurnool district soil profile, ensure soil moisture remains at 65-70% before application.',
              isUser: false,
              time: 'Just now',
            ),
          );
        });
      }
    });
  }

  void _listenVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listening in Hindi/Telugu/English... Voice AI service connected.'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Summary Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: AppRadius.radiusMd,
                      ),
                      alignment: Alignment.center,
                      child: const AgriIllustration(
                        type: AgriIllustrationType.assistant,
                        size: 42,
                        primaryColor: Color(0xFF1565C0),
                        secondaryColor: Color(0xFFE3F2FD),
                      ),
                    ),
                    AppSpacing.gapH14,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kisan AI Agronomist',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          AppSpacing.gapV2,
                          Text(
                            '24/7 Regional Voice & Chat Helpline',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const AppBadge(label: 'ONLINE', variant: BadgeVariant.success),
                  ],
                ),
              ),
              AppSpacing.gapV14,

              // Quick Questions Chips
              const Text(
                'Frequently Asked by Farmers:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              AppSpacing.gapV8,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickChip('Best fertilizer for paddy right now?'),
                    AppSpacing.gapH8,
                    _buildQuickChip('How to prevent aphids organically?'),
                    AppSpacing.gapH8,
                    _buildQuickChip('Safe spraying hours today?'),
                  ],
                ),
              ),
              AppSpacing.gapV16,

              // Chat Thread Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (final msg in _messages) ...[
                      _buildMessageBubble(msg),
                      AppSpacing.gapV10,
                    ],
                    AppSpacing.gapV10,
                    // Input Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Ask in your regional language...',
                              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.radiusMd,
                                borderSide: const BorderSide(color: AppColors.cardBorder),
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        AppSpacing.gapH8,
                        IconButton.filled(
                          icon: const Icon(Icons.send, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(48, 48),
                          ),
                          onPressed: _sendMessage,
                        ),
                        AppSpacing.gapH4,
                        IconButton.filled(
                          icon: const Icon(Icons.mic, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(48, 48),
                          ),
                          onPressed: _listenVoice,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      avatar: const Icon(Icons.psychology_outlined, size: 14, color: AppColors.primary),
      backgroundColor: AppColors.surface,
      onPressed: () => _sendMessage(text),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: msg.isUser ? null : Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: msg.isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            AppSpacing.gapV4,
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: msg.isUser ? Colors.white70 : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  const _ChatMessage({required this.text, required this.isUser, required this.time});
}
