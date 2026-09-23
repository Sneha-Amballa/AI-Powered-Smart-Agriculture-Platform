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
];

export const DEFAULT_LANGUAGE: LanguageCode = 'en';

export const getLanguageByCode = (code: string): LanguageInfo => {
  return (
    SUPPORTED_LANGUAGES.find((lang) => lang.code === code) ||
    SUPPORTED_LANGUAGES[0]
  );
};
