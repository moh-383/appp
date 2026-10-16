import os
from pathlib import Path

try:
    from dotenv import load_dotenv

    load_dotenv(Path(__file__).resolve().parent.parent / ".env")
except ImportError:
    pass

ESP32_BASE_URL = os.getenv("ESP32_BASE_URL", "http://192.168.100.50").rstrip("/")
ESP32_TIMEOUT = float(os.getenv("ESP32_TIMEOUT", "3.0"))

API_KEY = os.getenv("API_KEY", "rover-secret-key")
ESP32_API_KEY = os.getenv("ESP32_API_KEY", API_KEY)

CORS_ORIGINS = [
    o.strip()
    for o in os.getenv("CORS_ORIGINS", "*").split(",")
    if o.strip()
]

AUTO_TICK_SECONDS = float(os.getenv("AUTO_TICK_SECONDS", "1.0"))
AUTO_OBSTACLE_CM = float(os.getenv("AUTO_OBSTACLE_CM", "25"))
AUTO_AVOID_TICKS = int(os.getenv("AUTO_AVOID_TICKS", "3"))

# Couverture lawnmower (GPS si fix, sinon ticks temps)
COVER_LEG_METERS = float(os.getenv("COVER_LEG_METERS", "8"))
COVER_LANE_METERS = float(os.getenv("COVER_LANE_METERS", "2"))
COVER_TURN_TICKS = int(os.getenv("COVER_TURN_TICKS", "4"))
COVER_LEG_TICKS_NO_GPS = int(os.getenv("COVER_LEG_TICKS_NO_GPS", "12"))
COVER_LANE_TICKS_NO_GPS = int(os.getenv("COVER_LANE_TICKS_NO_GPS", "3"))

# Seuils absolus (fallback si non calibré)
MINE_METAL_THRESHOLD = float(os.getenv("MINE_METAL_THRESHOLD", "300"))
MINE_MAG_THRESHOLD = float(os.getenv("MINE_MAG_THRESHOLD", "100"))
MINE_DISTANCE_MAX_CM = float(os.getenv("MINE_DISTANCE_MAX_CM", "20"))

# Calibration terrain : écarts au-dessus du baseline
MINE_METAL_DELTA = float(os.getenv("MINE_METAL_DELTA", "80"))
MINE_MAG_DELTA = float(os.getenv("MINE_MAG_DELTA", "40"))
CALIBRATION_SAMPLES = int(os.getenv("CALIBRATION_SAMPLES", "8"))
MINE_GPS_DEDUP_METERS = float(os.getenv("MINE_GPS_DEDUP_METERS", "3"))

ENABLE_DOCS = os.getenv("ENABLE_DOCS", "1").strip().lower() in {"1", "true", "yes"}
PUBLIC_HEALTH_MINIMAL = os.getenv("PUBLIC_HEALTH_MINIMAL", "1").strip().lower() in {
    "1",
    "true",
    "yes",
}

DATA_DIR = Path(
    os.getenv("ROVER_DATA_DIR", Path(__file__).resolve().parent.parent / "data")
)
STATE_FILE = DATA_DIR / "rover_state.json"
