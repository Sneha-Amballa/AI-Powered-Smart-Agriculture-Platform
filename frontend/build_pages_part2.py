import os

os.makedirs('src/pages', exist_ok=True)

# 1. DashboardPage.tsx
dashboard_code = '''import React from 'react';
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
'''

with open('src/pages/DashboardPage.tsx', 'w', encoding='utf-8') as f:
    f.write(dashboard_code)
print('DashboardPage.tsx created')

# 2. CropRecommendationPage.tsx (ZERO RE-ENTRY UX + CONTROLLED MULTILINGUAL CROP TRANSLATION)
crop_rec_code = '''import React, { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Brain,
  Sparkles,
  CheckCircle2,
  RefreshCw,
  History,
  TrendingUp,
  AlertTriangle,
  Droplets,
  Calendar,
  Layers,
  MapPin,
  ChevronRight,
  ShieldCheck,
  RotateCcw,
} from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { getCropDisplayName, CROP_DURATIONS, CROP_SEASONS } from '../constants/crops';
import { CropRecommendationInput, CropRecommendationResult } from '../types';
import { api, generateSmartRecommendation } from '../services/api';

export const CropRecommendationPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage } = useLanguage();
  const { profile } = useAuth();

  // Zero Re-entry initialization: Automatically pulls from farmer profile
  const farmDetails = profile?.farm_details;

  const [nitrogen, setNitrogen] = useState<number>(farmDetails?.nitrogen_n ?? 78);
  const [phosphorus, setPhosphorus] = useState<number>(farmDetails?.phosphorus_p ?? 42);
  const [potassium, setPotassium] = useState<number>(farmDetails?.potassium_k ?? 48);
  const [phLevel, setPhLevel] = useState<number>(farmDetails?.ph_level ?? 6.8);
  const [temperature, setTemperature] = useState<number>(28.5);
  const [humidity, setHumidity] = useState<number>(72);
  const [rainfall, setRainfall] = useState<number>(185);

  const [state, setState] = useState<string>(profile?.state ?? 'Andhra Pradesh');
  const [district, setDistrict] = useState<string>(profile?.district ?? 'Guntur');
  const [landArea, setLandArea] = useState<number>(farmDetails?.land_area ?? 3.5);
  const [areaUnit, setAreaUnit] = useState<string>(farmDetails?.area_unit ?? 'Acres');
  const [irrigationType, setIrrigationType] = useState<string>(farmDetails?.irrigation_type ?? 'Canal & Borewell');

  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<CropRecommendationResult | null>(null);
  const [saveSuccessMsg, setSaveSuccessMsg] = useState('');

  // Initial load runs pre-filled analysis automatically for Zero Re-entry delight
  useEffect(() => {
    const input: CropRecommendationInput = {
      nitrogen_n: nitrogen,
      phosphorus_p: phosphorus,
      potassium_k: potassium,
      ph_level: phLevel,
      temperature,
      humidity,
      rainfall,
      state,
      district,
      landArea,
      area_unit: areaUnit,
      irrigation_type: irrigationType,
    };
    const initialResult = generateSmartRecommendation(input);
    setResult(initialResult);
  }, []);

  const handleResetToProfile = () => {
    setNitrogen(farmDetails?.nitrogen_n ?? 78);
    setPhosphorus(farmDetails?.phosphorus_p ?? 42);
    setPotassium(farmDetails?.potassium_k ?? 48);
    setPhLevel(farmDetails?.ph_level ?? 6.8);
    setState(profile?.state ?? 'Andhra Pradesh');
    setDistrict(profile?.district ?? 'Guntur');
    setLandArea(farmDetails?.land_area ?? 3.5);
  };

  const handleAnalyze = async () => {
    setLoading(true);
    setSaveSuccessMsg('');
    const input: CropRecommendationInput = {
      nitrogen_n: nitrogen,
      phosphorus_p: phosphorus,
      potassium_k: potassium,
      ph_level: phLevel,
      temperature,
      humidity,
      rainfall,
      state,
      district,
      landArea,
      area_unit: areaUnit,
      irrigation_type: irrigationType,
    };

    try {
      const res = await api.getCropRecommendation(input, currentLanguage);
      setResult(res);
    } catch {
      const fallback = generateSmartRecommendation(input);
      setResult(fallback);
    } finally {
      setLoading(false);
    }
  };

  const handleSaveToHistory = () => {
    if (!result) return;
    try {
      const existing = localStorage.getItem('kisan_crop_history');
      const list = existing ? JSON.parse(existing) : [];
      list.unshift(result);
      localStorage.setItem('kisan_crop_history', JSON.stringify(list));
      setSaveSuccessMsg(t('cropRecommendation.savedSuccess'));
      setTimeout(() => setSaveSuccessMsg(''), 4000);
    } catch (err) {
      console.warn('Could not save history:', err);
    }
  };

  return (
    <div className="crop-rec-page">
      {/* Page Header */}
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('cropRecommendation.title')}</h1>
          <p className="page-subtitle">{t('cropRecommendation.subtitle')}</p>
        </div>
        <Link to="/crop-history" className="btn-secondary header-action-btn">
          <History size={18} />
          <span>{t('cropRecommendation.viewHistory')}</span>
        </Link>
      </div>

      {/* ZERO RE-ENTRY PROMINENT BANNER */}
      <div className="zero-reentry-banner">
        <div className="zero-banner-icon">
          <Sparkles size={24} />
        </div>
        <div className="zero-banner-text">
          <div className="zero-banner-tag">{t('cropRecommendation.prefilledBadge')}</div>
          <p className="zero-banner-desc">{t('cropRecommendation.prefilledExpl')}</p>
          <div className="zero-banner-details">
            <span>Location: <strong>{district}, {state}</strong></span>
            <span>Land: <strong>{landArea} {areaUnit}</strong></span>
            <span>Soil: <strong>{farmDetails?.soil_type || 'Clay Loam'}</strong></span>
          </div>
        </div>
        <button
          type="button"
          onClick={handleResetToProfile}
          className="btn-text-action"
          title={t('cropRecommendation.resetValues')}
        >
          <RotateCcw size={16} />
          <span>{t('cropRecommendation.resetValues')}</span>
        </button>
      </div>

      <div className="crop-rec-layout">
        {/* Left Side: Interactive Parameter Sliders & Adjusters */}
        <div className="parameters-panel">
          <div className="panel-header">
            <div className="panel-title-group">
              <Layers size={20} className="text-green" />
              <h3>{t('cropRecommendation.parametersSection')}</h3>
            </div>
          </div>

          <div className="param-inputs-grid">
            {/* Nitrogen Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="nitrogen">{t('cropRecommendation.nitrogenLabel')}</label>
                <span className="param-badge">{nitrogen}</span>
              </div>
              <input
                id="nitrogen"
                type="range"
                min="0"
                max="140"
                value={nitrogen}
                onChange={(e) => setNitrogen(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>0</span>
                <span>Optimal: 70-90</span>
                <span>140</span>
              </div>
            </div>

            {/* Phosphorus Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="phosphorus">{t('cropRecommendation.phosphorusLabel')}</label>
                <span className="param-badge">{phosphorus}</span>
              </div>
              <input
                id="phosphorus"
                type="range"
                min="0"
                max="100"
                value={phosphorus}
                onChange={(e) => setPhosphorus(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>0</span>
                <span>Optimal: 35-50</span>
                <span>100</span>
              </div>
            </div>

            {/* Potassium Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="potassium">{t('cropRecommendation.potassiumLabel')}</label>
                <span className="param-badge">{potassium}</span>
              </div>
              <input
                id="potassium"
                type="range"
                min="0"
                max="100"
                value={potassium}
                onChange={(e) => setPotassium(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>0</span>
                <span>Optimal: 40-60</span>
                <span>100</span>
              </div>
            </div>

            {/* pH Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="phLevel">{t('cropRecommendation.phLabel')}</label>
                <span className="param-badge">{phLevel.toFixed(1)}</span>
              </div>
              <input
                id="phLevel"
                type="range"
                min="4.0"
                max="9.0"
                step="0.1"
                value={phLevel}
                onChange={(e) => setPhLevel(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>4.0 (Acidic)</span>
                <span>6.5 - 7.5 (Neutral)</span>
                <span>9.0 (Alkaline)</span>
              </div>
            </div>

            {/* Rainfall Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="rainfall">{t('cropRecommendation.rainfallLabel')}</label>
                <span className="param-badge">{rainfall} mm</span>
              </div>
              <input
                id="rainfall"
                type="range"
                min="20"
                max="300"
                value={rainfall}
                onChange={(e) => setRainfall(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>20 mm</span>
                <span>Expected: 150-220 mm</span>
                <span>300 mm</span>
              </div>
            </div>

            {/* Temperature Slider */}
            <div className="param-card">
              <div className="param-header">
                <label htmlFor="temperature">{t('cropRecommendation.tempLabel')}</label>
                <span className="param-badge">{temperature}°C</span>
              </div>
              <input
                id="temperature"
                type="range"
                min="10"
                max="45"
                step="0.5"
                value={temperature}
                onChange={(e) => setTemperature(Number(e.target.value))}
                className="param-slider"
              />
              <div className="param-range-labels">
                <span>10°C</span>
                <span>Season: 26-32°C</span>
                <span>45°C</span>
              </div>
            </div>
          </div>

          <button
            type="button"
            onClick={handleAnalyze}
            disabled={loading}
            className="btn-primary btn-large full-width analyze-trigger-btn"
          >
            {loading ? (
              <>
                <RefreshCw size={18} className="spin-icon" />
                <span>{t('cropRecommendation.analyzing')}</span>
              </>
            ) : (
              <>
                <Brain size={20} />
                <span>{t('cropRecommendation.analyzeBtn')}</span>
              </>
            )}
          </button>
        </div>

        {/* Right Side: ML Recommendation Result Card with Multilingual Controlled Translation Layer */}
        {result && (
          <div className="recommendation-result-panel">
            {saveSuccessMsg && (
              <div className="save-toast-banner">
                <CheckCircle2 size={18} />
                <span>{saveSuccessMsg}</span>
              </div>
            )}

            {/* Main Crop Result Hero */}
            <div className="rec-hero-card">
              <div className="rec-hero-top">
                <div className="rec-title-wrap">
                  <span className="rec-label">{t('cropRecommendation.resultTitle')}</span>
                  {/* CONTROLLED MULTILINGUAL CROP TRANSLATION */}
                  <h2 className="rec-crop-name">
                    {getCropDisplayName(result.recommended_crop, currentLanguage)}
                  </h2>
                  <span className="rec-canonical-code">Canonical: {result.recommended_crop}</span>
                </div>

                <div className="confidence-meter-box">
                  <span className="confidence-val">{Math.round(result.confidence * 100)}%</span>
                  <span className="confidence-label">{t('cropRecommendation.confidence')}</span>
                </div>
              </div>

              {/* Rationale in Active Language */}
              <div className="rec-rationale-box">
                <h4>{t('cropRecommendation.whyRecommended')}</h4>
                <p>{result.reason}</p>
              </div>

              {/* Meta Stats Row */}
              <div className="rec-meta-grid">
                <div className="rec-meta-item">
                  <Calendar size={18} />
                  <div>
                    <span className="meta-label">{t('cropRecommendation.duration')}</span>
                    <span className="meta-val">{CROP_DURATIONS[result.recommended_crop] || result.duration_days}</span>
                  </div>
                </div>

                <div className="rec-meta-item">
                  <Sparkles size={18} />
                  <div>
                    <span className="meta-label">{t('cropRecommendation.suitability')}</span>
                    <span className="meta-val">{CROP_SEASONS[result.recommended_crop] || result.seasonal_suitability}</span>
                  </div>
                </div>

                <div className="rec-meta-item">
                  <ShieldCheck size={18} />
                  <div>
                    <span className="meta-label">{t('cropRecommendation.soilMatch')}</span>
                    <span className="meta-val">{result.soilMatch}% Perfect Match</span>
                  </div>
                </div>
              </div>

              {/* Alternative Crops with Controlled Translation */}
              {result.alternate_crops && result.alternate_crops.length > 0 && (
                <div className="alternate-crops-section">
                  <span className="alt-label">{t('cropRecommendation.alternateCrops')}:</span>
                  <div className="alt-pills">
                    {result.alternate_crops.map((altKey) => (
                      <span key={altKey} className="alt-pill">
                        {getCropDisplayName(altKey, currentLanguage)}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Economics Card */}
            <div className="rec-detail-card">
              <div className="card-heading-row">
                <TrendingUp size={20} className="text-green" />
                <h3>{t('cropRecommendation.economicsTitle')}</h3>
              </div>
              <div className="economics-grid">
                <div className="econ-item">
                  <span className="econ-label">{t('cropRecommendation.costPerAcre')}</span>
                  <span className="econ-val">₹{result.economics.estimated_cost_per_acre.toLocaleString('en-IN')}</span>
                </div>
                <div className="econ-item">
                  <span className="econ-label">{t('cropRecommendation.yieldPerAcre')}</span>
                  <span className="econ-val">{result.economics.estimated_yield_per_acre}</span>
                </div>
                <div className="econ-item">
                  <span className="econ-label">{t('cropRecommendation.revenuePerAcre')}</span>
                  <span className="econ-val">₹{result.economics.estimated_revenue_per_acre.toLocaleString('en-IN')}</span>
                </div>
                <div className="econ-item highlight">
                  <span className="econ-label">{t('cropRecommendation.profitPotential')}</span>
                  <span className="econ-val">{result.economics.profit_potential}</span>
                </div>
              </div>
            </div>

            {/* Fertilizer Nutrition Schedule */}
            <div className="rec-detail-card">
              <div className="card-heading-row">
                <Droplets size={20} className="text-blue" />
                <h3>{t('cropRecommendation.fertilizerTitle')}</h3>
              </div>
              <div className="fertilizer-chips-row">
                <div className="fert-chip">
                  <span className="fert-name">{t('cropRecommendation.urea')}</span>
                  <span className="fert-val">{result.fertilizer_recommendation.urea_kg} kg/acre</span>
                </div>
                <div className="fert-chip">
                  <span className="fert-name">{t('cropRecommendation.dap')}</span>
                  <span className="fert-val">{result.fertilizer_recommendation.dap_kg} kg/acre</span>
                </div>
                <div className="fert-chip">
                  <span className="fert-name">{t('cropRecommendation.mop')}</span>
                  <span className="fert-val">{result.fertilizer_recommendation.mop_kg} kg/acre</span>
                </div>
                <div className="fert-chip">
                  <span className="fert-name">{t('cropRecommendation.organicCompost')}</span>
                  <span className="fert-val">{result.fertilizer_recommendation.organic_compost_tons} Tons</span>
                </div>
              </div>
              <p className="fert-schedule-text">
                <strong>Application Schedule:</strong> {result.fertilizer_recommendation.schedule}
              </p>
            </div>

            {/* Irrigation & Risks */}
            <div className="rec-detail-card">
              <div className="card-heading-row">
                <AlertTriangle size={20} className="text-amber" />
                <h3>{t('cropRecommendation.irrigationTitle')}</h3>
              </div>
              <p className="irrigation-text">{result.irrigation_guideline}</p>
              <ul className="risk-factors-list">
                {result.risk_factors.map((risk, idx) => (
                  <li key={idx}>{risk}</li>
                ))}
              </ul>
            </div>

            {/* Action Bar */}
            <div className="rec-action-bar">
              <button
                type="button"
                onClick={handleSaveToHistory}
                className="btn-primary"
              >
                <CheckCircle2 size={18} />
                <span>{t('cropRecommendation.saveHistory')}</span>
              </button>
              <Link to="/crop-history" className="btn-secondary">
                <span>{t('cropRecommendation.viewHistory')}</span>
                <ChevronRight size={16} />
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
'''

with open('src/pages/CropRecommendationPage.tsx', 'w', encoding='utf-8') as f:
    f.write(crop_rec_code)
print('CropRecommendationPage.tsx created')

# 3. CropHistoryPage.tsx
crop_hist_code = '''import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { History, Brain, Calendar, Layers, ArrowRight, Trash2, Filter } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { getCropDisplayName } from '../constants/crops';
import { CropRecommendationResult } from '../types';

export const CropHistoryPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { currentLanguage } = useLanguage();

  const [historyList, setHistoryList] = useState<CropRecommendationResult[]>([]);
  const [selectedCropFilter, setSelectedCropFilter] = useState<string>('all');

  useEffect(() => {
    const saved = localStorage.getItem('kisan_crop_history');
    if (saved) {
      try {
        setHistoryList(JSON.parse(saved));
      } catch {
        setHistoryList([]);
      }
    } else {
      // Pre-seed sample history entries so farmer can immediately review history
      const sampleHistory: CropRecommendationResult[] = [
        {
          id: 'REC-1718001001',
          recommended_crop: 'rice',
          confidence: 0.96,
          alternate_crops: ['maize', 'cotton'],
          reason: 'High nitrogen and adequate irrigation support high-yield paddy cultivation.',
          seasonal_suitability: 'Kharif Season',
          duration_days: '120 - 135 Days',
          soilMatch: 96,
          economics: {
            estimated_cost_per_acre: 18500,
            estimated_yield_per_acre: '26 Quintals',
            estimated_revenue_per_acre: 55000,
            profit_potential: '₹36,500 Net / Acre',
          },
          fertilizer_recommendation: {
            urea_kg: 45,
            dap_kg: 25,
            mop_kg: 20,
            organic_compost_tons: 2.5,
            schedule: 'Split application across 30 and 55 days',
          },
          irrigation_guideline: 'Maintain continuous shallow depth of 3-5 cm during tillering.',
          riskFactors: ['Brown planthopper risk during humid periods'],
          created_at: new Date(Date.now() - 86400000 * 3).toISOString(),
          input_params: {
            nitrogen_n: 78,
            phosphorus_p: 42,
            potassium_k: 48,
            ph_level: 6.8,
            temperature: 28,
            humidity: 75,
            rainfall: 190,
            state: 'Andhra Pradesh',
            district: 'Guntur',
            landArea: 3.5,
            area_unit: 'Acres',
            irrigation_type: 'Canal',
          },
        },
        {
          id: 'REC-1717502002',
          recommended_crop: 'cotton',
          confidence: 0.92,
          alternate_crops: ['chickpea', 'pigeonpeas'],
          reason: 'Deep black soil with rich potash is highly conducive for cotton bolls.',
          seasonal_suitability: 'Kharif Season',
          duration_days: '150 - 170 Days',
          soilMatch: 92,
          economics: {
            estimated_cost_per_acre: 21000,
            estimated_yield_per_acre: '14 Quintals',
            estimated_revenue_per_acre: 68000,
            profit_potential: '₹47,000 Net / Acre',
          },
          fertilizer_recommendation: {
            urea_kg: 50,
            dap_kg: 30,
            mop_kg: 25,
            organic_compost_tons: 3.0,
            schedule: 'Basal dose followed by flowering stage top dressing',
          },
          irrigation_guideline: 'Irrigate at squaring and boll formation stages. Avoid waterlogging.',
          riskFactors: ['Pink bollworm infestation requires timely monitoring'],
          created_at: new Date(Date.now() - 86400000 * 14).toISOString(),
          input_params: {
            nitrogen_n: 65,
            phosphorus_p: 38,
            potassium_k: 55,
            ph_level: 7.2,
            temperature: 30,
            humidity: 65,
            rainfall: 120,
            state: 'Andhra Pradesh',
            district: 'Guntur',
            landArea: 3.5,
            area_unit: 'Acres',
            irrigation_type: 'Borewell',
          },
        },
      ];
      setHistoryList(sampleHistory);
      localStorage.setItem('kisan_crop_history', JSON.stringify(sampleHistory));
    }
  }, []);

  const handleClearHistory = () => {
    localStorage.removeItem('kisan_crop_history');
    setHistoryList([]);
  };

  const filteredHistory = historyList.filter((item) => {
    if (selectedCropFilter === 'all') return true;
    return item.recommended_crop.toLowerCase() === selectedCropFilter.toLowerCase();
  });

  return (
    <div className="crop-history-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('cropHistory.title')}</h1>
          <p className="page-subtitle">{t('cropHistory.subtitle')}</p>
        </div>
        <div className="header-btn-row">
          {historyList.length > 0 && (
            <button onClick={handleClearHistory} className="btn-secondary" title="Clear History">
              <Trash2 size={16} />
              <span>Clear</span>
            </button>
          )}
          <Link to="/crop-recommendation" className="btn-primary">
            <Brain size={18} />
            <span>{t('cropHistory.newAnalysis')}</span>
          </Link>
        </div>
      </div>

      {historyList.length === 0 ? (
        <div className="empty-history-card">
          <History size={48} className="empty-icon" />
          <h3>{t('cropHistory.emptyHistory')}</h3>
          <button
            onClick={() => navigate('/crop-recommendation')}
            className="btn-primary mt-4"
          >
            {t('cropRecommendation.analyzeBtn')}
          </button>
        </div>
      ) : (
        <div className="history-cards-container">
          {filteredHistory.map((item) => {
            const localizedCrop = getCropDisplayName(item.recommended_crop, currentLanguage);
            const dateStr = new Date(item.created_at).toLocaleDateString();
            return (
              <div key={item.id} className="history-card">
                <div className="history-card-top">
                  <div className="history-crop-badge">
                    <span className="history-crop-title">{localizedCrop}</span>
                    <span className="history-code-tag">{item.recommended_crop}</span>
                  </div>
                  <div className="history-date">
                    <Calendar size={14} />
                    <span>{dateStr}</span>
                  </div>
                </div>

                <div className="history-metrics-grid">
                  <div className="hist-metric">
                    <span className="metric-label">{t('cropHistory.score')}</span>
                    <span className="metric-value text-green">{Math.round(item.confidence * 100)}%</span>
                  </div>
                  <div className="hist-metric">
                    <span className="metric-label">{t('cropHistory.soilValues')}</span>
                    <span className="metric-value">
                      N:{item.input_params.nitrogen_n} P:{item.input_params.phosphorus_p} K:{item.input_params.potassium_k}
                    </span>
                  </div>
                  <div className="hist-metric">
                    <span className="metric-label">{t('cropHistory.phValue')}</span>
                    <span className="metric-value">{item.input_params.ph_level}</span>
                  </div>
                  <div className="hist-metric">
                    <span className="metric-label">{t('cropHistory.weatherValues')}</span>
                    <span className="metric-value">
                      {item.input_params.temperature}°C / {item.input_params.rainfall}mm
                    </span>
                  </div>
                </div>

                <div className="history-footer">
                  <span className="history-reason">{item.reason}</span>
                  <Link to="/crop-recommendation" className="btn-text-link">
                    <span>Re-test Scenario</span>
                    <ArrowRight size={14} />
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
'''

with open('src/pages/CropHistoryPage.tsx', 'w', encoding='utf-8') as f:
    f.write(crop_hist_code)
print('CropHistoryPage.tsx created')
