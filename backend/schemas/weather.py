from typing import List, Optional
from pydantic import BaseModel, Field


class WeatherData(BaseModel):
    temperature: float = Field(..., description="Current temperature in Celsius")
    feels_like: float = Field(..., description="Apparent temperature in Celsius")
    humidity: float = Field(..., description="Humidity percentage")
    rainfall_probability: float = Field(0.0, description="Precipitation probability 0-100%")
    wind_speed: float = Field(..., description="Wind speed in km/h or m/s")
    weather_condition: str = Field(..., description="Sunny, Rainy, Cloudy, etc.")
    icon_code: Optional[str] = None


class AgriculturalAdvisory(BaseModel):
    irrigation_advice: str
    spraying_advisory: str
    harvest_recommendation: str


class WeatherResponse(BaseModel):
    """Schema for weather and farm-specific climate advisory."""

    location: str
    current: WeatherData
    advisory: AgriculturalAdvisory
    alerts: List[str] = Field(default_factory=list, description="Severe weather alerts")
