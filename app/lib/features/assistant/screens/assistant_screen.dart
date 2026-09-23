import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../shared/widgets/farmer_components.dart';

class _ChatMessage {
  final bool isUser;
  final String text;
  final String time;

  const _ChatMessage({
    required this.isUser,
    required this.text,
    required this.time,
  });
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isUser: false,
      text:
          'Namaste! I am your Kisan AI Agronomist. You can ask me anything about weather, spraying windows, crop pests, or mandi prices in your own language.',
      time: '9:00 AM',
    ),
    const _ChatMessage(
      isUser: true,
      text: 'Is it safe to spray pesticide on my cotton crop today?',
      time: '9:02 AM',
    ),
    const _ChatMessage(
      isUser: false,
      text:
          'No, hold spraying today. Rain is expected tomorrow afternoon (65% chance). Pesticides will wash off and waste money. Best spraying window: Thursday morning between 7:00 AM and 11:30 AM.',
      time: '9:02 AM',
    ),
  ];

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          isUser: true,
          text: text,
          time: 'Just now',
        ),
      );
      if (presetText == null) {
        _controller.clear();
      }
    });

    _scrollToBottom();

    // Simulated Agronomist response
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      String response = 'Looking into your farm details... ';
      if (text.toLowerCase().contains('weather') || text.toLowerCase().contains('rain')) {
        response =
            'Current temperature is 31°C with 65% chance of rain tomorrow. Hold chemical spraying until Thursday.';
      } else if (text.toLowerCase().contains('price') || text.toLowerCase().contains('market') || text.toLowerCase().contains('rate')) {
        response =
            'Today in Rajkot Mandi, Kapas (Cotton) is trading at ₹7,250/quintal (up ₹150 from yesterday). Demand is strong.';
      } else if (text.toLowerCase().contains('pest') || text.toLowerCase().contains('leaf') || text.toLowerCase().contains('disease')) {
        response =
            'For spotted leaves on cotton, spray Neem oil extract (5ml/L) or Copper Oxychloride (3g/L) during clear weather.';
      } else if (text.toLowerCase().contains('irrigation') || text.toLowerCase().contains('water')) {
        response =
            'Delay flood and drip watering for the next 24 hours. Natural rain showers will adequately recharge root moisture.';
      } else if (text.toLowerCase().contains('crop') || text.toLowerCase().contains('recommend')) {
        response =
            'Based on your clay-loam soil with pH 6.5 and borewell facility, Cotton and Castor are your top suited crops.';
      } else {
        response =
            'Advice for your farm: Keep checking soil moisture and leaf health. You can also call Kisan Helpline 1800-180-1551 for free agronomist support.';
      }

      setState(() {
        _messages.add(
          _ChatMessage(
            isUser: false,
            text: response,
            time: 'Just now',
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _toggleVoice() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.mic, color: Colors.white),
              SizedBox(width: 10),
              Text('Listening... Speak in Hindi, Telugu, Marathi, or English'),
            ],
          ),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isListening) {
          setState(() {
            _isListening = false;
          });
          _sendMessage('What is the mandi price for Cotton today?');
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Agronomist Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: AppColors.primary, size: 24),
                  ),
                  AppSpacing.gapH12,
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kisan AI Agronomist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Online • Supports 11 Indian Languages',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FarmerVoiceButton(
                    textToSpeak:
                        'Kisan AI Agronomist is ready. Ask any farming question by voice or select quick actions.',
                    label: 'Listen',
                  ),
                ],
              ),
            ),

            // Scrollable Content: Quick Actions + Chat History
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Quick Actions Grid (Never a blank chatbot!)
                  const Text(
                    'Quick Farmer Actions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapV10,
                  _buildQuickActionsRow(),
                  AppSpacing.gapV16,
                  const Divider(height: 1, color: AppColors.cardBorder),
                  AppSpacing.gapV16,

                  // Message bubbles
                  ..._messages.map((msg) => _buildMessageBubble(msg)),
                ],
              ),
            ),

            // Bottom Input Bar with Mic & Send
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    final actions = [
      {'label': '🌧️ Weather & Rain', 'query': 'What is the weather and rain forecast for my farm?'},
      {'label': '🐛 Pest Problem', 'query': 'How to control bollworm and leaf pests?'},
      {'label': '💧 Irrigation Window', 'query': 'Should I water my crop today?'},
      {'label': '💰 Mandi Price', 'query': 'What is the market rate for Cotton today?'},
      {'label': '🌱 Crop Match', 'query': 'Which crop is best for my soil?'},
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final act = actions[index];
          return ActionChip(
            label: Text(
              act['label']!,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            backgroundColor: const Color(0xFFE8F5E9),
            side: const BorderSide(color: Color(0xFFA5D6A7), width: 1),
            shape: AppRadius.shapePill,
            onPressed: () => _sendMessage(act['query']),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 40),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomRight: const Radius.circular(2),
              ),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, right: 30),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomLeft: const Radius.circular(2),
            ),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg.text,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              AppSpacing.gapV8,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FarmerVoiceButton(
                    textToSpeak: msg.text,
                    label: 'Listen',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Voice Mic Button
          Material(
            color: _isListening ? AppColors.error : const Color(0xFFE8F5E9),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _toggleVoice,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: _isListening ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ),
          AppSpacing.gapH8,

          // Text Field
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Ask in any language...',
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          AppSpacing.gapH8,

          // Send Button
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _sendMessage(),
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
