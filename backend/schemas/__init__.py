"""Schemas package exporting Pydantic request and response models."""
from backend.schemas.auth import (
    UserRegister,
    UserLogin,
    Token,
    UserProfileResponse,
)
from backend.schemas.crop_recommendation import (
    CropRequest,
    CropResponse,
    CropRecommendationItem,
)
from backend.schemas.disease import DiseaseDetectionResponse
from backend.schemas.pest import PestDetectionResponse
from backend.schemas.weather import WeatherResponse, WeatherData, AgriculturalAdvisory
from backend.schemas.market import MarketPriceResponse, PricePredictionResponse
from backend.schemas.scheme import GovernmentSchemeResponse, GovernmentSchemeItem
from backend.schemas.chatbot import ChatRequest, ChatResponse, ChatMessage
from backend.schemas.voice import VoiceQueryRequest, VoiceQueryResponse

__all__ = [
    "UserRegister",
    "UserLogin",
    "Token",
    "UserProfileResponse",
    "CropRequest",
    "CropResponse",
    "CropRecommendationItem",
    "DiseaseDetectionResponse",
    "PestDetectionResponse",
    "WeatherResponse",
    "WeatherData",
    "AgriculturalAdvisory",
    "MarketPriceResponse",
    "PricePredictionResponse",
    "GovernmentSchemeResponse",
    "GovernmentSchemeItem",
    "ChatRequest",
    "ChatResponse",
    "ChatMessage",
    "VoiceQueryRequest",
    "VoiceQueryResponse",
]
