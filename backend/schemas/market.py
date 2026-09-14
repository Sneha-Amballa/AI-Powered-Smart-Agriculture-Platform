from datetime import date
from typing import List, Optional
from pydantic import BaseModel, Field


class MandiPriceItem(BaseModel):
    commodity: str
    variety: Optional[str] = None
    market_name: str
    state: str
    district: str
    min_price_per_quintal: float
    max_price_per_quintal: float
    modal_price_per_quintal: float
    arrival_date: date


class PricePredictionPoint(BaseModel):
    date: str
    predicted_price: float
    trend: str = Field(..., description="'UP', 'DOWN', or 'STABLE'")


class MarketPriceResponse(BaseModel):
    """Schema for current APMC Mandi prices."""

    commodity: str
    records: List[MandiPriceItem] = Field(default_factory=list)


class PricePredictionResponse(BaseModel):
    """Schema for future market price trends and forecasts."""

    commodity: str
    forecast_days: int
    predictions: List[PricePredictionPoint] = Field(default_factory=list)
    market_sentiment: str = Field(..., description="Bullish / Bearish / Neutral")
