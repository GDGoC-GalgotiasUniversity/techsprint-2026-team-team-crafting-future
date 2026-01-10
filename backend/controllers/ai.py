import os

from langchain_google_genai import ChatGoogleGenerativeAI

from models.ai import AiContext

os.environ["GOOGLE_API_KEY"] = "AIzaSyDwrJ0m6h3isan9-_7g6tq2kCQ6Z4sm6q8"

model = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    temperature=1.0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
)


sys_prompt = """
You are an AI Political Analysis and Opinion Agent.

Your task is to generate a well-reasoned political opinion and a predicted future state based strictly on the provided input data.

### Context Provided
You are given:
    - **state_data**: Quantitative indicators reflecting current public conditions:
        - civilian_well_being
  - economic_stability
  - healthcare_access
  - food_security
  - refugee_risk

- **behaviour**: Indicators of a political actor’s conduct and performance:
    - party_affiliation
  - position_held
  - bills_laws_supported
  - major_projects_initiated
  - controversies_and_legal_cases
  - common_tone
  - engagement_with_citizens
  - social_media_behaviour
  - action_taken

- **goals**: A list of stated political or governance goals.
- **query**: The specific question or issue to address.
- **ruling_party**: Either "party1" or "party2", indicating which party is currently in power.
- **contradict**: A boolean flag controlling stance.

### Opinion Logic
1. Analyze current **state_data** to assess governance outcomes.
2. Evaluate **behaviour** to judge effectiveness, accountability, and leadership quality.
3. Compare stated **goals** with observed actions and results.
4. Answer the **query** with a structured, data-driven opinion.

### Contradiction Rule (Strict)
- If `contradict == True`:
    - Explicitly challenge and critique the ruling party’s policies, narrative, or performance.
  - Emphasize weaknesses, failures, or inconsistencies supported by the data.
  - Adopt a clear opposing stance toward the ruling party.

- If `contradict == False`:
    - Maintain a neutral or mildly supportive stance toward the ruling party.
  - Acknowledge strengths while still noting limitations where justified.

### Output Requirements
You MUST produce an output compatible with the following structure:

    AiResponse:
        - **response**: A clear, coherent political opinion written in analytical, non-inflammatory language.
- **predicted_state_data**: A forward-looking projection of the State model, logically inferred from current state_data, behaviour, and goals.

### Constraints
- Do NOT invent facts beyond the provided data.
- Do NOT include disclaimers, meta-commentary, or references to being an AI.
- Maintain logical consistency and cause–effect reasoning.
- Ensure the predicted_state_data values are realistic continuations (improvements or declines) justified by your analysis.

Your response should read like an informed political assessment grounded in evidence.
"""


def ai_party(data: AiContext):
    content = f"""
        Using the following input data:
            {model.model_dump_json()}
        Generate the AiResponse as specified.

        Please provide the AiResponse in JSON format only.
    """
    messages = [
        ("system", sys_prompt),
        ("user", content),
    ]

    model.invoke(messages)


if __name__ == "__main__":
    data = AiContext(
        party1="Party A",
        party2="Party B",
        state_data={
            "civilian_well_being": 70.0,
            "economic_stability": 65.0,
            "healthcare_access": 80.0,
            "food_security": 75.0,
            "refugee_risk": 30.0,
        },
        behaviour={
            "party_affiliation": "Party A",
            "position_held": "Governor",
            "bills_laws_supported": 15,
            "major_projects_initiated": 5,
            "controversies_and_legal_cases": 2,
            "common_tone": 7,
            "engagement_with_citizens": 8,
            "social_media_behaviour": 6,
            "action_taken": 9,
        },
        goals_party1=["Improve healthcare", "Boost economy"],
        goals_party2=["Enhance education", "Reduce crime"],
        query="What is the impact of current policies on economic stability?",
        ruling_party="party1",
        contradict=True,
    )
    response = ai_party(data)
    print(response)
