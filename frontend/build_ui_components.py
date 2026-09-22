import os

os.makedirs('src/components/common', exist_ok=True)
os.makedirs('src/components/layout', exist_ok=True)

# 1. Toast.tsx
toast_code = '''import React from 'react';
import { CheckCircle2, X } from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';

export const Toast: React.FC = () => {
  const { toastMessage, hideToast } = useLanguage();

  if (!toastMessage) return null;

  return (
    <div className="toast-container" role="alert" aria-live="assertive">
      <div className="toast-card">
        <div className="toast-icon-box">
          <CheckCircle2 size={20} className="toast-icon" />
        </div>
        <div className="toast-content">
          <p className="toast-title">{toastMessage}</p>
        </div>
        <button onClick={hideToast} className="toast-close-btn" aria-label="Close notification">
          <X size={16} />
        </button>
      </div>
    </div>
  );
};
'''

with open('src/components/common/Toast.tsx', 'w', encoding='utf-8') as f:
    f.write(toast_code)
print('Toast.tsx created')

# 2. LanguageSelectorModal.tsx
modal_code = '''import React from 'react';
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
'''

with open('src/components/common/LanguageSelectorModal.tsx', 'w', encoding='utf-8') as f:
    f.write(modal_code)
print('LanguageSelectorModal.tsx created')

# 3. Navbar.tsx
navbar_code = '''import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Sprout,
  Globe,
  Menu,
  X,
  User as UserIcon,
  LayoutDashboard,
  Brain,
  History,
  Activity,
  CloudSun,
  TrendingUp,
  Landmark,
  Bot,
  Settings,
} from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';

export const Navbar: React.FC = () => {
  const { t } = useTranslation();
  const location = useLocation();
  const { languageInfo, openLanguageModal } = useLanguage();
  const { user } = useAuth();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const navLinks = [
    { to: '/dashboard', label: t('nav.dashboard'), icon: LayoutDashboard },
    { to: '/crop-recommendation', label: t('nav.cropRecommendation'), icon: Brain },
    { to: '/crop-history', label: t('nav.cropHistory'), icon: History },
    { to: '/disease-detection', label: t('nav.diseaseDetection'), icon: Activity },
    { to: '/weather', label: t('nav.weather'), icon: CloudSun },
    { to: '/market', label: t('nav.market'), icon: TrendingUp },
    { to: '/schemes', label: t('nav.schemes'), icon: Landmark },
    { to: '/assistant', label: t('nav.assistant'), icon: Bot },
  ];

  const closeMenu = () => setIsMobileMenuOpen(false);

  return (
    <header className="navbar-header">
      <div className="navbar-container">
        {/* Brand Logo */}
        <Link to="/" className="navbar-brand" onClick={closeMenu}>
          <div className="brand-logo-icon">
            <Sprout size={24} />
          </div>
          <div className="brand-text">
            <span className="brand-name">{t('common.appName')}</span>
            <span className="brand-tagline">AI Smart Farming</span>
          </div>
        </Link>

        {/* Desktop Nav Links */}
        <nav className="navbar-links desktop-only">
          {navLinks.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.to;
            return (
              <Link
                key={item.to}
                to={item.to}
                className={`nav-link ${isActive ? 'active' : ''}`}
              >
                <Icon size={16} />
                <span>{item.label}</span>
              </Link>
            );
          })}
        </nav>

        {/* Actions (Language Pill + Profile) */}
        <div className="navbar-actions">
          {/* Global Language Selector Button */}
          <button
            onClick={openLanguageModal}
            className="language-pill-btn"
            title={t('common.changeLanguage')}
          >
            <Globe size={16} className="globe-icon" />
            <span className="language-badge-native">{languageInfo.nativeName}</span>
            <span className="language-badge-code">({languageInfo.badge})</span>
          </button>

          {/* Profile / Settings link */}
          <Link to="/profile" className="profile-btn desktop-only" title={t('nav.profile')}>
            <UserIcon size={18} />
            <span className="profile-name">{user?.full_name?.split(' ')[0] || 'Farmer'}</span>
          </Link>

          <Link to="/settings" className="settings-icon-btn desktop-only" title={t('nav.settings')}>
            <Settings size={18} />
          </Link>

          {/* Mobile Menu Toggle */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="mobile-menu-btn"
            aria-label="Toggle Navigation"
          >
            {isMobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      {/* Mobile Menu Drawer */}
      {isMobileMenuOpen && (
        <div className="mobile-drawer">
          <div className="mobile-drawer-content">
            <button
              onClick={() => {
                openLanguageModal();
                closeMenu();
              }}
              className="mobile-language-select-btn"
            >
              <Globe size={18} />
              <span>{t('common.changeLanguage')}: <strong>{languageInfo.nativeName} ({languageInfo.englishName})</strong></span>
            </button>

            <div className="mobile-nav-list">
              {navLinks.map((item) => {
                const Icon = item.icon;
                const isActive = location.pathname === item.to;
                return (
                  <Link
                    key={item.to}
                    to={item.to}
                    onClick={closeMenu}
                    className={`mobile-nav-item ${isActive ? 'active' : ''}`}
                  >
                    <Icon size={20} />
                    <span>{item.label}</span>
                  </Link>
                );
              })}
              <Link to="/profile" onClick={closeMenu} className="mobile-nav-item">
                <UserIcon size={20} />
                <span>{t('nav.profile')}</span>
              </Link>
              <Link to="/settings" onClick={closeMenu} className="mobile-nav-item">
                <Settings size={20} />
                <span>{t('nav.settings')}</span>
              </Link>
            </div>
          </div>
        </div>
      )}
    </header>
  );
};
'''

with open('src/components/layout/Navbar.tsx', 'w', encoding='utf-8') as f:
    f.write(navbar_code)
print('Navbar.tsx created')

# 4. Footer.tsx
footer_code = '''import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Sprout, Globe, Heart, ShieldCheck, ExternalLink } from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';
import { LanguageCode } from '../../types';

export const Footer: React.FC = () => {
  const { t } = useTranslation();
  const { supportedLanguages, currentLanguage, setLanguage, openLanguageModal } = useLanguage();
  const { user } = useAuth();

  return (
    <footer className="app-footer">
      <div className="footer-top-container">
        {/* Brand Column */}
        <div className="footer-brand-col">
          <div className="footer-logo">
            <Sprout size={24} className="brand-icon" />
            <span className="brand-text">{t('common.appName')}</span>
          </div>
          <p className="footer-desc">
            {t('common.subtitle')}. Empowering Indian farmers with precision soil analytics, localized crop advice, and real-time market insights.
          </p>
          <div className="footer-badge">
            <ShieldCheck size={16} />
            <span>Zero-Cost Public Good Architecture</span>
          </div>
        </div>

        {/* Quick Language Switcher Bar in Footer */}
        <div className="footer-languages-col">
          <div className="footer-col-header">
            <Globe size={18} />
            <h4>{t('onboarding.chooseLanguage')}</h4>
          </div>
          <p className="footer-subtext">Click any language to instantly translate the entire platform:</p>
          <div className="footer-lang-tags">
            {supportedLanguages.map((lang) => (
              <button
                key={lang.code}
                onClick={() => setLanguage(lang.code as LanguageCode, user?.id)}
                className={`footer-lang-btn ${currentLanguage === lang.code ? 'active' : ''}`}
              >
                <span className="native">{lang.nativeName}</span>
                <span className="english">({lang.badge})</span>
              </button>
            ))}
          </div>
        </div>

        {/* Agricultural Resources */}
        <div className="footer-links-col">
          <h4>Farmer Resources</h4>
          <ul className="footer-links">
            <li>
              <a href="https://pmkisan.gov.in" target="_blank" rel="noopener noreferrer">
                <span>PM-KISAN Portal</span>
                <ExternalLink size={12} />
              </a>
            </li>
            <li>
              <a href="https://soilhealth.dac.gov.in" target="_blank" rel="noopener noreferrer">
                <span>Soil Health Card Portal</span>
                <ExternalLink size={12} />
              </a>
            </li>
            <li>
              <a href="https://agmarknet.gov.in" target="_blank" rel="noopener noreferrer">
                <span>Agmarknet Mandi Rates</span>
                <ExternalLink size={12} />
              </a>
            </li>
            <li>
              <Link to="/schemes">{t('nav.schemes')}</Link>
            </li>
            <li>
              <Link to="/crop-recommendation">{t('nav.cropRecommendation')}</Link>
            </li>
          </ul>
        </div>
      </div>

      <div className="footer-bottom-bar">
        <p className="copyright-text">
          &copy; {new Date().getFullYear()} {t('common.appName')} — Precision Agriculture for Bharat.
        </p>
        <p className="built-with">
          Crafted with <Heart size={14} className="heart-icon" /> for Indian Farmers
        </p>
      </div>
    </footer>
  );
};
'''

with open('src/components/layout/Footer.tsx', 'w', encoding='utf-8') as f:
    f.write(footer_code)
print('Footer.tsx created')
