import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Phone, Lock, Globe, ArrowRight, Eye, EyeOff, AlertCircle, Info } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';

export const LoginPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const location = useLocation();
  const { languageInfo, openLanguageModal } = useLanguage();
  const { login, isAuthenticated } = useAuth();

  // Inputs start completely empty - never auto-filled or auto-logged in
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  // If already authenticated, redirect directly to dashboard or intended route
  useEffect(() => {
    if (isAuthenticated) {
      const from = (location.state as { from?: { pathname?: string } })?.from?.pathname || '/dashboard';
      navigate(from, { replace: true });
    }
  }, [isAuthenticated, navigate, location]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const cleanId = identifier.trim();
    const cleanPass = password.trim();

    if (!cleanId) {
      setError('Please enter your registered mobile number or username');
      return;
    }
    if (!cleanPass) {
      setError('Please enter your account password');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const success = await login(cleanId, cleanPass);
      if (success) {
        const from = (location.state as { from?: { pathname?: string } })?.from?.pathname || '/dashboard';
        navigate(from, { replace: true });
      }
    } catch (err: unknown) {
      if (err instanceof Error) {
        setError(err.message);
      } else {
        setError('Invalid credentials. Please verify and try again.');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleFillDemoCredentials = () => {
    setIdentifier('9876543210');
    setPassword('kisan123');
    setError('');
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
          {error && (
            <div className="auth-error-banner" role="alert">
              <AlertCircle size={18} />
              <span>{error}</span>
            </div>
          )}

          <div className="form-group">
            <label htmlFor="identifier">{t('auth.phone')} / Username</label>
            <div className="input-with-icon">
              <Phone size={18} className="input-icon" />
              <input
                id="identifier"
                type="text"
                autoComplete="username"
                value={identifier}
                onChange={(e) => {
                  setIdentifier(e.target.value);
                  if (error) setError('');
                }}
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
                type={showPassword ? 'text' : 'password'}
                autoComplete="current-password"
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value);
                  if (error) setError('');
                }}
                placeholder={t('auth.enterPassword')}
                required
              />
              <button
                type="button"
                className="password-toggle-btn"
                onClick={() => setShowPassword(!showPassword)}
                title={showPassword ? 'Hide password' : 'Show password'}
                aria-label={showPassword ? 'Hide password' : 'Show password'}
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="btn-primary btn-large full-width"
          >
            {loading ? t('common.loading') : (
              <>
                <span>{t('auth.loginBtn')}</span>
                <ArrowRight size={18} />
              </>
            )}
          </button>

          {/* Demo Credentials Helper Pill */}
          <div className="demo-credentials-box">
            <div className="demo-credentials-header">
              <Info size={14} className="text-green" />
              <span>Demo Account for Review:</span>
            </div>
            <div className="demo-credentials-content">
              <span>Mobile: <strong>9876543210</strong></span>
              <span>Password: <strong>kisan123</strong></span>
            </div>
            <button
              type="button"
              onClick={handleFillDemoCredentials}
              className="btn-text-action demo-autofill-btn"
            >
              Fill Demo Credentials
            </button>
          </div>
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
