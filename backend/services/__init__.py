"""Services package exposing business logic and ML integration handlers."""
from backend.services.crop_service import crop_service, CropRecommendationService
from backend.services.auth_service import auth_service, AuthService
from backend.services.disease_service import disease_service, DiseaseDetectionService
from backend.services.pest_service import pest_service, PestDetectionService
from backend.services.weather_service import weather_service, WeatherService
from backend.services.market_service import market_service, MarketService
from backend.services.scheme_service import scheme_service, SchemeService
from backend.services.chatbot_service import chatbot_service, ChatbotService
from backend.services.voice_service import voice_service, VoiceService

__all__ = [
    "crop_service",
    "CropRecommendationService",
    "auth_service",
    "AuthService",
    "disease_service",
    "DiseaseDetectionService",
    "pest_service",
    "PestDetectionService",
    "weather_service",
    "WeatherService",
    "market_service",
    "MarketService",
    "scheme_service",
    "SchemeService",
    "chatbot_service",
    "ChatbotService",
    "voice_service",
    "VoiceService",
]
