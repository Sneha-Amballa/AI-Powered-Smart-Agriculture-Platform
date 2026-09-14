from typing import List, Optional
from pydantic import BaseModel, Field


class PestDetectionResponse(BaseModel):
    """Schema for pest identification and advisory."""

    pest_name: str = Field(..., description="Common name of identified agricultural pest")
    scientific_name: Optional[str] = Field(None, description="Biological scientific name")
    confidence: float = Field(..., description="Detection confidence score")
    severity_level: str = Field(..., description="Low, Moderate, or Severe infestation risk")
    affected_crops: List[str] = Field(default_factory=list, description="Target crop hosts")
    recommended_pesticides: List[str] = Field(
        default_factory=list, description="Approved insecticides / bio-controls"
    )
    organic_controls: List[str] = Field(
        default_factory=list, description="Natural and organic mitigation strategies"
    )
