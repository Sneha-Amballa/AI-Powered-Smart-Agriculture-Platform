from typing import List, Optional
from pydantic import BaseModel, Field


class WeatherData(BaseModel):
    temperature: float = Field(..., description="Current temperature in Celsius")
    feels_like: float = Field(..., description="Apparent temperature in Celsius")
    humidity: float = Field(..., description="Humidity percentage")
    rainfall_probability: float = Field(0.0, description="Precipitation probability 0-100%")
    precipitation: float = Field(0.0, description="Current precipitation/rainfall in mm")
    rainfall: float = Field(0.0, description="Alias for precipitation in mm")
    seasonal_rainfall: float = Field(150.0, description="Seasonal cumulative rainfall in mm calibrated for ML crop model")
    wind_speed: float = Field(..., description="Wind speed in km/h or m/s")
    weather_condition: str = Field(..., description="Sunny, Rainy, Cloudy, etc.")
    icon_code: Optional[str] = None
    last_updated: Optional[str] = Field(None, description="ISO timestamp of weather observation")
    is_cached: bool = Field(False, description="Whether this response was served from cache")


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
    timezone: Optional[str] = Field("auto", description="Local timezone identifier")


class GeocodeItem(BaseModel):
    name: str
    latitude: float
    longitude: float
    country: Optional[str] = None
    state: Optional[str] = None
    district: Optional[str] = None


class GeocodeResponse(BaseModel):
    results: List[GeocodeItem] = Field(default_factory=list)


class ReverseGeocodeResponse(BaseModel):
    latitude: float
    longitude: float
    village: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    formatted: str

