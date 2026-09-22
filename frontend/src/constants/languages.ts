import { LanguageCode, LanguageInfo } from '../types';

export const SUPPORTED_LANGUAGES: LanguageInfo[] = [
  {
    code: 'en',
    nativeName: 'English',
    englishName: 'English',
    greeting: 'Welcome',
    sampleText: 'AI-Powered Precision Farming for Indian Agriculture',
    badge: 'EN',
  },
  {
    code: 'te',
    nativeName: 'తెలుగు',
    englishName: 'Telugu',
    greeting: 'నమస్కారం',
    sampleText: 'రైతు సోదరుల కోసం ఆధునిక ఆర్టిఫిషియల్ ఇంటెలిజెన్స్ వ్యవసాయం',
    badge: 'తె',
  },
  {
    code: 'hi',
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    greeting: 'नमस्ते',
    sampleText: 'भारतीय किसानों के लिए आधुनिक एआई संचालित कृषि मंच',
    badge: 'हि',
  },
  {
    code: 'ta',
    nativeName: 'தமிழ்',
    englishName: 'Tamil',
    greeting: 'வணக்கம்',
    sampleText: 'விவசாயிகளுக்கான நவீன செயற்கை நுண்ணறிவு வேளாண்மை',
    badge: 'த',
  },
  {
    code: 'kn',
    nativeName: 'ಕನ್ನಡ',
    englishName: 'Kannada',
    greeting: 'ನಮಸ್ಕಾರ',
    sampleText: 'ರೈತರಿಗಾಗಿ ಕೃತಕ ಬುದ್ಧಿಮತ್ತೆ ಆಧಾರಿತ ಆಧುನಿಕ ಕೃಷಿ ವೇದಿಕೆ',
    badge: 'ಕ',
  },
  {
    code: 'ml',
    nativeName: 'മലയാളം',
    englishName: 'Malayalam',
    greeting: 'നമസ്കാരം',
    sampleText: 'കർഷകർക്കായുള്ള ആധുനിക എഐ അധിഷ്ഠിത കൃഷി പ്ലാറ്റ്‌ഫോം',
    badge: 'മ',
  },
  {
    code: 'mr',
    nativeName: 'मराठी',
    englishName: 'Marathi',
    greeting: 'नमस्कार',
    sampleText: 'शेतकरी बांधवांसाठी अत्याधुनिक एआय आधारित कृषी प्लॅटफॉर्म',
    badge: 'म',
  },
  {
    code: 'bn',
    nativeName: 'বাংলা',
    englishName: 'Bengali',
    greeting: 'নমস্কার',
    sampleText: 'কৃষকদের জন্য আধুনিক কৃত্রিম বুদ্ধিমত্তা চালিত কৃষি প্ল্যাটফর্ম',
    badge: 'বা',
  },
  {
    code: 'gu',
    nativeName: 'ગુજરાતી',
    englishName: 'Gujarati',
    greeting: 'નમસ્તે',
    sampleText: 'ખેડૂતો માટે અદ્યતન એઆઈ આધારિત કૃષિ પ્લેટફોર્મ',
    badge: 'ગુ',
  },
  {
    code: 'pa',
    nativeName: 'ਪੰਜਾਬੀ',
    englishName: 'Punjabi',
    greeting: 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ',
    sampleText: 'ਕਿਸਾਨ ਵੀਰਾਂ ਲਈ ਆਧੁਨਿਕ ਏਆਈ ਅਧਾਰਤ ਖੇਤੀਬਾੜੀ ਪਲੇਟਫਾਰਮ',
    badge: 'ਪੰ',
  },
  {
    code: 'or',
    nativeName: 'ଓଡ଼ିଆ',
    englishName: 'Odia',
    greeting: 'ନମସ୍କାର',
    sampleText: 'କୃଷକ ଭାଇମାନଙ୍କ ପାଇଁ ଆଧୁନିକ ଏଆଇ ଆଧାରିତ କୃଷି ମଞ୍ଚ',
    badge: 'ଓ',
  },
];

export const DEFAULT_LANGUAGE: LanguageCode = 'en';

export const getLanguageByCode = (code: string): LanguageInfo => {
  return (
    SUPPORTED_LANGUAGES.find((lang) => lang.code === code) ||
    SUPPORTED_LANGUAGES[0]
  );
};
