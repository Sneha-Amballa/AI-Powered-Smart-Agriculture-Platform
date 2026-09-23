from datetime import datetime
from typing import Optional
from pydantic import BaseModel, Field


class UserRegister(BaseModel):
    """Zero-cost frictionless farmer registration payload."""
    full_name: str = Field(..., min_length=2, max_length=100)
    phone_number: str = Field(..., min_length=10, max_length=15)
    password: str = Field(..., min_length=6)
    preferred_language: Optional[str] = Field("en", min_length=2, max_length=5)


class UserLogin(BaseModel):
    """Phone number and password credentials."""
    phone_number: str
    password: str


class Token(BaseModel):
    """JWT bearer token structure."""
    access_token: str
    token_type: str = "bearer"


class LocationSetup(BaseModel):
    """Farmer location setup (GPS coordinates or manual fallback)."""
    state: str = Field(..., min_length=2)
    district: str = Field(..., min_length=2)
    village: str = Field(..., min_length=2)
    pincode: Optional[str] = Field(None, max_length=10)
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class FarmDetailsSetup(BaseModel):
    """Farm land, soil testing, and irrigation properties."""
    land_area: float = Field(..., gt=0)
    area_unit: str = Field("Acres")
    has_soil_report: bool = False
    soil_type: Optional[str] = None
    nitrogen_n: Optional[float] = None
    phosphorus_p: Optional[float] = None
    potassium_k: Optional[float] = None
    ph_level: Optional[float] = Field(None, ge=0.0, le=14.0)
    irrigation_type: str = Field(...)
    primary_crop: Optional[str] = None
    farming_experience_years: Optional[int] = Field(None, ge=0, le=80)


class FarmerProfileSetup(BaseModel):
    """Complete multi-step onboarding payload."""
    preferred_language: Optional[str] = Field(None, min_length=2, max_length=5)
    location: LocationSetup
    farm_details: FarmDetailsSetup


class FarmDetailsResponse(BaseModel):
    id: int
    land_area: float
    area_unit: str
    has_soil_report: bool
    soil_type: Optional[str] = None
    nitrogen_n: Optional[float] = None
    phosphorus_p: Optional[float] = None
    potassium_k: Optional[float] = None
    ph_level: Optional[float] = None
    irrigation_type: str
    primary_crop: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class FarmerProfileResponse(BaseModel):
    id: int
    user_id: int
    preferred_language: str = "en"
    state: str
    district: str
    village: str
    pincode: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    farming_experience_years: Optional[int] = None
    farm_details: Optional[FarmDetailsResponse] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True



class UserResponse(BaseModel):
    id: int
    full_name: str
    phone_number: str
    preferred_language: str = "en"
    is_active: bool
    created_at: datetime
    profile: Optional[FarmerProfileResponse] = None

    class Config:
        from_attributes = True


class LanguageUpdate(BaseModel):
    """Payload to update farmer preferred language."""
    preferred_language: str = Field(..., min_length=2, max_length=5)


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse
    is_profile_complete: bool


# Backward compatibility alias
UserProfileResponse = UserResponse

