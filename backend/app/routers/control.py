from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.auth import require_api_key
from app.models.schemas import MoveCommand
from app.services.auto_pilot import reset_coverage
from app.services.detection import is_mine_detected
from app.services.esp32_client import send_move
from app.state import rover_state, update_state

router = APIRouter(dependencies=[Depends(require_api_key)])


class AutoModeBody(BaseModel):
    enabled: bool


@router.post("/")
async def control_rover(cmd: MoveCommand):
    # En mode auto, les commandes manuelles (sauf stop) le désactivent
    if rover_state.get("auto_mode") and cmd.direction != "stop":
        update_state(auto_mode=False)

    esp32 = await send_move(cmd.direction)
    update_state(
        movement=cmd.model_dump(),
        last_command_at=datetime.now(timezone.utc).isoformat(),
    )
    return {
        "message": f"Mouvement: {cmd.direction}",
        "forwarded_to_esp32": True,
        "esp32": esp32,
    }


@router.get("/")
def get_last_command():
    return rover_state.get("movement") or {"direction": "stop"}


@router.post("/auto")
async def set_auto_mode(body: AutoModeBody):
    if body.enabled and is_mine_detected(rover_state.get("mine_status", "")):
        update_state(auto_mode=False)
        return {
            "auto_mode": False,
            "error": "Mine détectée — auto refusé",
        }

    if body.enabled:
        reset_coverage()
    update_state(auto_mode=body.enabled)
    if not body.enabled:
        try:
            await send_move("stop")
        except Exception:
            pass
        update_state(movement={"direction": "stop"})
    return {
        "auto_mode": body.enabled,
        "coverage": rover_state.get("coverage"),
    }


@router.get("/auto")
def get_auto_mode():
    return {
        "auto_mode": bool(rover_state.get("auto_mode")),
        "coverage": rover_state.get("coverage"),
    }
