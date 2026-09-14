/// Centralized API Endpoints configuration for Smart Agriculture App.
class ApiEndpoints {
  // Production Machine Learning Endpoint (COMPLETED & DEPLOYED)
  static const String cropRecommendationProductionUrl =
      'https://crop-recommendation-system-0c1p.onrender.com';
  static const String cropRecommendationDocsUrl =
      'https://crop-recommendation-system-0c1p.onrender.com/docs';
  static const String predictCrop = '/predict-crop';

  // Backend API Gateway Base URL
  // Default points to localhost (10.0.2.2 for Android emulator)
  static const String defaultLocalBaseUrl = 'http://10.0.2.2:8000/api/v1';

  // Planned Backend Service Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authProfile = '/auth/profile/me';

  static const String diseaseDetect = '/disease/detect';
  static const String pestDetect = '/pest/detect';
  static const String weatherForecast = '/weather/forecast';
  static const String marketPrices = '/market/prices';
  static const String marketPredictTrend = '/market/predict-trend';
  static const String schemesList = '/schemes/list';
  static const String chatbotMessage = '/chatbot/message';
  static const String voiceQuery = '/voice/query';
}
