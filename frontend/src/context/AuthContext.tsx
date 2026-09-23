import React, { createContext, useContext, useState, useEffect } from 'react';
import { User, FarmerProfile, LanguageCode } from '../types';
import { useLanguage } from './LanguageContext';
import { api } from '../services/api';

interface RegisteredAccount {
  user: User;
  passwordHash: string;
  profile?: FarmerProfile;
}

interface AuthContextType {
  user: User | null;
  profile: FarmerProfile | null;
  isAuthenticated: boolean;
  login: (identifier: string, pass: string) => Promise<boolean>;
  register: (name: string, phone: string, pass: string, lang: LanguageCode) => Promise<boolean>;
  logout: () => void;
  updateProfile: (updated: Partial<FarmerProfile>) => Promise<void>;
  updateUserLanguage: (lang: LanguageCode) => Promise<void>;
}

export const DEFAULT_DEMO_PROFILE: FarmerProfile = {
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

export const DEFAULT_DEMO_USER: User = {
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

  // Users start unauthenticated by default unless a saved session is present in localStorage
  const [user, setUser] = useState<User | null>(() => {
    const saved = localStorage.getItem('kisan_auth_user');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch {
        return null;
      }
    }
    return null;
  });

  const [profile, setProfile] = useState<FarmerProfile | null>(() => {
    const savedUser = localStorage.getItem('kisan_auth_user');
    if (!savedUser) return null;
    if (user?.profile) return user.profile;
    const savedProf = localStorage.getItem('kisan_farmer_profile');
    if (savedProf) {
      try {
        return JSON.parse(savedProf);
      } catch {
        return null;
      }
    }
    return null;
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

  const cleanPhone = (val: string): string => {
    return val.replace(/[\s\-\(\)]/g, '').replace(/^\+91/, '').replace(/^0/, '');
  };

  const login = async (identifier: string, pass: string): Promise<boolean> => {
    const trimmedId = identifier.trim();
    const trimmedPass = pass.trim();

    if (!trimmedId || !trimmedPass) {
      throw new Error('Please enter both mobile/username and password');
    }

    const cleanedId = cleanPhone(trimmedId);

    // 1. Attempt API server authentication if online
    try {
      const res = await api.login(trimmedId, trimmedPass);
      setUser(res.user);
      if (res.user.profile) {
        setProfile(res.user.profile);
        if (res.user.preferred_language) {
          await setLanguage(res.user.preferred_language, res.user.id);
        }
      }
      return true;
    } catch {
      // 2. Client-side authentication & validation against stored accounts
      const registeredRaw = localStorage.getItem('kisan_registered_accounts');
      const registeredList: RegisteredAccount[] = registeredRaw ? JSON.parse(registeredRaw) : [];

      const foundAccount = registeredList.find(
        (acc) =>
          cleanPhone(acc.user.phone_number) === cleanedId ||
          acc.user.phone_number === trimmedId ||
          acc.user.full_name.toLowerCase() === trimmedId.toLowerCase()
      );

      if (foundAccount) {
        if (foundAccount.passwordHash !== trimmedPass) {
          throw new Error('Incorrect password. Please verify and try again.');
        }
        setUser(foundAccount.user);
        setProfile(foundAccount.profile || foundAccount.user.profile || DEFAULT_DEMO_PROFILE);
        if (foundAccount.user.preferred_language) {
          await setLanguage(foundAccount.user.preferred_language, foundAccount.user.id);
        }
        return true;
      }

      // 3. Official Demo Farmer account credentials check
      const isDemoPhone = cleanedId === '9876543210' || trimmedId === '9876543210';
      const isDemoUser = trimmedId.toLowerCase() === 'ramesh' || trimmedId.toLowerCase() === 'ramesh patel';

      if (isDemoPhone || isDemoUser) {
        if (trimmedPass === 'kisan123' || trimmedPass === 'admin') {
          const demoUser: User = {
            ...DEFAULT_DEMO_USER,
            phone_number: isDemoPhone ? cleanedId : '9876543210',
          };
          setUser(demoUser);
          setProfile(DEFAULT_DEMO_PROFILE);
          if (demoUser.preferred_language) {
            await setLanguage(demoUser.preferred_language, demoUser.id);
          }
          return true;
        } else {
          throw new Error('Incorrect password. For the demo account, use password: kisan123');
        }
      }

      // 4. Reject unrecognized credentials with a clear message (do NOT auto-login)
      throw new Error('Account not found. Please check your credentials or create a new account.');
    }
  };

  const register = async (name: string, phone: string, pass: string, lang: LanguageCode): Promise<boolean> => {
    const trimmedName = name.trim();
    const cleanNumber = cleanPhone(phone);
    const trimmedPass = pass.trim();

    if (!trimmedName || !cleanNumber || !trimmedPass) {
      throw new Error('Please fill all required registration fields');
    }

    try {
      const newUser = await api.register(trimmedName, cleanNumber, trimmedPass, lang);
      setUser(newUser);
      await setLanguage(lang, newUser.id);
      return true;
    } catch {
      const mockProfile: FarmerProfile = {
        ...DEFAULT_DEMO_PROFILE,
        preferred_language: lang,
      };

      const mockUser: User = {
        id: Date.now(),
        full_name: trimmedName,
        phone_number: cleanNumber,
        preferred_language: lang,
        is_active: true,
        created_at: new Date().toISOString(),
        profile: mockProfile,
      };

      // Persist in local registered accounts store so the user can re-login subsequently
      try {
        const registeredRaw = localStorage.getItem('kisan_registered_accounts');
        const registeredList: RegisteredAccount[] = registeredRaw ? JSON.parse(registeredRaw) : [];
        registeredList.push({
          user: mockUser,
          passwordHash: trimmedPass,
          profile: mockProfile,
        });
        localStorage.setItem('kisan_registered_accounts', JSON.stringify(registeredList));
      } catch (e) {
        console.warn('Could not persist mock registration locally', e);
      }

      setUser(mockUser);
      setProfile(mockProfile);
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
