import json
from copy import deepcopy
from datetime import datetime, timezone
from threading import Lock
from typing import Any

from app.config import DATA_DIR, STATE_FILE

_lock = Lock()

_DEFAULT_STATE: dict[str, Any] = {
    "sensor_data": None,
    "gps": None,
    "movement": {"direction": "stop"},
    "mine_status": "Aucune donnée",
    "mine_events": [],
    "path": [],
    "last_command_at": None,
    "esp32_last_error": None,
    "auto_mode": False,
    "calibration": {
        "calibrated": False,
        "baseline_metal": 0,
        "baseline_magnetic": 0,
        "metal_delta": 80,
        "mag_delta": 40,
        "samples": 0,
    },
    "coverage": {"phase": "leg", "pattern": "lawnmower"},
    "calibration_buffer": [],
}

rover_state: dict[str, Any] = deepcopy(_DEFAULT_STATE)


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def load_state() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not STATE_FILE.exists():
        return
    try:
        with STATE_FILE.open("r", encoding="utf-8") as f:
            data = json.load(f)
        if isinstance(data, dict):
            with _lock:
                for key in _DEFAULT_STATE:
                    if key in data:
                        rover_state[key] = data[key]
                # Sécurité: jamais redémarrer l'auto tout seul après un reboot
                rover_state["auto_mode"] = False
                rover_state["movement"] = {"direction": "stop"}
    except Exception:
        pass


def save_state() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with _lock:
        payload = deepcopy(rover_state)
    tmp = STATE_FILE.with_suffix(".tmp")
    with tmp.open("w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    tmp.replace(STATE_FILE)


def update_state(**kwargs: Any) -> None:
    with _lock:
        rover_state.update(kwargs)
    save_state()
