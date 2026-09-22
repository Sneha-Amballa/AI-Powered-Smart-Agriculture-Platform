import React, { useState } from 'react';
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
