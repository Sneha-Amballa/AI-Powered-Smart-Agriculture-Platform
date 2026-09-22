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
