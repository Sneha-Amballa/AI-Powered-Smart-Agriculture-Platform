import React from 'react';
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
