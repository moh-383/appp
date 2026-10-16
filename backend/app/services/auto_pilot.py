import asyncio
import logging
from datetime import datetime, timezone

from app.config import (
    AUTO_AVOID_TICKS,
    AUTO_OBSTACLE_CM,
    AUTO_TICK_SECONDS,
    COVER_LANE_METERS,
    COVER_LANE_TICKS_NO_GPS,
    COVER_LEG_METERS,
    COVER_LEG_TICKS_NO_GPS,
    COVER_TURN_TICKS,
)
from app.services.detection import is_mine_detected
from app.services.esp32_client import send_move
from app.services.geo import gps_fix, haversine_m
from app.state import rover_state, update_state

logger = logging.getLogger("auto_pilot")

# Phases couverture : long → turn → lane → turn → long…
_PHASE_LEG = "leg"
_PHASE_TURN_A = "turn_a"
_PHASE_LANE = "lane"
_PHASE_TURN_B = "turn_b"

_avoid_ticks_left = 0
_avoid_dir = "left"
_phase = _PHASE_LEG
_phase_ticks = 0
_leg_start: tuple[float, float] | None = None
_turn_dir = "left"


def reset_coverage() -> None:
    global _phase, _phase_ticks, _leg_start, _avoid_ticks_left, _turn_dir
    _phase = _PHASE_LEG
    _phase_ticks = 0
    _leg_start = None
    _avoid_ticks_left = 0
    _turn_dir = "left"
    update_state(
        coverage={
            "phase": _phase,
            "pattern": "lawnmower",
            "leg_meters": COVER_LEG_METERS,
            "lane_meters": COVER_LANE_METERS,
        }
    )


def _obstacle_ahead() -> bool:
    gps = rover_state.get("gps") or {}
    if int(gps.get("obstacles", 0) or 0) > 0:
        return True
    sensors = rover_state.get("sensor_data") or {}
    try:
        distance = float(sensors.get("distance", -1))
    except (TypeError, ValueError):
        return False
    return 0 <= distance < AUTO_OBSTACLE_CM


def _current_gps() -> tuple[float, float] | None:
    gps = rover_state.get("gps") or {}
    try:
        lat = float(gps.get("latitude", 0) or 0)
        lon = float(gps.get("longitude", 0) or 0)
    except (TypeError, ValueError):
        return None
    if not gps_fix(lat, lon):
        return None
    return lat, lon


def _distance_from_leg_start() -> float | None:
    if _leg_start is None:
        return None
    cur = _current_gps()
    if cur is None:
        return None
    return haversine_m(_leg_start[0], _leg_start[1], cur[0], cur[1])


async def _cmd(direction: str) -> None:
    await send_move(direction)
    update_state(
        movement={"direction": direction},
        last_command_at=datetime.now(timezone.utc).isoformat(),
        coverage={
            "phase": _phase,
            "pattern": "lawnmower",
            "ticks": _phase_ticks,
            "leg_meters": COVER_LEG_METERS,
            "lane_meters": COVER_LANE_METERS,
        },
    )


def _advance_phase() -> None:
    global _phase, _phase_ticks, _leg_start, _turn_dir
    _phase_ticks = 0
    if _phase == _PHASE_LEG:
        _phase = _PHASE_TURN_A
    elif _phase == _PHASE_TURN_A:
        _phase = _PHASE_LANE
        _leg_start = _current_gps()
    elif _phase == _PHASE_LANE:
        _phase = _PHASE_TURN_B
    else:  # TURN_B → nouveau leg, inverse sens de virage
        _phase = _PHASE_LEG
        _leg_start = _current_gps()
        _turn_dir = "right" if _turn_dir == "left" else "left"


async def _coverage_step() -> None:
    """Lawnmower GPS (mètres) avec fallback temporel sans fix."""
    global _phase_ticks, _leg_start

    if _phase in (_PHASE_LEG, _PHASE_LANE) and _leg_start is None:
        _leg_start = _current_gps()

    if _phase in (_PHASE_TURN_A, _PHASE_TURN_B):
        await _cmd(_turn_dir)
        _phase_ticks += 1
        if _phase_ticks >= COVER_TURN_TICKS:
            _advance_phase()
        return

    # Avance
    await _cmd("forward")
    _phase_ticks += 1
    traveled = _distance_from_leg_start()
    target = COVER_LEG_METERS if _phase == _PHASE_LEG else COVER_LANE_METERS
    ticks_max = (
        COVER_LEG_TICKS_NO_GPS if _phase == _PHASE_LEG else COVER_LANE_TICKS_NO_GPS
    )

    if traveled is not None:
        if traveled >= target:
            _advance_phase()
    elif _phase_ticks >= ticks_max:
        _advance_phase()


async def auto_pilot_loop(stop_event: asyncio.Event) -> None:
    """Auto: couverture lawnmower + évitement + stop mine."""
    global _avoid_ticks_left, _avoid_dir

    while not stop_event.is_set():
        try:
            if rover_state.get("auto_mode"):
                status = rover_state.get("mine_status", "")
                if is_mine_detected(status):
                    logger.info("Mine détectée — arrêt auto")
                    try:
                        await _cmd("stop")
                    except Exception as exc:
                        logger.warning("stop failed: %s", exc)
                    update_state(auto_mode=False)
                    reset_coverage()
                elif _avoid_ticks_left > 0:
                    try:
                        await _cmd(_avoid_dir)
                        _avoid_ticks_left -= 1
                    except Exception as exc:
                        logger.warning("auto avoid failed: %s", exc)
                elif _obstacle_ahead():
                    _avoid_dir = "right" if _avoid_dir == "left" else "left"
                    _avoid_ticks_left = max(1, AUTO_AVOID_TICKS)
                    logger.info("Obstacle — évitement %s", _avoid_dir)
                    try:
                        await _cmd(_avoid_dir)
                        _avoid_ticks_left -= 1
                    except Exception as exc:
                        logger.warning("auto avoid start failed: %s", exc)
                else:
                    try:
                        await _coverage_step()
                    except Exception as exc:
                        logger.warning("coverage step failed: %s", exc)
            else:
                _avoid_ticks_left = 0
        except Exception as exc:
            logger.exception("auto_pilot error: %s", exc)

        try:
            await asyncio.wait_for(stop_event.wait(), timeout=AUTO_TICK_SECONDS)
        except asyncio.TimeoutError:
            pass
