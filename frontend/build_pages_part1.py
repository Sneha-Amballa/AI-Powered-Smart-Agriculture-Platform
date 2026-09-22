import os

os.makedirs('src/pages', exist_ok=True)

# 1. LandingPage.tsx
landing_code = '''import React from 'react';
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
              <button onClick={() => navigate('/dashboard')} className="btn-primary btn-large">
                <span>{t('nav.dashboard')}</span>
                <ArrowRight size={18} />
              </button>
            ) : (
              <button onClick={() => navigate('/register')} className="btn-primary btn-large">
                <span>{t('auth.registerBtn')}</span>
                <ArrowRight size={18} />
              </button>
            )}

            <button
              onClick={() => navigate('/crop-recommendation')}
              className="btn-secondary btn-large"
            >
              <span>{t('cropRecommendation.title')}</span>
              <ChevronRight size={18} />
            </button>
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
'''

with open('src/pages/LandingPage.tsx', 'w', encoding='utf-8') as f:
    f.write(landing_code)
print('LandingPage.tsx created')

# 2. RegisterPage.tsx
register_code = '''import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Globe, User, Phone, Lock, ArrowRight, Check, Sparkles } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { LanguageCode } from '../types';

export const RegisterPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage, supportedLanguages, setLanguage } = useLanguage();
  const { register } = useAuth();

  const [step, setStep] = useState<1 | 2>(1);
  const [selectedLang, setSelectedLang] = useState<LanguageCode>(currentLanguage);
  const [fullName, setFullName] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSelectLanguage = async (code: LanguageCode) => {
    setSelectedLang(code);
    await setLanguage(code);
  };

  const handleContinueToStep2 = () => {
    setStep(2);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!fullName.trim() || !phone.trim() || !password.trim()) {
      setError('Please fill in all fields');
      return;
    }
    if (phone.length < 10) {
      setError('Please enter a valid 10-digit mobile number');
      return;
    }

    setLoading(true);
    setError('');
    try {
      const success = await register(fullName, phone, password, selectedLang);
      if (success) {
        navigate('/dashboard');
      }
    } catch {
      setError('Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-card wide">
        <div className="auth-header">
          <div className="auth-step-pill">
            {step === 1 ? t('auth.step1Language') : t('auth.step2Details')}
          </div>
          <h1 className="auth-title">{t('auth.registerTitle')}</h1>
          <p className="auth-subtitle">{t('auth.registerDesc')}</p>
        </div>

        {step === 1 ? (
          /* STEP 1: Choose Your Language */
          <div className="step-language-container">
            <div className="step-instruction">
              <Globe size={20} className="text-green" />
              <h3>{t('onboarding.chooseLanguage')}</h3>
            </div>
            <p className="step-desc">{t('onboarding.chooseLanguageSubtitle')}</p>

            <div className="register-language-grid">
              {supportedLanguages.map((lang) => {
                const isSelected = selectedLang === lang.code;
                return (
                  <button
                    key={lang.code}
                    type="button"
                    onClick={() => handleSelectLanguage(lang.code)}
                    className={`lang-select-tile ${isSelected ? 'selected' : ''}`}
                  >
                    <div className="tile-top">
                      <span className="tile-badge">{lang.badge}</span>
                      {isSelected && (
                        <span className="tile-check">
                          <Check size={16} />
                        </span>
                      )}
                    </div>
                    <span className="tile-native">{lang.nativeName}</span>
                    <span className="tile-english">{lang.englishName}</span>
                    <span className="tile-greeting">{lang.greeting}!</span>
                  </button>
                );
              })}
            </div>

            <div className="step-action-row">
              <button
                type="button"
                onClick={handleContinueToStep2}
                className="btn-primary btn-large full-width"
              >
                <span>{t('onboarding.continueBtn')}</span>
                <ArrowRight size={18} />
              </button>
            </div>
          </div>
        ) : (
          /* STEP 2: Mobile & Password */
          <form onSubmit={handleSubmit} className="auth-form">
            {error && <div className="auth-error-banner">{error}</div>}

            <div className="selected-lang-summary">
              <Globe size={16} />
              <span>
                Language: <strong>{supportedLanguages.find(l => l.code === selectedLang)?.nativeName}</strong>
              </span>
              <button
                type="button"
                onClick={() => setStep(1)}
                className="btn-text-link"
              >
                {t('common.edit')}
              </button>
            </div>

            <div className="form-group">
              <label htmlFor="fullName">{t('auth.fullName')} *</label>
              <div className="input-with-icon">
                <User size={18} className="input-icon" />
                <input
                  id="fullName"
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder={t('auth.enterFullName')}
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="phone">{t('auth.phone')} *</label>
              <div className="input-with-icon">
                <Phone size={18} className="input-icon" />
                <input
                  id="phone"
                  type="tel"
                  maxLength={15}
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder={t('auth.enterPhone')}
                  required
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="password">{t('auth.password')} *</label>
              <div className="input-with-icon">
                <Lock size={18} className="input-icon" />
                <input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder={t('auth.enterPassword')}
                  required
                />
              </div>
            </div>

            <div className="form-buttons-row">
              <button
                type="button"
                onClick={() => setStep(1)}
                className="btn-secondary"
              >
                {t('common.back')}
              </button>
              <button
                type="submit"
                disabled={loading}
                className="btn-primary flex-1"
              >
                {loading ? t('common.loading') : t('auth.registerBtn')}
              </button>
            </div>
          </form>
        )}

        <div className="auth-footer">
          <p>
            {t('auth.haveAccount')}{' '}
            <Link to="/login" className="auth-link">
              {t('auth.loginBtn')}
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};
'''

with open('src/pages/RegisterPage.tsx', 'w', encoding='utf-8') as f:
    f.write(register_code)
print('RegisterPage.tsx created')

# 3. LoginPage.tsx
login_code = '''import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Phone, Lock, Globe, ArrowRight, UserCheck } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';

export const LoginPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { languageInfo, openLanguageModal } = useLanguage();
  const { login } = useAuth();

  const [phone, setPhone] = useState('9876543210');
  const [password, setPassword] = useState('kisan123');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!phone || !password) {
      setError('Please fill in mobile number and password');
      return;
    }

    setLoading(true);
    setError('');
    try {
      const success = await login(phone, password);
      if (success) {
        navigate('/dashboard');
      }
    } catch {
      setError('Invalid credentials');
    } finally {
      setLoading(false);
    }
  };

  const handleDemoLogin = async () => {
    setLoading(true);
    await login('9876543210', 'kisan123');
    setLoading(false);
    navigate('/dashboard');
  };

  return (
    <div className="auth-page">
      <div className="auth-card">
        <div className="auth-header">
          <button
            type="button"
            onClick={openLanguageModal}
            className="auth-language-switch-btn"
            title={t('common.changeLanguage')}
          >
            <Globe size={16} />
            <span>{languageInfo.nativeName} ({languageInfo.badge})</span>
          </button>

          <h1 className="auth-title">{t('auth.loginTitle')}</h1>
          <p className="auth-subtitle">{t('auth.loginDesc')}</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {error && <div className="auth-error-banner">{error}</div>}

          <div className="form-group">
            <label htmlFor="phone">{t('auth.phone')}</label>
            <div className="input-with-icon">
              <Phone size={18} className="input-icon" />
              <input
                id="phone"
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder={t('auth.enterPhone')}
                required
              />
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="password">{t('auth.password')}</label>
            <div className="input-with-icon">
              <Lock size={18} className="input-icon" />
              <input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t('auth.enterPassword')}
                required
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="btn-primary btn-large full-width"
          >
            {loading ? t('common.loading') : t('auth.loginBtn')}
          </button>

          <button
            type="button"
            onClick={handleDemoLogin}
            className="btn-secondary full-width demo-login-btn"
          >
            <UserCheck size={18} />
            <span>{t('auth.guestMode')}</span>
          </button>
        </form>

        <div className="auth-footer">
          <p>
            {t('auth.noAccount')}{' '}
            <Link to="/register" className="auth-link">
              {t('nav.register')}
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};
'''

with open('src/pages/LoginPage.tsx', 'w', encoding='utf-8') as f:
    f.write(login_code)
print('LoginPage.tsx created')
