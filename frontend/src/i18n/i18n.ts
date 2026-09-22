import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

import en from './locales/en.json';
import te from './locales/te.json';
import hi from './locales/hi.json';
import ta from './locales/ta.json';
import kn from './locales/kn.json';
import ml from './locales/ml.json';
import mr from './locales/mr.json';
import bn from './locales/bn.json';
import gu from './locales/gu.json';
import pa from './locales/pa.json';
import or from './locales/or.json';

const savedLanguage = localStorage.getItem('kisan_app_language') || 'en';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      te: { translation: te },
      hi: { translation: hi },
      ta: { translation: ta },
      kn: { translation: kn },
      ml: { translation: ml },
      mr: { translation: mr },
      bn: { translation: bn },
      gu: { translation: gu },
      pa: { translation: pa },
      or: { translation: or },
    },
    lng: savedLanguage,
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false, // React already protects from XSS
    },
    returnNull: false,
    returnEmptyString: false,
  });

export default i18n;
