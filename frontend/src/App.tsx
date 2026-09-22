import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { LanguageProvider } from './context/LanguageContext';
import { AuthProvider } from './context/AuthContext';
import { Navbar } from './components/layout/Navbar';
import { Footer } from './components/layout/Footer';
import { Toast } from './components/common/Toast';
import { LanguageSelectorModal } from './components/common/LanguageSelectorModal';

import { LandingPage } from './pages/LandingPage';
import { RegisterPage } from './pages/RegisterPage';
import { LoginPage } from './pages/LoginPage';
import { DashboardPage } from './pages/DashboardPage';
import { CropRecommendationPage } from './pages/CropRecommendationPage';
import { CropHistoryPage } from './pages/CropHistoryPage';
import { DiseaseDetectionPage } from './pages/DiseaseDetectionPage';
import { WeatherPage } from './pages/WeatherPage';
import { MarketPage } from './pages/MarketPage';
import { SchemesPage } from './pages/SchemesPage';
import { AIAssistantPage } from './pages/AIAssistantPage';
import { ProfilePage } from './pages/ProfilePage';
import { SettingsPage } from './pages/SettingsPage';

function App() {
  return (
    <LanguageProvider>
      <AuthProvider>
        <BrowserRouter>
          <div className="app-shell">
            <Navbar />
            <main className="main-content">
              <Routes>
                <Route path="/" element={<LandingPage />} />
                <Route path="/register" element={<RegisterPage />} />
                <Route path="/login" element={<LoginPage />} />
                <Route path="/dashboard" element={<DashboardPage />} />
                <Route path="/crop-recommendation" element={<CropRecommendationPage />} />
                <Route path="/crop-history" element={<CropHistoryPage />} />
                <Route path="/disease-detection" element={<DiseaseDetectionPage />} />
                <Route path="/weather" element={<WeatherPage />} />
                <Route path="/market" element={<MarketPage />} />
                <Route path="/schemes" element={<SchemesPage />} />
                <Route path="/assistant" element={<AIAssistantPage />} />
                <Route path="/profile" element={<ProfilePage />} />
                <Route path="/settings" element={<SettingsPage />} />
                <Route path="*" element={<Navigate to="/" replace />} />
              </Routes>
            </main>
            <Footer />
            <LanguageSelectorModal />
            <Toast />
          </div>
        </BrowserRouter>
      </AuthProvider>
    </LanguageProvider>
  );
}

export default App;
