from typing import Optional
from fastapi import APIRouter, Query, status
from backend.schemas.market import MarketPriceResponse, PricePredictionResponse
from backend.services.market_service import market_service

router = APIRouter(prefix="/market", tags=["Market Prices & Price Prediction"])


@router.get(
    "/prices",
    response_model=MarketPriceResponse,
    status_code=status.HTTP_200_OK,
    summary="Get current APMC mandi prices for crops",
)
async def get_market_prices(
    commodity: str = Query(..., description="Crop commodity name, e.g., Paddy, Cotton, Onion", examples=["Paddy"]),
    state: Optional[str] = Query(None, description="Filter by Indian State"),
) -> MarketPriceResponse:
    """Retrieve APMC market prices across regional mandis."""
    return await market_service.get_mandi_prices(commodity, state)


@router.get(
    "/predict-trend",
    response_model=PricePredictionResponse,
    status_code=status.HTTP_200_OK,
    summary="Predict commodity price trends over upcoming days",
)
async def predict_price_trend(
    commodity: str = Query(..., description="Commodity to predict", examples=["Paddy"]),
    days: int = Query(7, ge=1, le=30, description="Forecast horizon in days"),
) -> PricePredictionResponse:
    """Forecast future price movement and market sentiment."""
    return await market_service.predict_price_trend(commodity, days)
