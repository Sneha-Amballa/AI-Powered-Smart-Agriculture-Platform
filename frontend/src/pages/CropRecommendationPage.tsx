import React, { useState, useEffect } from 'react';
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
  ArrowLeft,
} from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { getCropDisplayName, CROP_DURATIONS, CROP_SEASONS } from '../constants/crops';
import { CropRecommendationInput, CropRecommendationResult } from '../types';
import { api, generateSmartRecommendation } from '../services/api';
import { Translate } from '../services/libreTranslateService';

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
      land_area: landArea,
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
      land_area: landArea,
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
        <div className="header-title-with-back">
          <button
            type="button"
            onClick={() => navigate('/dashboard')}
            className="btn-back-dashboard"
            title="Back to Dashboard"
          >
            <ArrowLeft size={18} />
            <span>{t('common.back') || 'Back to Dashboard'}</span>
          </button>
          <div>
            <h1 className="page-title">{t('cropRecommendation.title')}</h1>
            <p className="page-subtitle">{t('cropRecommendation.subtitle')}</p>
          </div>
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
                <p>
                  <Translate text={result.reason} targetLang={currentLanguage} />
                </p>
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
                    <span className="meta-val">{result.soil_match}% Perfect Match</span>
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
                  <span className="econ-val">
                    <Translate text={result.economics.profit_potential} targetLang={currentLanguage} />
                  </span>
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
                <strong>Application Schedule:</strong>{' '}
                <Translate text={result.fertilizer_recommendation.schedule} targetLang={currentLanguage} />
              </p>
            </div>

            {/* Irrigation & Risks */}
            <div className="rec-detail-card">
              <div className="card-heading-row">
                <AlertTriangle size={20} className="text-amber" />
                <h3>{t('cropRecommendation.irrigationTitle')}</h3>
              </div>
              <p className="irrigation-text">
                <Translate text={result.irrigation_guideline} targetLang={currentLanguage} />
              </p>
              <ul className="risk-factors-list">
                {result.risk_factors.map((risk, idx) => (
                  <li key={idx}>
                    <Translate text={risk} targetLang={currentLanguage} />
                  </li>
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
