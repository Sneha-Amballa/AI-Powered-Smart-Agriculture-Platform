import React, { createContext, useContext, useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { LanguageCode, LanguageInfo } from '../types';
import { SUPPORTED_LANGUAGES, DEFAULT_LANGUAGE, getLanguageByCode } from '../constants/languages';
import { api } from '../services/api';

interface LanguageContextType {
  currentLanguage: LanguageCode;
  languageInfo: LanguageInfo;
  setLanguage: (lang: LanguageCode, syncBackendUserId?: number) => Promise<void>;
  supportedLanguages: LanguageInfo[];
  isLanguageModalOpen: boolean;
  openLanguageModal: () => void;
  closeLanguageModal: () => void;
  toastMessage: string | null;
  hideToast: () => void;
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const LanguageProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { i18n, t } = useTranslation();

  const [currentLanguage, setCurrentLanguageState] = useState<LanguageCode>(() => {
    const saved = localStorage.getItem('kisan_app_language') as LanguageCode;
    if (saved && SUPPORTED_LANGUAGES.some((l) => l.code === saved)) {
      return saved;
    }
    return DEFAULT_LANGUAGE;
  });

  const [isLanguageModalOpen, setIsLanguageModalOpen] = useState(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Keep HTML document tag synchronized with active language
  useEffect(() => {
    document.documentElement.lang = currentLanguage;
  }, [currentLanguage]);

  const setLanguage = async (lang: LanguageCode, syncBackendUserId?: number) => {
    if (lang === currentLanguage) {
      setIsLanguageModalOpen(false);
      return;
    }

    // 1. Update i18next global state
    await i18n.changeLanguage(lang);

    // 2. Update local state & storage
    setCurrentLanguageState(lang);
    localStorage.setItem('kisan_app_language', lang);
    document.documentElement.lang = lang;

    // 3. Trigger localized confirmation toast
    const langObj = getLanguageByCode(lang);
    const updatedMsg = t('common.languageUpdated', {
      defaultValue: 'Language changed to ' + langObj.nativeName + ' (' + langObj.englishName + ')',
    });
    setToastMessage(updatedMsg);

    // Auto dismiss toast after 4 seconds
    setTimeout(() => {
      setToastMessage((prev) => (prev === updatedMsg ? null : prev));
    }, 4000);

    // 4. Asynchronously persist to backend user profile if authenticated
    if (syncBackendUserId) {
      try {
        await api.updateLanguage(syncBackendUserId, lang);
      } catch (err) {
        console.warn('Could not sync language with backend:', err);
      }
    }

    setIsLanguageModalOpen(false);
  };

  const openLanguageModal = () => setIsLanguageModalOpen(true);
  const closeLanguageModal = () => setIsLanguageModalOpen(false);
  const hideToast = () => setToastMessage(null);

  const languageInfo = getLanguageByCode(currentLanguage);

  return (
    <LanguageContext.Provider
      value={{
        currentLanguage,
        languageInfo,
        setLanguage,
        supportedLanguages: SUPPORTED_LANGUAGES,
        isLanguageModalOpen,
        openLanguageModal,
        closeLanguageModal,
        toastMessage,
        hideToast,
      }}
    >
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = (): LanguageContextType => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};
