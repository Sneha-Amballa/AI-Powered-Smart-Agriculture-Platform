from typing import Optional
from backend.schemas.scheme import (
    GovernmentSchemeResponse,
    GovernmentSchemeItem,
    SchemeFilterRequest,
)


class SchemeService:
    """Service foundation for Government Agricultural Schemes and Subsidy recommendation."""

    def __init__(self):
        # Seeded catalog of major agricultural schemes
        self._schemes_catalog = [
            GovernmentSchemeItem(
                scheme_name="PM-KISAN (Pradhan Mantri Kisan Samman Nidhi)",
                category="Income Support",
                administering_body="Ministry of Agriculture & Farmers Welfare, Govt. of India",
                short_description="Direct income support of ₹6,000 per year in 3 equal installments to eligible farmer families.",
                benefits="₹2,000 every four months directly transferred to Aadhaar-linked bank accounts.",
                eligibility_criteria=[
                    "Small and marginal landholder farmer families.",
                    "Valid Aadhaar card and land ownership records.",
                ],
                required_documents=["Aadhaar Card", "Land Ownership Record (7/12 or RoR)", "Bank Passbook"],
                official_portal_url="https://pmkisan.gov.in",
            ),
            GovernmentSchemeItem(
                scheme_name="Pradhan Mantri Fasal Bima Yojana (PMFBY)",
                category="Crop Insurance",
                administering_body="Ministry of Agriculture & Farmers Welfare",
                short_description="Comprehensive crop insurance cover against non-preventable natural risks.",
                benefits="Uniform maximum premium: 2% for Kharif crops, 1.5% for Rabi crops, 5% for commercial/horticultural crops.",
                eligibility_criteria=[
                    "All farmers including sharecroppers and tenant farmers growing notified crops.",
                ],
                required_documents=["Sowing Certificate", "Land Record", "Aadhaar Card", "Bank Account Details"],
                official_portal_url="https://pmfby.gov.in",
            ),
            GovernmentSchemeItem(
                scheme_name="Pradhan Mantri Krishi Sinchayee Yojana (PMKSY)",
                category="Irrigation & Water Conservation",
                administering_body="Ministry of Jal Shakti / Ministry of Agriculture",
                short_description="'Har Khet Ko Pani' and 'More Crop Per Drop' micro-irrigation subsidies.",
                benefits="Up to 55% subsidy on Drip and Sprinkler irrigation systems for small/marginal farmers.",
                eligibility_criteria=[
                    "Farmers possessing cultivable land with accessible water source.",
                ],
                required_documents=["Land Title", "Electricity Bill / Water Source Proof", "Aadhaar Card"],
                official_portal_url="https://pmksy.gov.in",
            ),
        ]

    async def get_schemes(
        self, filter_params: Optional[SchemeFilterRequest] = None
    ) -> GovernmentSchemeResponse:
        """Fetch and filter matching schemes."""
        schemes = self._schemes_catalog
        if filter_params and filter_params.category:
            schemes = [
                s for s in schemes if filter_params.category.lower() in s.category.lower()
            ]

        return GovernmentSchemeResponse(
            total_schemes=len(schemes),
            schemes=schemes,
        )


scheme_service = SchemeService()
