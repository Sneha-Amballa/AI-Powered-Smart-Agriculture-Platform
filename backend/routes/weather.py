from typing import Optional
from fastapi import APIRouter, Query, status
from backend.schemas.weather import (
    WeatherResponse,
    GeocodeResponse,
    ReverseGeocodeResponse,
)
from backend.services.weather_service import weather_service

router = APIRouter(prefix="/weather", tags=["Weather & Agromet Advisory"])


@router.get(
    "/forecast",
    response_model=WeatherResponse,
    status_code=status.HTTP_200_OK,
    summary="Get hyper-local weather and agricultural recommendations",
)
async def get_weather(
    lat: float = Query(..., description="Latitude of farm location", examples=[15.8281]),
    lon: float = Query(..., description="Longitude of farm location", examples=[78.0373]),
    location_name: Optional[str] = Query(None, description="Optional city or village name"),
    lang: str = Query("en", description="Language code for translated advisory content"),
) -> WeatherResponse:
    """Retrieve temperature, humidity, rainfall probability, and farming advisory."""
    return await weather_service.get_weather_forecast(lat, lon, location_name, lang=lang)


@router.get(
    "/geocode",
    response_model=GeocodeResponse,
    status_code=status.HTTP_200_OK,
    summary="Geocode village or district name into coordinates",
)
async def geocode_query(
    query: str = Query(..., min_length=2, description="Place or district name to search"),
) -> GeocodeResponse:
    """Convert a village, town, or district name into latitude and longitude coordinates."""
    return await weather_service.geocode_query(query)


@router.get(
    "/reverse-geocode",
    response_model=ReverseGeocodeResponse,
    status_code=status.HTTP_200_OK,
    summary="Reverse geocode coordinates into village and district",
)
async def reverse_geocode(
    lat: float = Query(..., description="Latitude"),
    lon: float = Query(..., description="Longitude"),
) -> ReverseGeocodeResponse:
    """Convert device GPS latitude and longitude into local administrative region."""
    return await weather_service.reverse_geocode(lat, lon)

