import os

os.makedirs('src/pages', exist_ok=True)

# 1. DiseaseDetectionPage.tsx
disease_code = '''import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Activity,
  Upload,
  Camera,
  CheckCircle2,
  AlertTriangle,
  RefreshCw,
  ShieldCheck,
  Leaf,
  Bug,
  Sparkles,
} from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';

interface DiseaseSample {
  id: string;
  name: string;
  crop: string;
  severity: 'low' | 'moderate' | 'high' | 'critical';
  confidence: number;
  symptoms: string[];
  organic: string[];
  chemical: string[];
  prevention: string[];
}

const SAMPLE_DISEASES: Record<string, DiseaseSample> = {
  tomato_early_blight: {
    id: 'sample1',
    name: 'Early Blight (Alternaria solani)',
    crop: 'Tomato',
    severity: 'moderate',
    confidence: 0.94,
    symptoms: [
      'Concentric dark brown rings on older lower leaves resembling a target board',
      'Yellow chlorotic halos surrounding lesions',
      'Premature leaf defoliation reducing photosynthetic capacity',
    ],
    organic: [
      'Spray Neem oil (5ml/L) or Trichoderma viride culture every 10 days.',
      'Remove and safely burn lower infected leaves to curb spore dispersal.',
      'Apply mulch around root base to prevent soil splash onto foliage.',
    ],
    chemical: [
      'Mancozeb 75% WP @ 2.5g per litre of water.',
      'Chlorothalonil 75% WP @ 2g per litre of water at first sign of infection.',
    ],
    prevention: [
      'Follow 2-year crop rotation avoiding Solanaceous family crops (potato, brinjal).',
      'Adopt drip irrigation instead of overhead sprinklers to keep foliage dry.',
    ],
  },
  grape_powdery_mildew: {
    id: 'sample2',
    name: 'Powdery Mildew (Uncinula necator)',
    crop: 'Grapes',
    severity: 'high',
    confidence: 0.91,
    symptoms: [
      'White powdery fungal patches on upper leaf surface, tendrils, and berries',
      'Distorted curling leaves and scarred cracking fruit skins',
    ],
    organic: [
      'Spray wettable sulfur @ 2g/L during early morning hours.',
      'Apply milk whey dilution (1:9 with water) as natural antifungal bio-spray.',
    ],
    chemical: [
      'Azoxystrobin 23% SC @ 1ml/L or Difenoconazole 25% EC @ 0.5ml/L.',
    ],
    prevention: [
      'Ensure proper canopy pruning to maximize sunlight penetration and air circulation.',
    ],
  },
  wheat_rust: {
    id: 'sample3',
    name: 'Yellow / Stripe Rust (Puccinia striiformis)',
    crop: 'Wheat',
    severity: 'critical',
    confidence: 0.96,
    symptoms: [
      'Linear rows of bright yellow-orange pustules forming parallel stripes along leaf veins',
      'Yellow dust rubbing off easily on fingertips or clothing',
    ],
    organic: [
      'Apply bio-fungicide Pseudomonas fluorescens @ 10g/L water.',
    ],
    chemical: [
      'Propiconazole 25% EC (Tilt) @ 1ml per litre immediately upon field spotting.',
      'Tebuconazole 25.9% EC @ 1ml/L for heavy outbreaks.',
    ],
    prevention: [
      'Sow rust-resistant recommended wheat cultivars (e.g. HD-2967, DBW-187).',
      'Avoid excessive nitrogen fertilization which creates succulent susceptible foliage.',
    ],
  },
  healthy_cotton: {
    id: 'sample4',
    name: 'Healthy Crop (No Pathogen Detected)',
    crop: 'Cotton',
    severity: 'low',
    confidence: 0.99,
    symptoms: [
      'Foliage shows vibrant uniform green pigmentation with no chlorotic spots',
      'Normal vegetative branching with healthy square formation',
    ],
    organic: [
      'Continue routine application of Panchagavya or Jeevamrutha every 15 days.',
    ],
    chemical: [
      'No chemical fungicide or pesticide required.',
    ],
    prevention: [
      'Maintain balanced NPK fertilization and install yellow sticky traps for prophylactic monitoring.',
    ],
  },
};

export const DiseaseDetectionPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage } = useLanguage();

  const [selectedSampleKey, setSelectedSampleKey] = useState<string>('tomato_early_blight');
  const [analyzing, setAnalyzing] = useState<boolean>(false);
  const [currentDiagnosis, setCurrentDiagnosis] = useState<DiseaseSample>(SAMPLE_DISEASES['tomato_early_blight']);

  const handleSelectSample = (key: string) => {
    setSelectedSampleKey(key);
    setAnalyzing(true);
    setTimeout(() => {
      setCurrentDiagnosis(SAMPLE_DISEASES[key]);
      setAnalyzing(false);
    }, 600);
  };

  const getSeverityBadgeClass = (sev: string) => {
    switch (sev) {
      case 'low': return 'badge-sev-low';
      case 'moderate': return 'badge-sev-mod';
      case 'high': return 'badge-sev-high';
      case 'critical': return 'badge-sev-crit';
      default: return 'badge-sev-mod';
    }
  };

  return (
    <div className="disease-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('diseaseDetection.title')}</h1>
          <p className="page-subtitle">{t('diseaseDetection.subtitle')}</p>
        </div>
      </div>

      <div className="disease-layout-grid">
        {/* Upload & Sample Selector Panel */}
        <div className="disease-input-panel">
          <div className="upload-dropzone">
            <Upload size={36} className="text-green" />
            <h3>{t('diseaseDetection.uploadTitle')}</h3>
            <p>{t('diseaseDetection.uploadHint')}</p>
            <div className="dropzone-buttons">
              <label className="btn-primary btn-sm">
                <span>Browse Photo</span>
                <input type="file" accept="image/*" style={{ display: 'none' }} onChange={() => handleSelectSample('tomato_early_blight')} />
              </label>
              <button type="button" onClick={() => handleSelectSample('wheat_rust')} className="btn-secondary btn-sm">
                <Camera size={16} />
                <span>Take Photo</span>
              </button>
            </div>
          </div>

          {/* Quick Test Samples */}
          <div className="sample-test-section">
            <h4>{t('diseaseDetection.sampleImages')}</h4>
            <div className="sample-pills-list">
              <button
                type="button"
                onClick={() => handleSelectSample('tomato_early_blight')}
                className={`sample-tile ${selectedSampleKey === 'tomato_early_blight' ? 'active' : ''}`}
              >
                <div className="sample-indicator red" />
                <div className="sample-info">
                  <span className="sample-title">{t('diseaseDetection.sample1')}</span>
                  <span className="sample-meta">Tomato • Early Blight</span>
                </div>
              </button>

              <button
                type="button"
                onClick={() => handleSelectSample('grape_powdery_mildew')}
                className={`sample-tile ${selectedSampleKey === 'grape_powdery_mildew' ? 'active' : ''}`}
              >
                <div className="sample-indicator orange" />
                <div className="sample-info">
                  <span className="sample-title">{t('diseaseDetection.sample2')}</span>
                  <span className="sample-meta">Grapes • Powdery Mildew</span>
                </div>
              </button>

              <button
                type="button"
                onClick={() => handleSelectSample('wheat_rust')}
                className={`sample-tile ${selectedSampleKey === 'wheat_rust' ? 'active' : ''}`}
              >
                <div className="sample-indicator crit" />
                <div className="sample-info">
                  <span className="sample-title">{t('diseaseDetection.sample3')}</span>
                  <span className="sample-meta">Wheat • Stripe Rust</span>
                </div>
              </button>

              <button
                type="button"
                onClick={() => handleSelectSample('healthy_cotton')}
                className={`sample-tile ${selectedSampleKey === 'healthy_cotton' ? 'active' : ''}`}
              >
                <div className="sample-indicator green" />
                <div className="sample-info">
                  <span className="sample-title">{t('diseaseDetection.sample4')}</span>
                  <span className="sample-meta">Cotton • 100% Healthy</span>
                </div>
              </button>
            </div>
          </div>
        </div>

        {/* Diagnosis Result Panel */}
        <div className="diagnosis-result-panel">
          {analyzing ? (
            <div className="analyzing-card">
              <RefreshCw size={36} className="spin-icon text-green" />
              <h3>{t('diseaseDetection.analyzing')}</h3>
              <p>Analyzing leaf margins, lesion patterns, and fungal pustules...</p>
            </div>
          ) : (
            <div className="diagnosis-card">
              {/* Diagnosis Header */}
              <div className="diag-header">
                <div>
                  <span className="diag-crop-pill">{currentDiagnosis.crop}</span>
                  <h2 className="diag-name">{currentDiagnosis.name}</h2>
                </div>
                <div className="diag-metrics">
                  <span className={`severity-badge ${getSeverityBadgeClass(currentDiagnosis.severity)}`}>
                    {currentDiagnosis.severity.toUpperCase()} SEVERITY
                  </span>
                  <span className="confidence-pill">
                    {Math.round(currentDiagnosis.confidence * 100)}% Confidence
                  </span>
                </div>
              </div>

              {/* Symptoms */}
              <div className="diag-section">
                <div className="section-title-row">
                  <Bug size={18} className="text-orange" />
                  <h4>{t('diseaseDetection.symptoms')}</h4>
                </div>
                <ul className="diag-list">
                  {currentDiagnosis.symptoms.map((s, idx) => (
                    <li key={idx}>{s}</li>
                  ))}
                </ul>
              </div>

              {/* Organic Remedies */}
              <div className="diag-section">
                <div className="section-title-row">
                  <Leaf size={18} className="text-green" />
                  <h4>{t('diseaseDetection.organicControl')}</h4>
                </div>
                <ul className="diag-list">
                  {currentDiagnosis.organic.map((s, idx) => (
                    <li key={idx}>{s}</li>
                  ))}
                </ul>
              </div>

              {/* Chemical Treatments */}
              <div className="diag-section">
                <div className="section-title-row">
                  <AlertTriangle size={18} className="text-amber" />
                  <h4>{t('diseaseDetection.chemicalControl')}</h4>
                </div>
                <ul className="diag-list">
                  {currentDiagnosis.chemical.map((s, idx) => (
                    <li key={idx}>{s}</li>
                  ))}
                </ul>
              </div>

              {/* Preventive Measures */}
              <div className="diag-section">
                <div className="section-title-row">
                  <ShieldCheck size={18} className="text-blue" />
                  <h4>{t('diseaseDetection.prevention')}</h4>
                </div>
                <ul className="diag-list">
                  {currentDiagnosis.prevention.map((s, idx) => (
                    <li key={idx}>{s}</li>
                  ))}
                </ul>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
'''

with open('src/pages/DiseaseDetectionPage.tsx', 'w', encoding='utf-8') as f:
    f.write(disease_code)
print('DiseaseDetectionPage.tsx created')

# 2. WeatherPage.tsx
weather_code = '''import React from 'react';
import { useTranslation } from 'react-i18next';
import {
  CloudSun,
  Droplets,
  Wind,
  Sun,
  CloudRain,
  Compass,
  AlertCircle,
  Calendar,
  CheckCircle2,
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';

export const WeatherPage: React.FC = () => {
  const { t } = useTranslation();
  const { profile } = useAuth();

  const district = profile?.district || 'Guntur';
  const state = profile?.state || 'Andhra Pradesh';

  const forecast = [
    { day: 'Today', tempMax: 32, tempMin: 24, cond: 'Partly Cloudy', rain: 20, icon: CloudSun },
    { day: 'Tomorrow', tempMax: 33, tempMin: 25, cond: 'Sunny & Warm', rain: 10, icon: Sun },
    { day: 'Thursday', tempMax: 30, tempMin: 23, cond: 'Light Showers', rain: 65, icon: CloudRain },
    { day: 'Friday', tempMax: 29, tempMin: 23, cond: 'Moderate Rain', rain: 75, icon: CloudRain },
    { day: 'Saturday', tempMax: 31, tempMin: 24, cond: 'Scattered Clouds', rain: 30, icon: CloudSun },
    { day: 'Sunday', tempMax: 32, tempMin: 25, cond: 'Mostly Sunny', rain: 15, icon: Sun },
    { day: 'Monday', tempMax: 33, tempMin: 26, cond: 'Sunny', rain: 10, icon: Sun },
  ];

  return (
    <div className="weather-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('weather.title')}</h1>
          <p className="page-subtitle">
            {district}, {state} • Hyperlocal agro-meteorological guidance
          </p>
        </div>
      </div>

      {/* Current Conditions Card */}
      <div className="current-weather-hero">
        <div className="cw-left">
          <span className="cw-loc">{district}, {state}</span>
          <div className="cw-temp-row">
            <span className="cw-temp">31°C</span>
            <div className="cw-cond-wrap">
              <span className="cw-cond">Partly Cloudy</span>
              <span className="cw-feels">{t('weather.feelsLike')} 34°C</span>
            </div>
          </div>
        </div>

        <div className="cw-stats-grid">
          <div className="cw-stat-card">
            <Droplets size={20} className="stat-icon blue" />
            <div>
              <span className="stat-label">{t('weather.humidity')}</span>
              <span className="stat-val">68%</span>
            </div>
          </div>

          <div className="cw-stat-card">
            <Wind size={20} className="stat-icon teal" />
            <div>
              <span className="stat-label">{t('weather.wind')}</span>
              <span className="stat-val">14 km/h ENE</span>
            </div>
          </div>

          <div className="cw-stat-card">
            <CloudRain size={20} className="stat-icon indigo" />
            <div>
              <span className="stat-label">{t('weather.rainChance')}</span>
              <span className="stat-val">20%</span>
            </div>
          </div>

          <div className="cw-stat-card">
            <Sun size={20} className="stat-icon amber" />
            <div>
              <span className="stat-label">{t('weather.uvIndex')}</span>
              <span className="stat-val">7 (High)</span>
            </div>
          </div>
        </div>
      </div>

      {/* Farm Advisories */}
      <div className="advisories-grid">
        <div className="advisory-card">
          <div className="adv-header">
            <Droplets size={20} className="text-blue" />
            <h3>{t('weather.irrigationAdv')}</h3>
          </div>
          <p className="adv-text">
            Soil moisture is currently adequate. No irrigation needed for the next 24 hours. Plan light irrigation on Thursday ahead of forecasted scattered rains.
          </p>
          <div className="adv-badge safe">Optimal Soil Moisture</div>
        </div>

        <div className="advisory-card">
          <div className="adv-header">
            <Wind size={20} className="text-amber" />
            <h3>{t('weather.sprayingAdv')}</h3>
          </div>
          <p className="adv-text">
            Morning window (07:00 AM - 10:00 AM) is favorable for foliar spray with wind speeds under 10 km/h. Avoid spraying on Thursday afternoon due to rain probability.
          </p>
          <div className="adv-badge warning">Spray Window: 7 AM - 10 AM</div>
        </div>
      </div>

      {/* 7-Day Forecast */}
      <div className="forecast-section">
        <div className="forecast-header">
          <Calendar size={20} className="text-green" />
          <h3>{t('weather.forecast7Day')}</h3>
        </div>

        <div className="forecast-days-row">
          {forecast.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div key={idx} className="forecast-day-card">
                <span className="day-name">{item.day}</span>
                <Icon size={28} className="day-icon" />
                <span className="day-cond">{item.cond}</span>
                <div className="day-temp-row">
                  <span className="temp-high">{item.tempMax}°</span>
                  <span className="temp-low">{item.tempMin}°</span>
                </div>
                <div className="day-rain-prob">
                  <Droplets size={12} />
                  <span>{item.rain}%</span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
'''

with open('src/pages/WeatherPage.tsx', 'w', encoding='utf-8') as f:
    f.write(weather_code)
print('WeatherPage.tsx created')

# 3. MarketPage.tsx
market_code = '''import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TrendingUp, Search, ArrowUpRight, ArrowDownRight, Minus, MapPin, Calendar } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { getCropDisplayName } from '../constants/crops';
import { MandiPriceItem } from '../types';

export const MarketPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage } = useLanguage();
  const [searchTerm, setSearchTerm] = useState('');

  const mandiData: MandiPriceItem[] = [
    {
      id: 'm1',
      crop_key: 'rice',
      market_name: 'Guntur APMC Mandi',
      district: 'Guntur',
      state: 'Andhra Pradesh',
      modal_price: 2320,
      min_price: 2150,
      max_price: 2480,
      price_change: 3.2,
      arrival_quantity: '4,200 Quintals',
      updated_date: 'Today, 11:30 AM',
    },
    {
      id: 'm2',
      crop_key: 'cotton',
      market_name: 'Warangal Cotton Market',
      district: 'Warangal',
      state: 'Telangana',
      modal_price: 7150,
      min_price: 6800,
      max_price: 7400,
      price_change: 1.8,
      arrival_quantity: '1,850 Quintals',
      updated_date: 'Today, 10:45 AM',
    },
    {
      id: 'm3',
      crop_key: 'chickpea',
      market_name: 'Indore APMC Yard',
      district: 'Indore',
      state: 'Madhya Pradesh',
      modal_price: 5400,
      min_price: 5100,
      max_price: 5650,
      price_change: -0.5,
      arrival_quantity: '2,600 Quintals',
      updated_date: 'Today, 09:15 AM',
    },
    {
      id: 'm4',
      crop_key: 'maize',
      market_name: 'Khammam Grain Market',
      district: 'Khammam',
      state: 'Telangana',
      modal_price: 2180,
      min_price: 2050,
      max_price: 2280,
      price_change: 2.1,
      arrival_quantity: '3,100 Quintals',
      updated_date: 'Today, 11:00 AM',
    },
    {
      id: 'm5',
      crop_key: 'banana',
      market_name: 'Tenali Fruit Market',
      district: 'Guntur',
      state: 'Andhra Pradesh',
      modal_price: 1950,
      min_price: 1800,
      max_price: 2100,
      price_change: 0.0,
      arrival_quantity: '950 Quintals',
      updated_date: 'Today, 08:30 AM',
    },
    {
      id: 'm6',
      crop_key: 'pigeonpeas',
      market_name: 'Gulbarga Tur Mandi',
      district: 'Kalaburagi',
      state: 'Karnataka',
      modal_price: 9850,
      min_price: 9400,
      max_price: 10200,
      price_change: 4.5,
      arrival_quantity: '1,400 Quintals',
      updated_date: 'Today, 10:00 AM',
    },
  ];

  const filtered = mandiData.filter((item) => {
    const localized = getCropDisplayName(item.crop_key, currentLanguage).toLowerCase();
    const query = searchTerm.toLowerCase();
    return (
      localized.includes(query) ||
      item.crop_key.toLowerCase().includes(query) ||
      item.market_name.toLowerCase().includes(query) ||
      item.district.toLowerCase().includes(query)
    );
  });

  return (
    <div className="market-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('market.title')}</h1>
          <p className="page-subtitle">{t('market.subtitle')}</p>
        </div>

        {/* Search Bar */}
        <div className="market-search-box">
          <Search size={18} className="search-icon" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder={t('market.searchPlaceholder')}
          />
        </div>
      </div>

      {/* Mandi Cards Table */}
      <div className="market-table-container">
        <table className="market-table">
          <thead>
            <tr>
              <th>{t('market.commodity')}</th>
              <th>{t('market.mandi')}</th>
              <th>{t('market.modalPrice')}</th>
              <th>Min - Max</th>
              <th>{t('market.trend')}</th>
              <th>{t('market.arrivals')}</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((item) => {
              const localizedName = getCropDisplayName(item.crop_key, currentLanguage);
              return (
                <tr key={item.id}>
                  <td>
                    <div className="table-crop-cell">
                      <span className="crop-title">{localizedName}</span>
                      <span className="crop-code">{item.crop_key}</span>
                    </div>
                  </td>
                  <td>
                    <div className="table-market-cell">
                      <span className="mandi-title">{item.market_name}</span>
                      <span className="district-title">{item.district}, {item.state}</span>
                    </div>
                  </td>
                  <td>
                    <span className="modal-price-tag">₹{item.modal_price.toLocaleString('en-IN')}</span>
                    <span className="per-quintal"> / qtl</span>
                  </td>
                  <td>
                    <span className="min-max-tag">₹{item.min_price} - ₹{item.max_price}</span>
                  </td>
                  <td>
                    {item.price_change > 0 ? (
                      <span className="trend-badge pos">
                        <ArrowUpRight size={14} />
                        <span>+{item.price_change}%</span>
                      </span>
                    ) : item.price_change < 0 ? (
                      <span className="trend-badge neg">
                        <ArrowDownRight size={14} />
                        <span>{item.price_change}%</span>
                      </span>
                    ) : (
                      <span className="trend-badge neutral">
                        <Minus size={14} />
                        <span>Stable</span>
                      </span>
                    )}
                  </td>
                  <td>
                    <span className="arrivals-tag">{item.arrival_quantity}</span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};
'''

with open('src/pages/MarketPage.tsx', 'w', encoding='utf-8') as f:
    f.write(market_code)
print('MarketPage.tsx created')
