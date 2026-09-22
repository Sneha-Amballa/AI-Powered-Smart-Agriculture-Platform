import React from 'react';
import { useTranslation } from 'react-i18next';
import { X, Check, Globe, Sparkles } from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';
import { LanguageCode } from '../../types';

export const LanguageSelectorModal: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage, supportedLanguages, isLanguageModalOpen, closeLanguageModal, setLanguage } = useLanguage();
  const { user } = useAuth();

  if (!isLanguageModalOpen) return null;

  const handleSelectLanguage = async (code: LanguageCode) => {
    await setLanguage(code, user?.id);
  };

  return (
    <div className="modal-backdrop" onClick={closeLanguageModal}>
      <div className="modal-container" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div className="modal-title-group">
            <div className="modal-icon-badge">
              <Globe size={22} className="modal-icon" />
            </div>
            <div>
              <h2 className="modal-title">{t('onboarding.chooseLanguage')}</h2>
              <p className="modal-subtitle">{t('onboarding.chooseLanguageSubtitle')}</p>
            </div>
          </div>
          <button onClick={closeLanguageModal} className="modal-close-btn" aria-label="Close">
            <X size={20} />
          </button>
        </div>

        <div className="language-grid">
          {supportedLanguages.map((lang) => {
            const isSelected = currentLanguage === lang.code;
            return (
              <button
                key={lang.code}
                onClick={() => handleSelectLanguage(lang.code)}
                className={`language-card ${isSelected ? 'selected' : ''}`}
              >
                <div className="lang-badge-row">
                  <span className="lang-code-pill">{lang.badge}</span>
                  {isSelected && (
                    <span className="lang-selected-check">
                      <Check size={16} />
                    </span>
                  )}
                </div>

                <div className="lang-text-group">
                  <span className="lang-native-name">{lang.nativeName}</span>
                  <span className="lang-english-name">{lang.englishName}</span>
                </div>

                <div className="lang-preview-box">
                  <span className="lang-greeting">{lang.greeting}!</span>
                  <p className="lang-sample">{lang.sampleText}</p>
                </div>
              </button>
            );
          })}
        </div>

        <div className="modal-footer">
          <div className="modal-footer-hint">
            <Sparkles size={16} className="hint-icon" />
            <span>{t('settings.languageDescription')}</span>
          </div>
          <button onClick={closeLanguageModal} className="btn-primary">
            {t('common.close')}
          </button>
        </div>
      </div>
    </div>
  );
};
