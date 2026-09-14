from typing import List
from pydantic import BaseModel, Field


class CropRequest(BaseModel):
    """Input parameters matching the deployed Crop Recommendation ML model API."""

    N: float = Field(..., ge=0.0, description="Nitrogen content in soil (kg/ha)", examples=[90.0])
    P: float = Field(..., ge=0.0, description="Phosphorus content in soil (kg/ha)", examples=[42.0])
    K: float = Field(..., ge=0.0, description="Potassium content in soil (kg/ha)", examples=[43.0])
    temperature: float = Field(..., description="Temperature in Celsius", examples=[20.87])
    humidity: float = Field(..., ge=0.0, le=100.0, description="Relative humidity percentage", examples=[82.0])
    ph: float = Field(..., ge=0.0, le=14.0, description="Soil pH value", examples=[6.5])
    rainfall: float = Field(..., ge=0.0, description="Rainfall in mm", examples=[202.93])


class CropRecommendationItem(BaseModel):
    crop: str = Field(..., description="Crop name")
    confidence: float = Field(..., description="Model confidence score / percentage")


class CropResponse(BaseModel):
    """Output schema from the deployed Crop Recommendation API."""

    recommended_crop: str = Field(..., description="Top recommended crop")
    recommendations: List[CropRecommendationItem] = Field(
        default_factory=list, description="Top ranked crop recommendations"
    )
