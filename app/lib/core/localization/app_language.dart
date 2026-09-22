/// Supported agricultural languages for KisanAI.
enum AppLanguage {
  en('en', 'English', 'English', 'EN', 'Welcome'),
  hi('hi', 'हिन्दी', 'Hindi', 'HI', 'नमस्ते'),
  te('te', 'తెలుగు', 'Telugu', 'TE', 'నమస్కారం'),
  ta('ta', 'தமிழ்', 'Tamil', 'TA', 'வணக்கம்'),
  kn('kn', 'ಕನ್ನಡ', 'Kannada', 'KN', 'ನಮಸ್ಕಾರ'),
  mr('mr', 'मराठी', 'Marathi', 'MR', 'नमस्कार'),
  bn('bn', 'বাংলা', 'Bengali', 'BN', 'নমস্কার'),
  gu('gu', 'ગુજરાતી', 'Gujarati', 'GU', 'નમસ્તે'),
  pa('pa', 'ਪੰਜਾਬੀ', 'Punjabi', 'PA', 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ'),
  ml('ml', 'മലയാളം', 'Malayalam', 'ML', 'നമസ്കാരം'),
  or('or', 'ଓଡ଼ିଆ', 'Odia', 'OR', 'ନମସ୍କାର');

  final String code;
  final String nativeName;
  final String englishName;
  final String badge;
  final String greeting;

  const AppLanguage(
    this.code,
    this.nativeName,
    this.englishName,
    this.badge,
    this.greeting,
  );

  /// Label shown in selection dialogs, e.g. "हिन्दी (Hindi)"
  String get displayName => code == 'en' ? 'English' : '$nativeName ($englishName)';

  /// Resolve AppLanguage from code or english name with graceful fallback to English.
  static AppLanguage fromCode(String? code) {
    if (code == null || code.isEmpty) return AppLanguage.en;
    final clean = code.toLowerCase().trim();
    for (final lang in AppLanguage.values) {
      if (lang.code == clean || lang.englishName.toLowerCase() == clean) {
        return lang;
      }
    }
    return AppLanguage.en;
  }
}
