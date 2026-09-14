from typing import List, Optional
from pydantic import BaseModel, Field


class GovernmentSchemeItem(BaseModel):
    scheme_name: str
    category: str = Field(..., description="Subsidy, Credit, Insurance, Irrigation, Solar, etc.")
    administering_body: str = Field(..., description="Central or State Ministry")
    short_description: str
    benefits: str
    eligibility_criteria: List[str]
    required_documents: List[str]
    official_portal_url: Optional[str] = None


class GovernmentSchemeResponse(BaseModel):
    total_schemes: int
    schemes: List[GovernmentSchemeItem] = Field(default_factory=list)


class SchemeFilterRequest(BaseModel):
    state: Optional[str] = None
    farm_size_acres: Optional[float] = None
    category: Optional[str] = None
