from typing import Dict, List, Literal

from pydantic import BaseModel, Field


class State(BaseModel):
    civilian_well_being: float
    economic_stability: float
    healthcare_access: float
    food_security: float
    refugee_risk: float


class Behaviour(BaseModel):
    party_affiliation: str
    position_held: str
    bills_laws_supported: int
    major_projects_initiated: int
    controversies_and_legal_cases: int
    common_tone: int
    engagement_with_citizens: int
    social_media_behaviour: int
    action_taken: int


class AiContext(BaseModel):
    party1: str
    party2: str
    state_data: State
    behaviour: Behaviour
    goals_party1: List[str]
    goals_party2: List[str]
    query: str
    ruling_party: Literal["party1", "party2"]
    contradict: bool


class AiResponse(BaseModel):
    response: str
    predicted_state_data: State
