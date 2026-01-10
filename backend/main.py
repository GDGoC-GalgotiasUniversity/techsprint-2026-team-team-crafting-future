import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pymongo import MongoClient
from pymongo.collection import Collection, Mapping

from controllers.login import login, register
from manager import JWTmanager, JWTSettings
from models.ai import AiContext, AiResponse
from models.auth import Ngo, Political, Signin, User


class Mymongo(FastAPI):
    mongodb_client: MongoClient
    collection_users: Collection[Mapping]


logger = logging.getLogger(__name__)
jwt_manager = JWTmanager(JWTSettings())


def debug_log(out, inp=None):
    if inp:
        logger.info(f"In: {inp}, Out: {out}")
    else:
        logger.info(f"Out: {out}")


app = Mymongo()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_URL = "mongodb://localhost:27017/"


@app.on_event("startup")
async def startup_db_client():
    app.mongodb_client = MongoClient(DB_URL)
    app.collection_users = app.mongodb_client["evidex"]["users"]


BASE_API = "/api/v1"


@app.post(f"{BASE_API}/signin")
async def signin(details: Signin):
    payload = login(
        username=details.username,
        password=details.password,
        collection=app.collection_users,
        role=details.role,
    )
    if not payload:
        return {"success": False, "error": "Invalid Credentials"}
    resp = jwt_manager.encode(payload)
    debug_log(inp=details, out=resp)
    return resp


@app.post(f"{BASE_API}/signup")
async def signup(details: Ngo | User | Political):
    payload = register(
        user_data=details.dict(),
        collection=app.collection_users,
        role=details.role,
    )

    if not payload:
        return {"success": False, "error": "User already exists"}
    resp = jwt_manager.encode(payload)
    debug_log(inp=details, out=resp)
    return resp


@app.post(f"{BASE_API}/ai/{{state}}/{{partyno}}")
async def post_ai_state(state: str, partyno: str, data: AiContext):
