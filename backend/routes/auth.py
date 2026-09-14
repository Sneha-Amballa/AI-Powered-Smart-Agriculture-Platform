from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.core.database import get_db
from backend.schemas.auth import (
    UserRegister,
    UserLogin,
    UserResponse,
    AuthResponse,
    FarmerProfileSetup,
    FarmerProfileResponse,
)
from backend.services.auth_service import auth_service

router = APIRouter(prefix="/auth", tags=["Authentication & Farmer Profile"])


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new farmer account",
)
def register(user_in: UserRegister, db: Session = Depends(get_db)):
    """Create new farmer user account without OTP/email requirements."""
    try:
        user = auth_service.register_user(db, user_in)
        return user
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        )


@router.post(
    "/login",
    response_model=AuthResponse,
    status_code=status.HTTP_200_OK,
    summary="Login with mobile number and password",
)
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    """Authenticate farmer credentials and obtain JWT bearer token and profile status."""
    auth_data = auth_service.authenticate_user(db, login_data)
    if not auth_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect mobile number or password",
        )
    return auth_data


@router.post(
    "/profile-setup",
    response_model=FarmerProfileResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Save guided farmer location and farm parameters",
)
def setup_profile(
    user_id: int,
    setup_in: FarmerProfileSetup,
    db: Session = Depends(get_db),
):
    """Persist completed 3-step farmer setup wizard data in PostgreSQL."""
    try:
        profile = auth_service.save_farmer_profile(db, user_id, setup_in)
        return profile
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(exc),
        )


@router.get(
    "/profile/{user_id}",
    response_model=UserResponse,
    summary="Get complete farmer profile and farm parameters",
)
def get_farmer_profile(user_id: int, db: Session = Depends(get_db)):
    """Retrieve farmer profile with farm parameters and soil metrics."""
    user = auth_service.get_farmer_profile(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Farmer profile for user {user_id} not found",
        )
    return user

