import asyncio
import logging
import secrets
from contextlib import asynccontextmanager

from typing import Optional

from fastapi import Depends, FastAPI, Header, Request, Response
from fastapi.middleware.cors import CORSMiddleware

from app.auth import require_api_key
from app.config import API_KEY, CORS_ORIGINS, ENABLE_DOCS, ESP32_BASE_URL, PUBLIC_HEALTH_MINIMAL
from app.routers import arm, control, map as map_router, sensors
from app.services.auto_pilot import auto_pilot_loop
from app.services.esp32_client import ping_esp32, send_move
from app.state import load_state, rover_state, save_state, update_state

logger = logging.getLogger("rover")


@asynccontextmanager
async def lifespan(_: FastAPI):
    load_state()
    # Double filet: auto toujours off au démarrage + stop moteurs si ESP joignable
    update_state(auto_mode=False, movement={"direction": "stop"})
    try:
        await send_move("stop")
    except Exception:
        pass
    if API_KEY == "rover-secret-key":
        logger.warning(
            "API_KEY est encore la valeur par défaut — changez-la pour la prod"
        )
    stop_event = asyncio.Event()
    task = asyncio.create_task(auto_pilot_loop(stop_event))
    yield
    stop_event.set()
    await task
    try:
        await send_move("stop")
    except Exception:
        pass
    save_state()


_docs = "/docs" if ENABLE_DOCS else None
_redoc = "/redoc" if ENABLE_DOCS else None
_openapi = "/openapi.json" if ENABLE_DOCS else None

app = FastAPI(
    title="Rover Backend",
    description="API de contrôle et de télémétrie pour le rover détecteur de mines",
    version="1.5.0",
    lifespan=lifespan,
    docs_url=_docs,
    redoc_url=_redoc,
    openapi_url=_openapi,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS if CORS_ORIGINS != ["*"] else ["*"],
    allow_credentials=False,
    allow_methods=["GET", "POST", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)


@app.middleware("http")
async def security_headers(request: Request, call_next):
    response: Response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Referrer-Policy"] = "no-referrer"
    response.headers["Cache-Control"] = "no-store"
    return response


app.include_router(sensors.router, prefix="/sensors", tags=["sensors"])
app.include_router(map_router.router, prefix="/map", tags=["map"])
app.include_router(control.router, prefix="/control", tags=["control"])
app.include_router(arm.router, prefix="/arm", tags=["arm"])


@app.get("/")
def read_root():
    return {
        "message": "Bienvenue sur le backend du Rover",
        "auth_required": bool(API_KEY),
        "version": "1.5.0",
    }


@app.get("/health")
async def health(x_api_key: Optional[str] = Header(default=None)):
    """Public: statut minimal. Avec X-API-Key valide: détails opérationnels."""
    authorized = bool(API_KEY) and x_api_key is not None and secrets.compare_digest(
        x_api_key, API_KEY
    )
    if PUBLIC_HEALTH_MINIMAL and not authorized:
        return {"backend": "ok", "auth_required": bool(API_KEY)}

    esp32 = await ping_esp32()
    return {
        "backend": "ok",
        "esp32_base_url": ESP32_BASE_URL,
        "auth_required": bool(API_KEY),
        "esp32": esp32,
        "last_movement": rover_state.get("movement"),
        "mine_status": rover_state.get("mine_status"),
        "auto_mode": rover_state.get("auto_mode"),
        "esp32_last_error": rover_state.get("esp32_last_error"),
    }


@app.get("/health/full", dependencies=[Depends(require_api_key)])
async def health_full():
    esp32 = await ping_esp32()
    return {
        "backend": "ok",
        "esp32_base_url": ESP32_BASE_URL,
        "auth_required": bool(API_KEY),
        "esp32": esp32,
        "last_movement": rover_state.get("movement"),
        "mine_status": rover_state.get("mine_status"),
        "auto_mode": rover_state.get("auto_mode"),
        "esp32_last_error": rover_state.get("esp32_last_error"),
    }
