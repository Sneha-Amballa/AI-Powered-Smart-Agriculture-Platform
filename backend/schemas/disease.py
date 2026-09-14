from typing import List, Optional
from pydantic import BaseModel, Field


class DiseaseDetectionResponse(BaseModel):
    """Schema for plant disease diagnosis result."""

    disease_name: str = Field(..., description="Identified disease or 'Healthy'")
    crop_name: Optional[str] = Field(None, description="Crop identified")
    confidence: float = Field(..., description="Detection confidence between 0.0 and 1.0")
    description: str = Field(..., description="Overview of the disease symptoms")
    treatment_recommendations: List[str] = Field(
        default_factory=list, description="Recommended organic/chemical remedies"
    )
    prevention_tips: List[str] = Field(
        default_factory=list, description="Preventive cultural practices"
    )
