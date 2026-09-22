import os

os.makedirs('src/pages', exist_ok=True)

# 1. SchemesPage.tsx
schemes_code = '''import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Landmark, Search, ExternalLink, ShieldCheck, CheckCircle2, FileText, ChevronRight } from 'lucide-react';
import { GovtScheme } from '../types';

export const SchemesPage: React.FC = () => {
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const schemesList: GovtScheme[] = [
    {
      id: 'pm-kisan',
      scheme_key: 'pm_kisan',
      official_title: 'PM-KISAN Samman Nidhi Yojana',
      ministry: 'Ministry of Agriculture & Farmers Welfare',
      benefit_amount: '₹6,000 / Year (3 equal installments of ₹2,000 directly via DBT)',
      category: 'Income Support',
      eligibility: [
        'All landholding farmer families having cultivable land in their names',
        'Subject to certain exclusion criteria (institutional landholders, tax payers)',
      ],
      documents_required: [
        'Aadhaar Card linked to Bank Account',
        'Land Ownership Records (Pattadar Passbook / RoR / 7/12 extract)',
        'Active Bank Account with IFSC code',
      ],
      portal_url: 'https://pmkisan.gov.in',
    },
    {
      id: 'pmfby',
      scheme_key: 'pmfby',
      official_title: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      ministry: 'Ministry of Agriculture & Farmers Welfare',
      benefit_amount: 'Comprehensive risk coverage from pre-sowing to post-harvest loss at nominal premium (1.5% - 2%)',
      category: 'Crop Insurance',
      eligibility: [
        'All farmers growing notified crops in notified areas',
        'Both loanee and non-loanee farmers are eligible',
      ],
      documents_required: [
        'Sowing Certificate / Declaration from Revenue Department',
        'Land possession certificate / Tenancy agreement',
        'Aadhaar Card and Bank Passbook copy',
      ],
      portal_url: 'https://pmfby.gov.in',
    },
    {
      id: 'soil-health',
      scheme_key: 'soil_health',
      official_title: 'Soil Health Card Scheme',
      ministry: 'Department of Agriculture and Cooperation',
      benefit_amount: 'Free chemical soil testing & customized NPK-micronutrient dosage report issued every 2 years',
      category: 'Soil & Nutrition',
      eligibility: [
        'Open to all agricultural farmers across all districts in India',
      ],
      documents_required: [
        'Survey number of the agricultural plot',
        'Farmer Aadhaar and Mobile Number',
      ],
      portal_url: 'https://soilhealth.dac.gov.in',
    },
    {
      id: 'kcc',
      scheme_key: 'kcc',
      official_title: 'Kisan Credit Card (KCC) Scheme',
      ministry: 'Department of Financial Services & NABARD',
      benefit_amount: 'Revolving crop credit up to ₹3,00,000 at highly subsidized 4% interest rate with prompt repayment',
      category: 'Agricultural Credit',
      eligibility: [
        'All farmers — individuals / joint borrowers who are owner cultivators',
        'Tenant farmers, oral lessees, and sharecroppers',
      ],
      documents_required: [
        'Completed application form with passport photographs',
        'Land record documents verified by Patwari / Tehsildar',
        'Identity proof (Aadhaar/Voter ID) and Address proof',
      ],
      portal_url: 'https://www.myscheme.gov.in/schemes/kcc',
    },
    {
      id: 'smam',
      scheme_key: 'smam',
      official_title: 'Sub-Mission on Agricultural Mechanization (SMAM)',
      ministry: 'Ministry of Agriculture & Farmers Welfare',
      benefit_amount: '40% to 50% financial subsidy on procurement of tractors, rotavators, power tillers & drones',
      category: 'Mechanization Subsidy',
      eligibility: [
        'Small and marginal farmers, SC/ST, women farmers given top priority',
      ],
      documents_required: [
        'Land record passbook',
        'Aadhaar card copy and Bank details',
        'Dealer quotation of the agricultural machinery',
      ],
      portal_url: 'https://agrimachinery.nic.in',
    },
  ];

  const filteredSchemes = schemesList.filter((s) => {
    const matchesQuery =
      s.official_title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      s.category.toLowerCase().includes(searchTerm.toLowerCase()) ||
      s.benefit_amount.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || s.category.toLowerCase().includes(selectedCategory.toLowerCase());
    return matchesQuery && matchesCategory;
  });

  return (
    <div className="schemes-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('schemes.title')}</h1>
          <p className="page-subtitle">{t('schemes.subtitle')}</p>
        </div>

        <div className="market-search-box">
          <Search size={18} className="search-icon" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder={t('schemes.searchSchemes')}
          />
        </div>
      </div>

      {/* Schemes Cards Grid */}
      <div className="schemes-grid">
        {filteredSchemes.map((scheme) => (
          <div key={scheme.id} className="scheme-card">
            <div className="scheme-card-header">
              <span className="scheme-cat-badge">{scheme.category}</span>
              <span className="scheme-ministry">{scheme.ministry}</span>
            </div>

            <h3 className="scheme-title">{scheme.official_title}</h3>

            <div className="benefit-highlight-box">
              <span className="benefit-label">{t('schemes.benefit')}</span>
              <p className="benefit-amount">{scheme.benefit_amount}</p>
            </div>

            <div className="scheme-details-section">
              <h4>{t('schemes.eligibility')}</h4>
              <ul className="scheme-checklist">
                {scheme.eligibility.map((item, idx) => (
                  <li key={idx}>
                    <CheckCircle2 size={16} className="text-green" />
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </div>

            <div className="scheme-details-section">
              <h4>{t('schemes.documents')}</h4>
              <ul className="scheme-docs-list">
                {scheme.documents_required.map((doc, idx) => (
                  <li key={idx}>
                    <FileText size={14} className="text-blue" />
                    <span>{doc}</span>
                  </li>
                ))}
              </ul>
            </div>

            <div className="scheme-action-footer">
              <a
                href={scheme.portal_url}
                target="_blank"
                rel="noopener noreferrer"
                className="btn-primary full-width"
              >
                <span>{t('schemes.applyBtn')}</span>
                <ExternalLink size={16} />
              </a>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
'''

with open('src/pages/SchemesPage.tsx', 'w', encoding='utf-8') as f:
    f.write(schemes_code)
print('SchemesPage.tsx created')

# 2. AIAssistantPage.tsx
assistant_code = '''import React, { useState, useRef, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Bot, Send, Mic, MicOff, Sparkles, User, HelpCircle, Volume2 } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { ChatMessage } from '../types';

export const AIAssistantPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage, languageInfo } = useLanguage();
  const { user, profile } = useAuth();

  const [inputVal, setInputVal] = useState('');
  const [isListening, setIsListening] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const initialMessage: ChatMessage = {
    id: 'm-init',
    sender: 'assistant',
    text: t('assistant.initialGreeting'),
    timestamp: 'Just now',
    language: currentLanguage,
    suggested_prompts: [
      'What is the recommended fertilizer schedule for Paddy in Guntur?',
      'How do I control yellow rust on my wheat crop?',
      'What are today\'s market prices for Cotton in APMC mandis?',
      'How do I apply for the PM-KISAN ₹6,000 subsidy?',
    ],
  };

  const [messages, setMessages] = useState<ChatMessage[]>([initialMessage]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // When language changes, update initial assistant greeting dynamically
  useEffect(() => {
    setMessages((prev) => [
      {
        ...prev[0],
        text: t('assistant.initialGreeting'),
        language: currentLanguage,
      },
      ...prev.slice(1),
    ]);
  }, [currentLanguage]);

  const handleSend = (textToSend?: string) => {
    const text = (textToSend || inputVal).trim();
    if (!text) return;

    const userMsg: ChatMessage = {
      id: 'user-' + Date.now(),
      sender: 'user',
      text,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      language: currentLanguage,
    };

    setMessages((prev) => [...prev, userMsg]);
    setInputVal('');

    // Generate intelligent contextual reply in farmer's preferred language
    setTimeout(() => {
      let replyText = '';
      const lower = text.toLowerCase();

      if (lower.includes('fertilizer') || lower.includes('paddy') || lower.includes('వరి') || lower.includes('खाद')) {
        replyText = `Based on your farm's Soil Health Card (${profile?.district || 'Guntur'}, pH ${profile?.farm_details?.ph_level || 6.8}), your optimal fertilizer dose for Paddy is: 100 kg Urea + 50 kg DAP + 40 kg MOP per acre. Apply DAP and MOP as basal dose before puddling, and split Urea into two top dressings at 30 days and panicle initiation.`;
      } else if (lower.includes('rust') || lower.includes('disease') || lower.includes('తెగులు') || lower.includes('रोग')) {
        replyText = `For fungal leaf spots or rust, spray Propiconazole 25% EC @ 1ml per litre of water or Mancozeb 75% WP @ 2.5g/L during early morning hours. Also avoid excessive nitrogen top-dressing to prevent succulent leaf spread.`;
      } else if (lower.includes('price') || lower.includes('mandi') || lower.includes('ధర') || lower.includes('भाव')) {
        replyText = `Today's modal price for Paddy in Guntur APMC is ₹2,320 / Quintal (+3.2% trend), and Cotton is trading at ₹7,150 / Quintal. Market arrivals are steady with strong wholesale buyer demand.`;
      } else if (lower.includes('kisan') || lower.includes('scheme') || lower.includes('పథకం') || lower.includes('योजना')) {
        replyText = `You are eligible for PM-KISAN (₹6,000/year via direct bank transfer). Ensure your Aadhaar is linked with e-KYC on pmkisan.gov.in. You can also avail 50% farm machinery subsidy through the SMAM portal.`;
      } else {
        replyText = `Thank you for your question, ${user?.full_name?.split(' ')[0] || 'Farmer'}. In your region (${profile?.district || 'Guntur'}, ${profile?.state || 'Andhra Pradesh'}), current weather and soil moisture are favorable for Kharif farming operations. Feel free to ask about crop choices, pest remediation, or market wholesale rates in ${languageInfo.nativeName}!`;
      }

      const botMsg: ChatMessage = {
        id: 'bot-' + Date.now(),
        sender: 'assistant',
        text: replyText,
        timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        language: currentLanguage,
      };

      setMessages((prev) => [...prev, botMsg]);
    }, 700);
  };

  const handleVoiceToggle = () => {
    if (!isListening) {
      setIsListening(true);
      setTimeout(() => {
        setIsListening(false);
        setInputVal('What is the fertilizer schedule for my paddy crop?');
      }, 2500);
    } else {
      setIsListening(false);
    }
  };

  return (
    <div className="assistant-page">
      <div className="assistant-header-strip">
        <div className="assistant-title-group">
          <div className="assistant-avatar">
            <Bot size={24} />
          </div>
          <div>
            <h1 className="assistant-title">{t('assistant.title')}</h1>
            <p className="assistant-subtitle">
              Responding in <strong>{languageInfo.nativeName} ({languageInfo.englishName})</strong>
            </p>
          </div>
        </div>
      </div>

      {/* Chat Area */}
      <div className="chat-window-card">
        <div className="messages-area">
          {messages.map((msg) => (
            <div key={msg.id} className={`message-bubble-row ${msg.sender}`}>
              <div className="bubble-avatar">
                {msg.sender === 'assistant' ? <Bot size={18} /> : <User size={18} />}
              </div>
              <div className="bubble-content-wrap">
                <div className="bubble-content">
                  <p>{msg.text}</p>
                </div>
                <span className="bubble-time">{msg.timestamp}</span>

                {/* Suggested Prompt Chips */}
                {msg.suggested_prompts && msg.suggested_prompts.length > 0 && (
                  <div className="suggested-prompts-row">
                    <span className="prompt-label">{t('assistant.suggestedTitle')}:</span>
                    <div className="prompt-chips">
                      {msg.suggested_prompts.map((p, idx) => (
                        <button
                          key={idx}
                          type="button"
                          onClick={() => handleSend(p)}
                          className="prompt-chip"
                        >
                          <span>{p}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        {/* Input Bar */}
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSend();
          }}
          className="chat-input-bar"
        >
          {isListening && (
            <div className="listening-pulse-banner">
              <Mic size={16} className="spin-icon text-red" />
              <span>{t('assistant.voiceListening')}</span>
            </div>
          )}

          <input
            type="text"
            value={inputVal}
            onChange={(e) => setInputVal(e.target.value)}
            placeholder={t('assistant.inputPlaceholder')}
            className="chat-text-input"
          />

          <button
            type="button"
            onClick={handleVoiceToggle}
            className={`voice-btn ${isListening ? 'active-listening' : ''}`}
            title={t('assistant.voiceInput')}
          >
            {isListening ? <MicOff size={18} /> : <Mic size={18} />}
          </button>

          <button
            type="submit"
            disabled={!inputVal.trim()}
            className="chat-send-btn"
            title={t('assistant.send')}
          >
            <Send size={18} />
          </button>
        </form>
      </div>
    </div>
  );
};
'''

with open('src/pages/AIAssistantPage.tsx', 'w', encoding='utf-8') as f:
    f.write(assistant_code)
print('AIAssistantPage.tsx created')

# 3. ProfilePage.tsx
profile_code = '''import React, { useState } from 'react';
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
'''

with open('src/pages/ProfilePage.tsx', 'w', encoding='utf-8') as f:
    f.write(profile_code)
print('ProfilePage.tsx created')

# 4. SettingsPage.tsx
settings_code = '''import React from 'react';
import { useTranslation } from 'react-i18next';
import { Settings, Globe, Check, Bell, Database, Shield, Smartphone } from 'lucide-react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { LanguageCode } from '../types';

export const SettingsPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentLanguage, supportedLanguages, setLanguage } = useLanguage();
  const { user } = useAuth();

  const handleLanguageChange = async (code: LanguageCode) => {
    await setLanguage(code, user?.id);
  };

  return (
    <div className="settings-page">
      <div className="page-header-strip">
        <div>
          <h1 className="page-title">{t('settings.title')}</h1>
          <p className="page-subtitle">{t('settings.subtitle')}</p>
        </div>
      </div>

      {/* GLOBAL APPLICATION LANGUAGE SETTING */}
      <div className="settings-card language-management-card">
        <div className="settings-card-header">
          <div className="settings-title-wrap">
            <Globe size={24} className="text-green" />
            <div>
              <h2>{t('settings.languageTitle')}</h2>
              <p className="settings-desc">{t('settings.languageDescription')}</p>
            </div>
          </div>
        </div>

        <div className="settings-languages-grid">
          {supportedLanguages.map((lang) => {
            const isSelected = currentLanguage === lang.code;
            return (
              <button
                key={lang.code}
                type="button"
                onClick={() => handleLanguageChange(lang.code)}
                className={`settings-lang-button ${isSelected ? 'active' : ''}`}
              >
                <div className="button-top-row">
                  <span className="lang-badge-pill">{lang.badge}</span>
                  {isSelected && (
                    <span className="check-indicator">
                      <Check size={16} />
                    </span>
                  )}
                </div>

                <div className="button-titles">
                  <span className="lang-native">{lang.nativeName}</span>
                  <span className="lang-english">{lang.englishName}</span>
                </div>

                <div className="button-preview">
                  <span className="greeting">{lang.greeting}!</span>
                  <p className="sample-text">{lang.sampleText}</p>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* App Preferences */}
      <div className="settings-card">
        <div className="settings-card-header">
          <div className="settings-title-wrap">
            <Settings size={22} className="text-blue" />
            <div>
              <h3>{t('settings.appPreferences')}</h3>
              <p className="settings-desc">System configurations and offline performance</p>
            </div>
          </div>
        </div>

        <div className="preferences-list">
          <div className="pref-item">
            <div className="pref-info">
              <Database size={20} className="pref-icon text-green" />
              <div>
                <h4>{t('settings.offlineMode')}</h4>
                <p>Caches advisory history, weather reports, and schemes for offline rural access</p>
              </div>
            </div>
            <span className="pref-status-pill active">Enabled</span>
          </div>

          <div className="pref-item">
            <div className="pref-info">
              <Bell size={20} className="pref-icon text-amber" />
              <div>
                <h4>{t('settings.notifications')}</h4>
                <p>Receive timely alerts for heavy rainfall, pest outbreaks, and price surges</p>
              </div>
            </div>
            <span className="pref-status-pill active">Enabled</span>
          </div>

          <div className="pref-item">
            <div className="pref-info">
              <Smartphone size={20} className="pref-icon text-purple" />
              <div>
                <h4>Progressive Web App (PWA)</h4>
                <p>{t('settings.appVersion')} • Installable on Android & iOS homescreens</p>
              </div>
            </div>
            <span className="pref-status-pill">Ready</span>
          </div>
        </div>
      </div>
    </div>
  );
};
'''

with open('src/pages/SettingsPage.tsx', 'w', encoding='utf-8') as f:
    f.write(settings_code)
print('SettingsPage.tsx created')
