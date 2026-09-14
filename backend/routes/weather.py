from typing import Optional
from fastapi import APIRouter, Query, status
from backend.schemas.weather import WeatherResponse
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
) -> WeatherResponse:
    """Retrieve temperature, humidity, rainfall probability, and farming advisory."""
    return await weather_service.get_weather_forecast(lat, lon, location_name)
