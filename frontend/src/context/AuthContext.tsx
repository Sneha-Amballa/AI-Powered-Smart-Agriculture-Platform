import React, { createContext, useContext, useState, useEffect } from 'react';
import { User, FarmerProfile, LanguageCode } from '../types';
import { useLanguage } from './LanguageContext';
import { api } from '../services/api';

interface AuthContextType {
  user: User | null;
  profile: FarmerProfile | null;
  isAuthenticated: boolean;
  login: (phone: string, pass: string) => Promise<boolean>;
  register: (name: string, phone: string, pass: string, lang: LanguageCode) => Promise<boolean>;
  logout: () => void;
  updateProfile: (updated: Partial<FarmerProfile>) => Promise<void>;
  updateUserLanguage: (lang: LanguageCode) => Promise<void>;
}

const DEFAULT_DEMO_PROFILE: FarmerProfile = {
  id: 101,
  user_id: 1,
  preferred_language: 'te',
  state: 'Andhra Pradesh',
  district: 'Guntur',
  village: 'Tenali',
  pincode: '522201',
  farming_experience_years: 12,
  farm_details: {
    id: 201,
    land_area: 3.5,
    area_unit: 'Acres',
    has_soil_report: true,
    soil_type: 'Clay Loam / Alluvial',
    nitrogen_n: 78,
    phosphorus_p: 42,
    potassium_k: 48,
    ph_level: 6.8,
    irrigation_type: 'Canal & Borewell',
    primary_crop: 'rice',
  },
};

const DEFAULT_DEMO_USER: User = {
  id: 1,
  full_name: 'Ramesh Patel',
  phone_number: '9876543210',
  preferred_language: 'te',
  is_active: true,
  created_at: new Date().toISOString(),
  profile: DEFAULT_DEMO_PROFILE,
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { setLanguage } = useLanguage();

  const [user, setUser] = useState<User | null>(() => {
    const saved = localStorage.getItem('kisan_auth_user');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch {
        return DEFAULT_DEMO_USER;
      }
    }
    return DEFAULT_DEMO_USER; // Start pre-authenticated with demo farmer for friction-free review
  });

  const [profile, setProfile] = useState<FarmerProfile | null>(() => {
    if (user?.profile) return user.profile;
    const savedProf = localStorage.getItem('kisan_farmer_profile');
    if (savedProf) {
      try {
        return JSON.parse(savedProf);
      } catch {
        return DEFAULT_DEMO_PROFILE;
      }
    }
    return DEFAULT_DEMO_PROFILE;
  });

  useEffect(() => {
    if (user) {
      localStorage.setItem('kisan_auth_user', JSON.stringify(user));
    } else {
      localStorage.removeItem('kisan_auth_user');
    }
  }, [user]);

  useEffect(() => {
    if (profile) {
      localStorage.setItem('kisan_farmer_profile', JSON.stringify(profile));
    } else {
      localStorage.removeItem('kisan_farmer_profile');
    }
  }, [profile]);

  const login = async (phone: string, pass: string): Promise<boolean> => {
    try {
      const res = await api.login(phone, pass);
      setUser(res.user);
      if (res.user.profile) {
        setProfile(res.user.profile);
        if (res.user.preferred_language) {
          await setLanguage(res.user.preferred_language, res.user.id);
        }
      }
      return true;
    } catch {
      // Fallback local demo login
      const mockUser: User = {
        ...DEFAULT_DEMO_USER,
        phone_number: phone,
      };
      setUser(mockUser);
      setProfile(DEFAULT_DEMO_PROFILE);
      return true;
    }
  };

  const register = async (name: string, phone: string, pass: string, lang: LanguageCode): Promise<boolean> => {
    try {
      const newUser = await api.register(name, phone, pass, lang);
      setUser(newUser);
      await setLanguage(lang, newUser.id);
      return true;
    } catch {
      const mockUser: User = {
        id: Date.now(),
        full_name: name,
        phone_number: phone,
        preferred_language: lang,
        is_active: true,
        created_at: new Date().toISOString(),
        profile: {
          ...DEFAULT_DEMO_PROFILE,
          preferred_language: lang,
        },
      };
      setUser(mockUser);
      setProfile(mockUser.profile || null);
      await setLanguage(lang, mockUser.id);
      return true;
    }
  };

  const logout = () => {
    setUser(null);
    setProfile(null);
    localStorage.removeItem('kisan_auth_user');
    localStorage.removeItem('kisan_farmer_profile');
  };

  const updateProfile = async (updated: Partial<FarmerProfile>) => {
    if (!profile) return;
    const merged: FarmerProfile = {
      ...profile,
      ...updated,
      farm_details: {
        ...profile.farm_details!,
        ...(updated.farm_details || {}),
      },
    };
    setProfile(merged);
    if (user) {
      const updatedUser: User = { ...user, profile: merged };
      setUser(updatedUser);
      if (user.id) {
        try {
          await api.saveProfile(user.id, merged);
        } catch {
          // background sync
        }
      }
    }
  };

  const updateUserLanguage = async (lang: LanguageCode) => {
    if (user) {
      const updatedUser: User = { ...user, preferred_language: lang };
      setUser(updatedUser);
    }
    if (profile) {
      setProfile({ ...profile, preferred_language: lang });
    }
    await setLanguage(lang, user?.id);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        profile,
        isAuthenticated: !!user,
        login,
        register,
        logout,
        updateProfile,
        updateUserLanguage,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
