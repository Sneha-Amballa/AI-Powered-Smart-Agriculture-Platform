import os
from typing import List, Union
from pydantic_settings import BaseSettings
from pydantic import AnyHttpUrl, field_validator


class Settings(BaseSettings):
    PROJECT_NAME: str = "AI-Powered Smart Agriculture Platform API"
    PROJECT_DESCRIPTION: str = (
        "Modular backend powering crop recommendations, plant disease detection, "
        "pest identification, weather forecasting, market price analysis, "
        "government schemes, and multilingual AI advisory."
    )
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"

    # Environment
    ENVIRONMENT: str = "development"
    DEBUG: bool = True

    # Database Configuration (PostgreSQL / Supabase)
    # Default fallback to SQLite enables instant zero-setup local runs
    DATABASE_URL: str = "sqlite:///./smart_agriculture.db"
    DB_ECHO: bool = False

    # Supabase (Optional direct integration)
    SUPABASE_URL: str = ""
    SUPABASE_KEY: str = ""

    # Deployed Machine Learning Service Endpoints
    # The Crop Recommendation ML model is completed and deployed on Render
    CROP_RECOMMENDATION_API_URL: str = "https://crop-recommendation-system-0c1p.onrender.com"

    # External APIs
    WEATHER_API_KEY: str = ""
    WEATHER_API_BASE_URL: str = "https://api.openweathermap.org/data/2.5"
    GEMINI_API_KEY: str = ""

    # LibreTranslate (free/open-source translation)
    LIBRETRANSLATE_URL: str = "https://libretranslate.com"
    LIBRETRANSLATE_API_KEY: str = ""

    # Security & Authentication (JWT)
    SECRET_KEY: str = "smart-agri-dev-secret-key-change-in-production-12345678"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    # CORS configuration
    BACKEND_CORS_ORIGINS: List[str] = ["*"]

    @field_validator("DATABASE_URL", mode="before")
    @classmethod
    def assemble_db_connection(cls, v: Union[str, None]) -> str:
        if not v:
            return "sqlite:///./smart_agriculture.db"
        # Support postgres:// URL format sometimes provided by cloud providers
        if v.startswith("postgres://"):
            return v.replace("postgres://", "postgresql://", 1)
        return v

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = True
        extra = "allow"


settings = Settings()
