from datetime import datetime, timezone

from fastapi import APIRouter, Depends

from app.auth import require_api_key
from app.models.schemas import GPSData
from app.state import rover_state, update_state

router = APIRouter(dependencies=[Depends(require_api_key)])


@router.post("/")
def update_gps(data: GPSData):
    existing = dict(rover_state.get("gps") or {})
    incoming = data.model_dump(exclude_none=True)

    # Préserver mines si le firmware n'envoie pas le champ
    if "mines" not in incoming:
        incoming["mines"] = int(existing.get("mines", 0) or 0)

    merged = {**existing, **incoming}

    point = {
        "latitude": merged.get("latitude", 0),
        "longitude": merged.get("longitude", 0),
        "at": datetime.now(timezone.utc).isoformat(),
    }
    path = list(rover_state.get("path") or [])
    if (
        not path
        or abs(path[-1]["latitude"] - point["latitude"]) > 1e-6
        or abs(path[-1]["longitude"] - point["longitude"]) > 1e-6
    ):
        path.append(point)
        path = path[-500:]

    update_state(gps=merged, path=path)
    return {"message": "Coordonnées GPS mises à jour", "mines": merged.get("mines", 0)}


@router.get("/")
def get_gps():
    gps = rover_state.get("gps") or GPSData().model_dump(exclude_none=True)
    events = rover_state.get("mine_events") or []
    mines = gps.get("mines")
    if mines is None:
        mines = len(events)
    return {
        **gps,
        "mines": mines,
        "path": rover_state.get("path") or [],
        "mine_events": events,
        "mine_status": rover_state.get("mine_status", "Aucune donnée"),
    }
