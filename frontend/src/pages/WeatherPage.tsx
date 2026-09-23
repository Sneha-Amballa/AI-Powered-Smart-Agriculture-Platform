import React from 'react';
import { useNavigate } from 'react-router-dom';
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
  ArrowLeft,
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';
import { Translate } from '../services/libreTranslateService';

export const WeatherPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const { profile } = useAuth();
  const { currentLanguage } = useLanguage();

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
            <h1 className="page-title">{t('weather.title')}</h1>
            <p className="page-subtitle">
              {district}, {state} • Hyperlocal agro-meteorological guidance
            </p>
          </div>
        </div>
      </div>

      {/* Current Conditions Card */}
      <div className="current-weather-hero">
        <div className="cw-left">
          <span className="cw-loc">{district}, {state}</span>
          <div className="cw-temp-row">
            <span className="cw-temp">31°C</span>
            <div className="cw-cond-wrap">
              <span className="cw-cond">
                <Translate text="Partly Cloudy" targetLang={currentLanguage} />
              </span>
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
              <span className="stat-val">
                14 km/h <Translate text="ENE" targetLang={currentLanguage} />
              </span>
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
              <span className="stat-val">
                7 (<Translate text="High" targetLang={currentLanguage} />)
              </span>
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
            <Translate
              text="Soil moisture is currently adequate. No irrigation needed for the next 24 hours. Plan light irrigation on Thursday ahead of forecasted scattered rains."
              targetLang={currentLanguage}
            />
          </p>
          <div className="adv-badge safe">
            <Translate text="Optimal Soil Moisture" targetLang={currentLanguage} />
          </div>
        </div>

        <div className="advisory-card">
          <div className="adv-header">
            <Wind size={20} className="text-amber" />
            <h3>{t('weather.sprayingAdv')}</h3>
          </div>
          <p className="adv-text">
            <Translate
              text="Morning window (07:00 AM - 10:00 AM) is favorable for foliar spray with wind speeds under 10 km/h. Avoid spraying on Thursday afternoon due to rain probability."
              targetLang={currentLanguage}
            />
          </p>
          <div className="adv-badge warning">
            <Translate text="Spray Window: 7 AM - 10 AM" targetLang={currentLanguage} />
          </div>
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
                <span className="day-name">
                  <Translate text={item.day} targetLang={currentLanguage} />
                </span>
                <Icon size={28} className="day-icon" />
                <span className="day-cond">
                  <Translate text={item.cond} targetLang={currentLanguage} />
                </span>
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
