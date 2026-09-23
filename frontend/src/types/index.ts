export type LanguageCode = 'en' | 'te' | 'hi';

export interface LanguageInfo {
  code: LanguageCode;
  nativeName: string;
  englishName: string;
  greeting: string;
  sampleText: string;
  badge: string;
}

export interface FarmDetails {
  id?: number;
  land_area: number;
  area_unit: string;
  has_soil_report: boolean;
  soil_type?: string | null;
  nitrogen_n?: number | null;
  phosphorus_p?: number | null;
  potassium_k?: number | null;
  ph_level?: number | null;
  irrigation_type: string;
  primary_crop?: string | null;
  created_at?: string;
}

export interface FarmerProfile {
  id?: number;
  user_id?: number;
  preferred_language: LanguageCode;
  state: string;
  district: string;
  village: string;
  pincode?: string | null;
  farming_experience_years?: number | null;
  farm_details?: FarmDetails | null;
  created_at?: string;
}

export interface User {
  id: number;
  full_name: string;
  phone_number: string;
  preferred_language: LanguageCode;
  is_active: boolean;
  created_at: string;
  profile?: FarmerProfile | null;
}

export interface CropRecommendationInput {
  nitrogen_n: number;
  phosphorus_p: number;
  potassium_k: number;
  ph_level: number;
  temperature: number;
  humidity: number;
  rainfall: number;
  state: string;
  district: string;
  land_area: number;
  area_unit: string;
  irrigation_type: string;
}

export interface CropRecommendationResult {
  id: string;
  recommended_crop: string;
  confidence: number;
  alternate_crops: string[];
  reason: string;
  seasonal_suitability: string;
  duration_days: string;
  soil_match: number;
  economics: {
    estimated_cost_per_acre: number;
    estimated_yield_per_acre: string;
    estimated_revenue_per_acre: number;
    profit_potential: string;
  };
  fertilizer_recommendation: {
    urea_kg: number;
    dap_kg: number;
    mop_kg: number;
    organic_compost_tons: number;
    schedule: string;
  };
  irrigation_guideline: string;
  risk_factors: string[];
  created_at: string;
  input_params: CropRecommendationInput;
}

export interface DiseaseDetectionResult {
  id: string;
  plant_name: string;
  disease_name: string;
  confidence: number;
  severity: 'low' | 'moderate' | 'high' | 'critical';
  causes: string;
  symptoms: string[];
  organic_treatments: string[];
  chemical_treatments: string[];
  preventive_measures: string[];
  analyzed_at: string;
}

export interface WeatherData {
  location: string;
  temperature: number;
  feels_like: number;
  humidity: number;
  wind_speed: number;
  rainfall_chance: number;
  condition: string;
  uv_index: number;
  advisory: string;
  forecast: {
    day: string;
    temp_max: number;
    temp_min: number;
    condition: string;
    rain_chance: number;
  }[];
}

export interface MandiPriceItem {
  id: string;
  crop_key: string;
  market_name: string;
  district: string;
  state: string;
  modal_price: number;
  min_price: number;
  max_price: number;
  price_change: number;
  arrival_quantity: string;
  updated_date: string;
}

export interface GovtScheme {
  id: string;
  scheme_key: string;
  official_title: string;
  ministry: string;
  benefit_amount: string;
  category: string;
  eligibility: string[];
  documents_required: string[];
  portal_url: string;
}

export interface ChatMessage {
  id: string;
  sender: 'user' | 'assistant';
  text: string;
  timestamp: string;
  language: LanguageCode;
  suggested_prompts?: string[];
}
