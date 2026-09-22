import React from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Brain,
  Activity,
  CloudSun,
  TrendingUp,
  Landmark,
  Bot,
  ArrowRight,
  Sparkles,
  Thermometer,
  Droplets,
  Wind,
  CheckCircle2,
  Calendar,
  Layers,
  Award,
} from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { getCropDisplayName } from '../constants/crops';

export const DashboardPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage } = useLanguage();
  const { user, profile } = useAuth();

  const farmDetails = profile?.farm_details;
  const farmerName = user?.full_name || 'Farmer';
  const locationText = `${profile?.village || 'Tenali'}, ${profile?.district || 'Guntur'}, ${profile?.state || 'Andhra Pradesh'}`;

  const topMandiRates = [
    { crop: 'rice', price: 2320, trend: '+3.2%', market: 'Guntur APMC' },
    { crop: 'cotton', price: 7150, trend: '+1.8%', market: 'Warangal APMC' },
    { crop: 'chickpea', price: 5400, trend: '-0.5%', market: 'Indore Mandi' },
    { crop: 'maize', price: 2180, trend: '+2.1%', market: 'Khammam APMC' },
  ];

  return (
    <div className="dashboard-page">
      {/* Welcome Hero Banner */}
      <section className="dashboard-hero">
        <div className="dash-hero-content">
          <div className="dash-hero-badge">
            <Sparkles size={16} />
            <span>{t('dashboard.greetingSubtitle')}</span>
          </div>
          <h1 className="dash-greeting">
            {t('dashboard.welcome')}, <span>{farmerName}</span>
          </h1>
          <p className="dash-location">
            {locationText} • {farmDetails?.land_area || 3.5} {farmDetails?.area_unit || 'Acres'} • {farmDetails?.soil_type || 'Clay Loam'}
          </p>
        </div>

        <div className="dash-hero-action">
          <button
            onClick={() => navigate('/crop-recommendation')}
            className="btn-primary btn-large glow-btn"
          >
            <Brain size={20} />
            <span>{t('dashboard.startAnalysis')}</span>
          </button>
        </div>
      </section>

      {/* Top 3 Summary Cards */}
      <div className="dash-summary-grid">
        {/* Weather Snapshot */}
        <div className="dash-card weather-snapshot">
          <div className="dash-card-header">
            <div className="card-title-group">
              <CloudSun size={20} className="card-icon blue" />
              <h3>{t('dashboard.weatherCard')}</h3>
            </div>
            <Link to="/weather" className="card-link">
              {t('common.viewDetails')}
            </Link>
          </div>
          <div className="weather-quick-body">
            <div className="temp-display">
              <span className="big-temp">31°C</span>
              <span className="weather-desc">Partly Cloudy • Humid</span>
            </div>
            <div className="weather-metrics-row">
              <div className="metric-chip">
                <Droplets size={14} />
                <span>68% Humidity</span>
              </div>
              <div className="metric-chip">
                <Wind size={14} />
                <span>14 km/h Wind</span>
              </div>
            </div>
            <p className="weather-advisory-snippet">
              Ideal conditions for Kharif top dressing. High morning moisture favorable for nutrient absorption.
            </p>
          </div>
        </div>

        {/* Soil Health Status (Zero Re-entry reflection) */}
        <div className="dash-card soil-snapshot">
          <div className="dash-card-header">
            <div className="card-title-group">
              <Layers size={20} className="card-icon green" />
              <h3>{t('dashboard.soilCard')}</h3>
            </div>
            <Link to="/profile" className="card-link">
              {t('common.edit')}
            </Link>
          </div>
          <div className="soil-quick-body">
            <div className="npk-chips-row">
              <div className="npk-badge n">
                <span className="label">N</span>
                <span className="val">{farmDetails?.nitrogen_n ?? 78}</span>
                <span className="unit">kg/ha</span>
              </div>
              <div className="npk-badge p">
                <span className="label">P</span>
                <span className="val">{farmDetails?.phosphorus_p ?? 42}</span>
                <span className="unit">kg/ha</span>
              </div>
              <div className="npk-badge k">
                <span className="label">K</span>
                <span className="val">{farmDetails?.potassium_k ?? 48}</span>
                <span className="unit">kg/ha</span>
              </div>
              <div className="npk-badge ph">
                <span className="label">pH</span>
                <span className="val">{farmDetails?.ph_level ?? 6.8}</span>
                <span className="unit">Neutral</span>
              </div>
            </div>
            <div className="soil-status-text">
              <CheckCircle2 size={16} className="text-green" />
              <span>{t('dashboard.soilOptimal')}</span>
            </div>
          </div>
        </div>

        {/* Crop Recommendation CTA Card */}
        <div className="dash-card recommend-cta-card">
          <div className="dash-card-header">
            <div className="card-title-group">
              <Brain size={20} className="card-icon purple" />
              <h3>{t('dashboard.cropRecommendCard')}</h3>
            </div>
            <span className="badge-zero-reentry">Zero Re-entry</span>
          </div>
          <p className="cta-description">
            {t('dashboard.cropRecommendPrompt')}
          </p>
          <div className="prefilled-preview-pill">
            <span>Pre-filled: <strong>{locationText.split(',')[1]}</strong> • N:{farmDetails?.nitrogen_n ?? 78} P:{farmDetails?.phosphorus_p ?? 42}</span>
          </div>
          <button
            onClick={() => navigate('/crop-recommendation')}
            className="btn-primary full-width"
          >
            <span>{t('cropRecommendation.analyzeBtn')}</span>
            <ArrowRight size={16} />
          </button>
        </div>
      </div>

      {/* Quick Action Navigation Tiles */}
      <section className="dash-tools-section">
        <h2 className="dash-section-title">{t('dashboard.quickActions')}</h2>
        <div className="dash-tools-grid">
          <Link to="/crop-recommendation" className="tool-tile">
            <div className="tool-icon-box green">
              <Brain size={24} />
            </div>
            <h4>{t('nav.cropRecommendation')}</h4>
            <p>Smart soil & climate matching</p>
          </Link>

          <Link to="/disease-detection" className="tool-tile">
            <div className="tool-icon-box orange">
              <Activity size={24} />
            </div>
            <h4>{t('nav.diseaseDetection')}</h4>
            <p>Instant leaf pathology check</p>
          </Link>

          <Link to="/weather" className="tool-tile">
            <div className="tool-icon-box blue">
              <CloudSun size={24} />
            </div>
            <h4>{t('nav.weather')}</h4>
            <p>Spray & irrigation advisories</p>
          </Link>

          <Link to="/market" className="tool-tile">
            <div className="tool-icon-box yellow">
              <TrendingUp size={24} />
            </div>
            <h4>{t('nav.market')}</h4>
            <p>APMC wholesale mandi rates</p>
          </Link>

          <Link to="/schemes" className="tool-tile">
            <div className="tool-icon-box indigo">
              <Landmark size={24} />
            </div>
            <h4>{t('nav.schemes')}</h4>
            <p>PM-KISAN, subsidies & loans</p>
          </Link>

          <Link to="/assistant" className="tool-tile">
            <div className="tool-icon-box emerald">
              <Bot size={24} />
            </div>
            <h4>{t('nav.assistant')}</h4>
            <p>24/7 localized farming AI</p>
          </Link>
        </div>
      </section>

      {/* Live Mandi Rates Highlight */}
      <section className="dash-mandi-section">
        <div className="dash-section-header">
          <h2 className="dash-section-title">{t('dashboard.mandiHighlights')}</h2>
          <Link to="/market" className="dash-see-all">
            {t('common.viewAll')} <ArrowRight size={16} />
          </Link>
        </div>

        <div className="mandi-cards-row">
          {topMandiRates.map((item, idx) => {
            const localizedCrop = getCropDisplayName(item.crop, currentLanguage);
            return (
              <div key={idx} className="mandi-quick-card">
                <div className="mandi-quick-top">
                  <span className="mandi-crop-name">{localizedCrop}</span>
                  <span className="mandi-trend positive">{item.trend}</span>
                </div>
                <div className="mandi-price-row">
                  <span className="mandi-price">₹{item.price.toLocaleString('en-IN')}</span>
                  <span className="mandi-unit">/ Quintal</span>
                </div>
                <span className="mandi-location">{item.market}</span>
              </div>
            );
          })}
        </div>
      </section>
    </div>
  );
};
