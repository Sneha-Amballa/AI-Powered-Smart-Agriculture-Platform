from typing import Optional
from fastapi import APIRouter, Query, status
from backend.schemas.scheme import GovernmentSchemeResponse, SchemeFilterRequest
from backend.services.scheme_service import scheme_service

router = APIRouter(prefix="/schemes", tags=["Government Schemes & Subsidies"])


@router.get(
    "/list",
    response_model=GovernmentSchemeResponse,
    status_code=status.HTTP_200_OK,
    summary="List government agricultural schemes and subsidies",
)
async def list_schemes(
    category: Optional[str] = Query(None, description="Filter by category (Subsidy, Insurance, Income Support, Irrigation)"),
    state: Optional[str] = Query(None, description="Filter by State"),
) -> GovernmentSchemeResponse:
    """Retrieve government schemes matching farmer profile criteria."""
    filter_req = SchemeFilterRequest(category=category, state=state)
    return await scheme_service.get_schemes(filter_req)
