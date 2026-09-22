import React, { useState } from 'react';
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
