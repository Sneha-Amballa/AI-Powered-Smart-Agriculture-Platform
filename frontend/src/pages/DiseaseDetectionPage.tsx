import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
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
  ArrowLeft,
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
  const navigate = useNavigate();
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
            <h1 className="page-title">{t('diseaseDetection.title')}</h1>
            <p className="page-subtitle">{t('diseaseDetection.subtitle')}</p>
          </div>
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
