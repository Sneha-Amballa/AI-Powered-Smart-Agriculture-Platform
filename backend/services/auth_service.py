from typing import Optional, Dict, Any
from sqlalchemy.orm import Session
from backend.core.security import get_password_hash, verify_password, create_access_token
from backend.models.user import User, FarmerProfile, FarmDetails
from backend.schemas.auth import UserRegister, UserLogin, FarmerProfileSetup


class AuthService:
    """Authentication and Farmer Profile business logic."""

    def register_user(self, db: Session, user_in: UserRegister) -> User:
        """Register a new farmer user in PostgreSQL/Supabase database."""
        existing_phone = (
            db.query(User).filter(User.phone_number == user_in.phone_number).first()
        )
        if existing_phone:
            raise ValueError("Mobile number is already registered")

        db_user = User(
            full_name=user_in.full_name.strip(),
            phone_number=user_in.phone_number.strip(),
            hashed_password=get_password_hash(user_in.password),
            preferred_language=(user_in.preferred_language or "en").strip().lower(),
            is_active=True,
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    def authenticate_user(
        self, db: Session, login_data: UserLogin
    ) -> Optional[Dict[str, Any]]:
        """Authenticate user phone & password and return token with profile state."""
        user = db.query(User).filter(User.phone_number == login_data.phone_number.strip()).first()
        if not user or not verify_password(login_data.password, user.hashed_password):
            return None

        # Check whether the profile is complete
        is_profile_complete = (
            user.profile is not None
            and user.profile.farm_details is not None
            and user.profile.farm_details.land_area > 0
        )

        access_token = create_access_token(subject=user.id)
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": user,
            "is_profile_complete": is_profile_complete,
        }

    def save_farmer_profile(
        self, db: Session, user_id: int, setup_in: FarmerProfileSetup
    ) -> FarmerProfile:
        """Persist or update farmer location and farm details in database."""
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise ValueError(f"User with ID {user_id} not found")

        # Location & Farmer Profile
        profile = db.query(FarmerProfile).filter(FarmerProfile.user_id == user_id).first()
        loc = setup_in.location
        farm = setup_in.farm_details

        if not profile:
            profile = FarmerProfile(
                user_id=user_id,
                state=loc.state,
                district=loc.district,
                village=loc.village,
                pincode=loc.pincode,
                farming_experience_years=farm.farming_experience_years,
            )
            db.add(profile)
            db.flush()
        else:
            profile.state = loc.state
            profile.district = loc.district
            profile.village = loc.village
            profile.pincode = loc.pincode
            profile.farming_experience_years = farm.farming_experience_years

        # Farm Details
        details = db.query(FarmDetails).filter(FarmDetails.profile_id == profile.id).first()
        if not details:
            details = FarmDetails(
                profile_id=profile.id,
                land_area=farm.land_area,
                area_unit=farm.area_unit,
                has_soil_report=farm.has_soil_report,
                soil_type=farm.soil_type if not farm.has_soil_report else None,
                nitrogen_n=farm.nitrogen_n if farm.has_soil_report else None,
                phosphorus_p=farm.phosphorus_p if farm.has_soil_report else None,
                potassium_k=farm.potassium_k if farm.has_soil_report else None,
                ph_level=farm.ph_level if farm.has_soil_report else None,
                irrigation_type=farm.irrigation_type,
                primary_crop=farm.primary_crop,
            )
            db.add(details)
        else:
            details.land_area = farm.land_area
            details.area_unit = farm.area_unit
            details.has_soil_report = farm.has_soil_report
            details.soil_type = farm.soil_type if not farm.has_soil_report else None
            details.nitrogen_n = farm.nitrogen_n if farm.has_soil_report else None
            details.phosphorus_p = farm.phosphorus_p if farm.has_soil_report else None
            details.potassium_k = farm.potassium_k if farm.has_soil_report else None
            details.ph_level = farm.ph_level if farm.has_soil_report else None
            details.irrigation_type = farm.irrigation_type
            details.primary_crop = farm.primary_crop

        if setup_in.preferred_language:
            user.preferred_language = setup_in.preferred_language
            if profile:
                profile.preferred_language = setup_in.preferred_language

        db.commit()
        db.refresh(profile)
        return profile

    def update_user_language(self, db: Session, user_id: int, language: str) -> User:
        """Update farmer's preferred language globally in User and FarmerProfile."""
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            raise ValueError(f"User with ID {user_id} not found")
        
        user.preferred_language = language
        if user.profile:
            user.profile.preferred_language = language
            
        db.commit()
        db.refresh(user)
        return user

    def get_farmer_profile(self, db: Session, user_id: int) -> Optional[User]:
        """Fetch user with profile and farm details."""
        return db.query(User).filter(User.id == user_id).first()


auth_service = AuthService()

