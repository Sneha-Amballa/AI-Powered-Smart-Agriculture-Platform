import React, { useState } from 'react';
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
