import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Sprout,
  ArrowRight,
  Globe,
  CheckCircle2,
  Sparkles,
  TrendingUp,
  Brain,
  Activity,
  CloudSun,
  ShieldCheck,
  Smartphone,
  ChevronRight,
} from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { getCropDisplayName } from '../constants/crops';
import { LanguageCode } from '../types';

export const LandingPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage, supportedLanguages, setLanguage, openLanguageModal } = useLanguage();
  const { user, isAuthenticated } = useAuth();

  const handleLanguageChange = async (code: LanguageCode) => {
    await setLanguage(code, user?.id);
  };

  const featureCards = [
    {
      icon: Brain,
      title: t('cropRecommendation.title'),
      desc: t('cropRecommendation.subtitle'),
      link: '/crop-recommendation',
      tag: t('cropRecommendation.prefilledBadge'),
      highlightColor: '#16a34a',
    },
    {
      icon: Activity,
      title: t('diseaseDetection.title'),
      desc: t('diseaseDetection.subtitle'),
      link: '/disease-detection',
      tag: 'Vision AI Diagnostics',
      highlightColor: '#ea580c',
    },
    {
      icon: CloudSun,
      title: t('weather.title'),
      desc: t('weather.subtitle'),
      link: '/weather',
      tag: 'Hyperlocal & Advisories',
      highlightColor: '#0284c7',
    },
    {
      icon: TrendingUp,
      title: t('market.title'),
      desc: t('market.subtitle'),
      link: '/market',
      tag: 'Real-time APMC Mandi Rates',
      highlightColor: '#ca8a04',
    },
  ];

  const featuredCrops = ['rice', 'cotton', 'maize', 'chickpea', 'banana', 'mango'];

  return (
    <div className="landing-page">
      {/* Hero Section */}
      <section className="hero-section">
        <div className="hero-container">
          <div className="hero-badge">
            <Sparkles size={16} />
            <span>AI-Powered Precision Agriculture Platform</span>
          </div>

          <h1 className="hero-title">
            <span>{t('common.subtitle')}</span>
          </h1>

          <p className="hero-description">
            Experience smart precision farming in your mother tongue. Empowered with soil-aware crop recommendations, zero re-entry farmer profiles, instant plant pathology, and live APMC mandi wholesale prices.
          </p>

          {/* Interactive Global Language Switcher Strip directly in Hero */}
          <div className="hero-language-bar">
            <div className="lang-bar-title">
              <Globe size={18} />
              <span>{t('onboarding.chooseLanguage')}:</span>
            </div>
            <div className="lang-pill-row">
              {supportedLanguages.map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => handleLanguageChange(lang.code)}
                  className={`lang-badge-button ${currentLanguage === lang.code ? 'active' : ''}`}
                  title={`${lang.nativeName} (${lang.englishName})`}
                >
                  <span className="native">{lang.nativeName}</span>
                </button>
              ))}
              <button onClick={openLanguageModal} className="lang-more-btn">
                {t('common.viewAll')}
              </button>
            </div>
          </div>

          {/* CTA Buttons */}
          <div className="hero-cta-group">
            {isAuthenticated ? (
              <>
                <button onClick={() => navigate('/dashboard')} className="btn-primary btn-large">
                  <span>{t('nav.dashboard')}</span>
                  <ArrowRight size={18} />
                </button>
                <button
                  onClick={() => navigate('/crop-recommendation')}
                  className="btn-secondary btn-large"
                >
                  <span>{t('cropRecommendation.title')}</span>
                  <ChevronRight size={18} />
                </button>
              </>
            ) : (
              <>
                <button onClick={() => navigate('/login')} className="btn-primary btn-large">
                  <span>{t('auth.loginBtn') || 'Sign In'}</span>
                  <ArrowRight size={18} />
                </button>
                <button onClick={() => navigate('/register')} className="btn-secondary btn-large">
                  <span>{t('auth.registerBtn') || 'Sign Up'}</span>
                </button>
              </>
            )}
          </div>

          {/* Value Props Strip */}
          <div className="hero-props-strip">
            <div className="prop-item">
              <CheckCircle2 size={18} className="text-green" />
              <span>Zero-Cost Public Service</span>
            </div>
            <div className="prop-item">
              <CheckCircle2 size={18} className="text-green" />
              <span>11 Indian Languages Native First</span>
            </div>
            <div className="prop-item">
              <CheckCircle2 size={18} className="text-green" />
              <span>Zero Re-entry Intelligent Forms</span>
            </div>
          </div>
        </div>
      </section>

      {/* Controlled Crop Translation Showcase */}
      <section className="crop-showcase-section">
        <div className="section-header">
          <span className="section-pill">Controlled Localization Layer</span>
          <h2 className="section-title">Multilingual Crop Intelligence</h2>
          <p className="section-subtitle">
            Machine learning models predict canonical crop keys, mapped dynamically into each Indian language without data corruption.
          </p>
        </div>

        <div className="crop-pills-container">
          {featuredCrops.map((rawKey) => {
            const localizedName = getCropDisplayName(rawKey, currentLanguage);
            return (
              <div key={rawKey} className="crop-pill-card">
                <span className="crop-canonical-tag">{rawKey}</span>
                <span className="crop-localized-title">{localizedName}</span>
              </div>
            );
          })}
        </div>
      </section>

      {/* Feature Cards Grid */}
      <section className="features-section">
        <div className="section-header">
          <span className="section-pill">{t('dashboard.quickActions')}</span>
          <h2 className="section-title">Unified Precision Agriculture Modules</h2>
          <p className="section-subtitle">
            Everything an Indian farmer needs for higher yields, lower fertilizer costs, and fair market prices.
          </p>
        </div>

        <div className="features-grid">
          {featureCards.map((card, idx) => {
            const Icon = card.icon;
            return (
              <Link to={card.link} key={idx} className="feature-card">
                <div className="feature-card-header">
                  <div className="feature-icon" style={{ backgroundColor: `${card.highlightColor}15`, color: card.highlightColor }}>
                    <Icon size={24} />
                  </div>
                  <span className="feature-tag">{card.tag}</span>
                </div>
                <h3 className="feature-title">{card.title}</h3>
                <p className="feature-desc">{card.desc}</p>
                <div className="feature-link-row">
                  <span>{t('common.viewDetails')}</span>
                  <ArrowRight size={16} />
                </div>
              </Link>
            );
          })}
        </div>
      </section>

      {/* Zero Re-entry Callout */}
      <section className="zero-reentry-callout">
        <div className="callout-card">
          <div className="callout-content">
            <span className="callout-badge">Exclusive UX Innovation</span>
            <h2>Zero Data Re-entry Architecture</h2>
            <p>
              Once a farmer sets up their profile or enters their soil parameters, every module—from Crop Recommendation to Fertilizer Schedules and Market Advisories—automatically pre-populates your details. You never have to type the same data twice.
            </p>
            <button onClick={() => navigate('/crop-recommendation')} className="btn-primary">
              {t('cropRecommendation.analyzeBtn')}
            </button>
          </div>
        </div>
      </section>
    </div>
  );
};
