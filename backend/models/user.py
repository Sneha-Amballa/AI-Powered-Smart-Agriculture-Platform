from datetime import datetime, timezone
from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from backend.core.database import Base


class User(Base):
    """Core Farmer Authentication and User Account Model."""

    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, nullable=False)
    phone_number = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=True)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)

    # Relationship to 1-to-1 Farmer Profile
    profile = relationship(
        "FarmerProfile",
        back_populates="user",
        uselist=False,
        cascade="all, delete-orphan",
    )

    # Timestamps
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )


class FarmerProfile(Base):
    """Farmer Regional Demographics and Operational Profile."""

    __tablename__ = "farmer_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
    )

    # Location Information (Manual, No GPS permission)
    state = Column(String, nullable=False)
    district = Column(String, nullable=False)
    village = Column(String, nullable=False)
    pincode = Column(String, nullable=True)

    # Demographics
    farming_experience_years = Column(Integer, nullable=True)

    # Relationships
    user = relationship("User", back_populates="profile")
    farm_details = relationship(
        "FarmDetails",
        back_populates="profile",
        uselist=False,
        cascade="all, delete-orphan",
    )

    # Timestamps
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )


class FarmDetails(Base):
    """Farm Land, Soil Properties, and Agronomic Infrastructure."""

    __tablename__ = "farm_details"

    id = Column(Integer, primary_key=True, index=True)
    profile_id = Column(
        Integer,
        ForeignKey("farmer_profiles.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
    )

    # Land Area
    land_area = Column(Float, nullable=False)
    area_unit = Column(String, default="Acres")  # 'Acres' or 'Hectares'

    # Soil Testing & Classification
    has_soil_report = Column(Boolean, default=False)
    soil_type = Column(String, nullable=True)  # Used when has_soil_report is False
    nitrogen_n = Column(Float, nullable=True)  # kg/ha
    phosphorus_p = Column(Float, nullable=True)  # kg/ha
    potassium_k = Column(Float, nullable=True)  # kg/ha
    ph_level = Column(Float, nullable=True)  # 0.0 - 14.0

    # Farming Infrastructure
    irrigation_type = Column(String, nullable=False)  # Borewell, Canal, Drip, Sprinkler, Rainfed
    primary_crop = Column(String, nullable=True)

    # Relationship
    profile = relationship("FarmerProfile", back_populates="farm_details")

    # Timestamps
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

