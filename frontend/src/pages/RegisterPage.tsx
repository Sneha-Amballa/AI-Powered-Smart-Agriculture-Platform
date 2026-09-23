import React, { useState } from 'react';
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

            <div className="selected-lang-summary" style={{ display: 'flex', flexDirection: 'column', gap: '8px', alignItems: 'stretch' }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem', color: 'var(--text-secondary)' }}>
                  <Globe size={16} className="text-green" />
                  <span>{t('onboarding.chooseLanguage')}:</span>
                </div>
                <button
                  type="button"
                  onClick={() => setStep(1)}
                  className="btn-text-link"
                  style={{ fontSize: '0.85rem' }}
                >
                  {t('common.viewAll')}
                </button>
              </div>

              {/* 1-Tap Language Switcher Pills */}
              <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                {supportedLanguages.map((lang) => {
                  const isSelected = selectedLang === lang.code;
                  return (
                    <button
                      key={lang.code}
                      type="button"
                      onClick={() => handleSelectLanguage(lang.code)}
                      className={`lang-pill-btn ${isSelected ? 'active' : ''}`}
                      style={{
                        padding: '6px 14px',
                        borderRadius: '20px',
                        border: isSelected ? '2px solid var(--color-primary)' : '1px solid var(--card-border)',
                        background: isSelected ? 'var(--color-primary-light, #e8f5e9)' : 'var(--surface-bg, #fff)',
                        color: isSelected ? 'var(--color-primary-dark, #1b5e20)' : 'var(--text-primary)',
                        fontWeight: isSelected ? 700 : 500,
                        fontSize: '0.875rem',
                        cursor: 'pointer',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '6px',
                        transition: 'all 0.15s ease',
                      }}
                    >
                      <span>{lang.nativeName}</span>
                      <span style={{ fontSize: '0.75rem', opacity: 0.8 }}>({lang.badge})</span>
                      {isSelected && <Check size={14} />}
                    </button>
                  );
                })}
              </div>
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
