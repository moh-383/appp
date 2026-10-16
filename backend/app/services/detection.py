from app.config import (
    MINE_DISTANCE_MAX_CM,
    MINE_GPS_DEDUP_METERS,
    MINE_MAG_DELTA,
    MINE_MAG_THRESHOLD,
    MINE_METAL_DELTA,
    MINE_METAL_THRESHOLD,
)
from app.services.geo import gps_fix, haversine_m
from app.state import rover_state


def _calibration() -> dict:
    return dict(rover_state.get("calibration") or {})


def detect_mine(data: dict, calibration: dict | None = None) -> str:
    """
    Détection calibrée si baseline terrain présent :
      metal > baseline_metal + delta  AND  mag > baseline_mag + delta  AND distance OK
    Sinon seuils absolus (lab).
    distance < 0 = capteur invalide.
    """
    try:
        distance = float(data.get("distance", -1))
    except (TypeError, ValueError):
        distance = -1.0

    if distance < 0 or distance >= MINE_DISTANCE_MAX_CM:
        return "Aucune mine"

    try:
        metal = float(data.get("metal", 0) or 0)
        magnetic = float(data.get("magnetic_field", 0) or 0)
    except (TypeError, ValueError):
        return "Aucune mine"

    cal = calibration if calibration is not None else _calibration()
    if cal.get("calibrated"):
        base_m = float(cal.get("baseline_metal", 0) or 0)
        base_g = float(cal.get("baseline_magnetic", 0) or 0)
        d_m = float(cal.get("metal_delta", MINE_METAL_DELTA))
        d_g = float(cal.get("mag_delta", MINE_MAG_DELTA))
        if metal >= base_m + d_m and magnetic >= base_g + d_g:
            return "Mine détectée"
        return "Aucune mine"

    if metal > MINE_METAL_THRESHOLD and magnetic > MINE_MAG_THRESHOLD:
        return "Mine détectée"
    return "Aucune mine"


def is_mine_detected(status: str | None) -> bool:
    if not status:
        return False
    return status.strip().lower() in {"mine détectée", "mine detected"}


def is_duplicate_mine_event(lat: float, lon: float, events: list) -> bool:
    """Ignore une nouvelle mine trop proche d'un event GPS récent."""
    if not gps_fix(lat, lon):
        return False
    for ev in reversed(events[-20:]):
        elat = float(ev.get("latitude", 0) or 0)
        elon = float(ev.get("longitude", 0) or 0)
        if not gps_fix(elat, elon):
            continue
        if haversine_m(lat, lon, elat, elon) < MINE_GPS_DEDUP_METERS:
            return True
    return False


def build_calibration_from_samples(samples: list[dict]) -> dict:
    metals = [float(s.get("metal", 0) or 0) for s in samples]
    mags = [float(s.get("magnetic_field", 0) or 0) for s in samples]
    n = max(1, len(samples))
    return {
        "calibrated": True,
        "baseline_metal": sum(metals) / n,
        "baseline_magnetic": sum(mags) / n,
        "metal_delta": MINE_METAL_DELTA,
        "mag_delta": MINE_MAG_DELTA,
        "samples": n,
    }
