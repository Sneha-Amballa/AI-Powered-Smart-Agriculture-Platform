import React, { useState, useEffect } from 'react';
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
          soil_match: 96,
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
          risk_factors: ['Brown planthopper risk during humid periods'],
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
            land_area: 3.5,
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
          soil_match: 92,
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
          risk_factors: ['Pink bollworm infestation requires timely monitoring'],
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
            land_area: 3.5,
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
