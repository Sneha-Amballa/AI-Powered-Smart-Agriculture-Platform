import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { User, MapPin, Layers, Globe, Check, Edit2, Save, CheckCircle2, RotateCcw } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { LanguageCode } from '../types';

export const ProfilePage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage, supportedLanguages, setLanguage } = useLanguage();
  const { user, profile, updateProfile } = useAuth();

  const [isEditing, setIsEditing] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState('');

  // Editable fields
  const [fullName, setFullName] = useState(user?.full_name || 'Ramesh Patel');
  const [state, setState] = useState(profile?.state || 'Andhra Pradesh');
  const [district, setDistrict] = useState(profile?.district || 'Guntur');
  const [village, setVillage] = useState(profile?.village || 'Tenali');
  const [pincode, setPincode] = useState(profile?.pincode || '522201');

  const [landArea, setLandArea] = useState(profile?.farm_details?.land_area ?? 3.5);
  const [areaUnit, setAreaUnit] = useState(profile?.farm_details?.area_unit ?? 'Acres');
  const [soilType, setSoilType] = useState(profile?.farm_details?.soil_type ?? 'Clay Loam / Alluvial');
  const [nitrogen, setNitrogen] = useState(profile?.farm_details?.nitrogen_n ?? 78);
  const [phosphorus, setPhosphorus] = useState(profile?.farm_details?.phosphorus_p ?? 42);
  const [potassium, setPotassium] = useState(profile?.farm_details?.potassium_k ?? 48);
  const [phLevel, setPhLevel] = useState(profile?.farm_details?.ph_level ?? 6.8);
  const [irrigation, setIrrigation] = useState(profile?.farm_details?.irrigation_type ?? 'Canal & Borewell');

  const handleLanguageSwitch = async (langCode: LanguageCode) => {
    await setLanguage(langCode, user?.id);
  };

  const handleSaveProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    await updateProfile({
      state,
      district,
      village,
      pincode,
      farm_details: {
        land_area: landArea,
        area_unit: areaUnit,
        soil_type: soilType,
        nitrogen_n: nitrogen,
        phosphorus_p: phosphorus,
        potassium_k: potassium,
        ph_level: phLevel,
        irrigation_type: irrigation,
        has_soil_report: true,
      },
    });
    setIsEditing(false);
    setSaveSuccess(t('profile.profileUpdated'));
    setTimeout(() => setSaveSuccess(''), 4000);
  };

  return (
    <div className="profile-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('profile.title')}</h1>
          <p className="page-subtitle">{t('profile.subtitle')}</p>
        </div>
        {!isEditing ? (
          <button onClick={() => setIsEditing(true)} className="btn-primary">
            <Edit2 size={16} />
            <span>{t('profile.editProfile')}</span>
          </button>
        ) : (
          <button onClick={() => setIsEditing(false)} className="btn-secondary">
            <span>{t('profile.cancelEdit')}</span>
          </button>
        )}
      </div>

      {saveSuccess && (
        <div className="save-toast-banner">
          <CheckCircle2 size={18} />
          <span>{saveSuccess}</span>
        </div>
      )}

      {/* DEDICATED GLOBAL LANGUAGE PREFERENCE SECTION IN PROFILE */}
      <div className="profile-section-card language-preference-card">
        <div className="profile-section-header">
          <div className="header-title-group">
            <Globe size={22} className="text-green" />
            <div>
              <h3>{t('settings.languageTitle')}</h3>
              <p className="section-desc">{t('settings.languageDescription')}</p>
            </div>
          </div>
        </div>

        <div className="profile-language-picker-grid">
          {supportedLanguages.map((lang) => {
            const isSelected = currentLanguage === lang.code;
            return (
              <button
                key={lang.code}
                type="button"
                onClick={() => handleLanguageSwitch(lang.code)}
                className={`profile-lang-tile ${isSelected ? 'active' : ''}`}
              >
                <div className="tile-badge-strip">
                  <span className="code-pill">{lang.badge}</span>
                  {isSelected && <Check size={16} className="tile-check-icon" />}
                </div>
                <span className="native-text">{lang.nativeName}</span>
                <span className="english-text">{lang.englishName}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Profile Form (Personal Details, Farm Location, Soil N-P-K) */}
      <form onSubmit={handleSaveProfile} className="profile-details-layout">
        {/* Personal & Farm Location */}
        <div className="profile-section-card">
          <div className="profile-section-header">
            <div className="header-title-group">
              <MapPin size={22} className="text-blue" />
              <h3>{t('profile.farmLocation')}</h3>
            </div>
          </div>

          <div className="profile-fields-grid">
            <div className="form-group">
              <label>{t('auth.fullName')}</label>
              <input
                type="text"
                value={fullName}
                disabled={!isEditing}
                onChange={(e) => setFullName(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('auth.phone')}</label>
              <input
                type="text"
                value={user?.phone_number || '9876543210'}
                disabled
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.state')}</label>
              <input
                type="text"
                value={state}
                disabled={!isEditing}
                onChange={(e) => setState(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.district')}</label>
              <input
                type="text"
                value={district}
                disabled={!isEditing}
                onChange={(e) => setDistrict(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.village')}</label>
              <input
                type="text"
                value={village}
                disabled={!isEditing}
                onChange={(e) => setVillage(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.pincode')}</label>
              <input
                type="text"
                value={pincode}
                disabled={!isEditing}
                onChange={(e) => setPincode(e.target.value)}
              />
            </div>
          </div>
        </div>

        {/* Soil & Farm Parameters */}
        <div className="profile-section-card">
          <div className="profile-section-header">
            <div className="header-title-group">
              <Layers size={22} className="text-amber" />
              <div>
                <h3>{t('profile.soilParameters')}</h3>
                <p className="section-desc">Auto-loads into Crop Recommendation (Zero Re-entry UX)</p>
              </div>
            </div>
          </div>

          <div className="profile-fields-grid">
            <div className="form-group">
              <label>{t('onboarding.landArea')}</label>
              <input
                type="number"
                step="0.1"
                value={landArea}
                disabled={!isEditing}
                onChange={(e) => setLandArea(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.areaUnit')}</label>
              <select
                value={areaUnit}
                disabled={!isEditing}
                onChange={(e) => setAreaUnit(e.target.value)}
              >
                <option value="Acres">Acres</option>
                <option value="Hectares">Hectares</option>
                <option value="Bigha">Bigha</option>
              </select>
            </div>

            <div className="form-group">
              <label>{t('onboarding.soilType')}</label>
              <input
                type="text"
                value={soilType}
                disabled={!isEditing}
                onChange={(e) => setSoilType(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.irrigationType')}</label>
              <input
                type="text"
                value={irrigation}
                disabled={!isEditing}
                onChange={(e) => setIrrigation(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.nitrogen')} (N - kg/ha)</label>
              <input
                type="number"
                value={nitrogen}
                disabled={!isEditing}
                onChange={(e) => setNitrogen(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.phosphorus')} (P - kg/ha)</label>
              <input
                type="number"
                value={phosphorus}
                disabled={!isEditing}
                onChange={(e) => setPhosphorus(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.potassium')} (K - kg/ha)</label>
              <input
                type="number"
                value={potassium}
                disabled={!isEditing}
                onChange={(e) => setPotassium(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label>{t('onboarding.phLevel')} (pH)</label>
              <input
                type="number"
                step="0.1"
                value={phLevel}
                disabled={!isEditing}
                onChange={(e) => setPhLevel(Number(e.target.value))}
              />
            </div>
          </div>

          {isEditing && (
            <div className="form-action-row mt-4">
              <button type="submit" className="btn-primary btn-large">
                <Save size={18} />
                <span>{t('profile.saveChanges')}</span>
              </button>
            </div>
          )}
        </div>
      </form>
    </div>
  );
};
