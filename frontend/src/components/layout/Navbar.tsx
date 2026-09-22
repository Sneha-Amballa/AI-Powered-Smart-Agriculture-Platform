import React, { useState } from 'react';
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
