from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field

from app.auth import require_api_key
from app.config import CALIBRATION_SAMPLES, MINE_MAG_DELTA, MINE_METAL_DELTA
from app.models.schemas import SensorData
from app.services.detection import (
    build_calibration_from_samples,
    detect_mine,
    is_duplicate_mine_event,
    is_mine_detected,
)
from app.state import rover_state, update_state

router = APIRouter(dependencies=[Depends(require_api_key)])


class CalibrateBody(BaseModel):
    """Échantillons optionnels ; sinon utilise le buffer / dernière télémétrie."""
    samples: list[SensorData] = Field(default_factory=list)
    metal_delta: float | None = None
    mag_delta: float | None = None


@router.post("/")
def receive_sensor_data(data: SensorData):
    payload = data.model_dump()
    status = detect_mine(payload)
    previous = rover_state.get("mine_status", "")
    rising_edge = is_mine_detected(status) and not is_mine_detected(previous)

    events = list(rover_state.get("mine_events") or [])
    gps = dict(rover_state.get("gps") or {})
    buffer = list(rover_state.get("calibration_buffer") or [])

    # Buffer pour calibration (échantillons « propres »)
    if not is_mine_detected(status):
        buffer.append(
            {"metal": payload.get("metal", 0), "magnetic_field": payload.get("magnetic_field", 0)}
        )
        buffer = buffer[-max(CALIBRATION_SAMPLES * 2, 16) :]

    recorded = False
    if rising_edge:
        lat = float(gps.get("latitude", 0) or 0)
        lon = float(gps.get("longitude", 0) or 0)
        if not is_duplicate_mine_event(lat, lon, events):
            event = {
                "latitude": lat,
                "longitude": lon,
                "at": datetime.now(timezone.utc).isoformat(),
                "status": status,
                "gps_fix": abs(lat) > 0.0001 or abs(lon) > 0.0001,
            }
            events.append(event)
            events = events[-100:]
            gps["mines"] = int(gps.get("mines", 0) or 0) + 1
            recorded = True

    update_state(
        sensor_data=payload,
        mine_status=status,
        mine_events=events,
        gps=gps or rover_state.get("gps"),
        calibration_buffer=buffer,
    )
    return {
        "message": "Données reçues",
        "mine_status": status,
        "mine_detected": is_mine_detected(status),
        "mine_event_recorded": recorded,
        "calibrated": bool((rover_state.get("calibration") or {}).get("calibrated")),
    }


@router.get("/")
def get_sensor_data():
    cal = rover_state.get("calibration") or {}
    return {
        "sensor_data": rover_state.get("sensor_data") or {},
        "mine_status": rover_state.get("mine_status", "Aucune donnée"),
        "mine_detected": is_mine_detected(
            rover_state.get("mine_status", "Aucune donnée")
        ),
        "calibration": cal,
    }


@router.get("/calibration")
def get_calibration():
    return rover_state.get("calibration") or {"calibrated": False}


@router.post("/calibrate")
def calibrate(body: CalibrateBody | None = None):
    """
    Calibrage terrain : moyenne metal/mag sur zone sans mine.
    Appeler le rover à l'arrêt sur sol « propre », puis POST /sensors/calibrate.
    """
    body = body or CalibrateBody()
    samples: list[dict] = [s.model_dump() for s in body.samples]
    if not samples:
        buf = list(rover_state.get("calibration_buffer") or [])
        samples = buf[-CALIBRATION_SAMPLES:]
    if len(samples) < 3:
        last = rover_state.get("sensor_data")
        if isinstance(last, dict):
            samples = samples + [last] * max(0, 3 - len(samples))
    if len(samples) < 3:
        return {
            "ok": False,
            "error": "Pas assez d'échantillons — laissez tourner la télémétrie puis réessayez",
        }

    cal = build_calibration_from_samples(samples[-CALIBRATION_SAMPLES:])
    if body.metal_delta is not None:
        cal["metal_delta"] = body.metal_delta
    else:
        cal["metal_delta"] = MINE_METAL_DELTA
    if body.mag_delta is not None:
        cal["mag_delta"] = body.mag_delta
    else:
        cal["mag_delta"] = MINE_MAG_DELTA

    update_state(calibration=cal, calibration_buffer=[])
    return {"ok": True, "calibration": cal}


@router.delete("/calibration")
def clear_calibration():
    cal = {
        "calibrated": False,
        "baseline_metal": 0,
        "baseline_magnetic": 0,
        "metal_delta": MINE_METAL_DELTA,
        "mag_delta": MINE_MAG_DELTA,
        "samples": 0,
    }
    update_state(calibration=cal, calibration_buffer=[])
    return {"ok": True, "calibration": cal}
