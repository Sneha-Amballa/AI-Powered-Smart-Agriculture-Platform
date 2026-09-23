import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Settings, Globe, Check, Bell, Database, Shield, Smartphone, ArrowLeft, LogOut } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { LanguageCode } from '../types';

export const SettingsPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage, supportedLanguages, setLanguage } = useLanguage();
  const { user, logout } = useAuth();

  const handleLanguageChange = async (code: LanguageCode) => {
    await setLanguage(code, user?.id);
  };

  const handleSignOut = () => {
    logout();
    navigate('/login', { replace: true });
  };

  return (
    <div className="settings-page">
      <div className="page-header-strip">
        <div className="header-title-with-back">
          <button
            type="button"
            onClick={() => navigate('/dashboard')}
            className="btn-back-dashboard"
            title="Back to Dashboard"
          >
            <ArrowLeft size={18} />
            <span>{t('common.back') || 'Back to Dashboard'}</span>
          </button>
          <div>
            <h1 className="page-title">{t('settings.title')}</h1>
            <p className="page-subtitle">{t('settings.subtitle')}</p>
          </div>
        </div>
        <button
          type="button"
          onClick={handleSignOut}
          className="btn-secondary text-error header-action-btn"
          title="Sign Out"
        >
          <LogOut size={16} />
          <span>{t('common.logout') || 'Sign Out'}</span>
        </button>
      </div>

      {/* GLOBAL APPLICATION LANGUAGE SETTING */}
      <div className="settings-card language-management-card">
        <div className="settings-card-header">
          <div className="settings-title-wrap">
            <Globe size={24} className="text-green" />
            <div>
              <h2>{t('settings.languageTitle')}</h2>
              <p className="settings-desc">{t('settings.languageDescription')}</p>
            </div>
          </div>
        </div>

        <div className="settings-languages-grid">
          {supportedLanguages.map((lang) => {
            const isSelected = currentLanguage === lang.code;
            return (
              <button
                key={lang.code}
                type="button"
                onClick={() => handleLanguageChange(lang.code)}
                className={`settings-lang-button ${isSelected ? 'active' : ''}`}
              >
                <div className="button-top-row">
                  <span className="lang-badge-pill">{lang.badge}</span>
                  {isSelected && (
                    <span className="check-indicator">
                      <Check size={16} />
                    </span>
                  )}
                </div>

                <div className="button-titles">
                  <span className="lang-native">{lang.nativeName}</span>
                  <span className="lang-english">{lang.englishName}</span>
                </div>

                <div className="button-preview">
                  <span className="greeting">{lang.greeting}!</span>
                  <p className="sample-text">{lang.sampleText}</p>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* App Preferences */}
      <div className="settings-card">
        <div className="settings-card-header">
          <div className="settings-title-wrap">
            <Settings size={22} className="text-blue" />
            <div>
              <h3>{t('settings.appPreferences')}</h3>
              <p className="settings-desc">System configurations and offline performance</p>
            </div>
          </div>
        </div>

        <div className="preferences-list">
          <div className="pref-item">
            <div className="pref-info">
              <Database size={20} className="pref-icon text-green" />
              <div>
                <h4>{t('settings.offlineMode')}</h4>
                <p>Caches advisory history, weather reports, and schemes for offline rural access</p>
              </div>
            </div>
            <span className="pref-status-pill active">Enabled</span>
          </div>

          <div className="pref-item">
            <div className="pref-info">
              <Bell size={20} className="pref-icon text-amber" />
              <div>
                <h4>{t('settings.notifications')}</h4>
                <p>Receive timely alerts for heavy rainfall, pest outbreaks, and price surges</p>
              </div>
            </div>
            <span className="pref-status-pill active">Enabled</span>
          </div>

          <div className="pref-item">
            <div className="pref-info">
              <Smartphone size={20} className="pref-icon text-purple" />
              <div>
                <h4>Progressive Web App (PWA)</h4>
                <p>{t('settings.appVersion')} • Installable on Android & iOS homescreens</p>
              </div>
            </div>
            <span className="pref-status-pill">Ready</span>
          </div>
        </div>
      </div>
    </div>
  );
};
