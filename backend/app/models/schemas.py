from typing import Literal, Optional

from pydantic import BaseModel, Field


class SensorData(BaseModel):
    temperature: float = 0
    humidity: float = 0
    gas: float = 0
    distance: float = 0
    motion: float = 0
    magnetic_field: float = 0
    metal: float = 0
    ir_detected: bool = False


class GPSData(BaseModel):
    latitude: float = 0
    longitude: float = 0
    angle: int = 0
    obstacles: int = 0
    # None = ne pas écraser le compteur backend
    mines: Optional[int] = None


class MoveCommand(BaseModel):
    direction: Literal["forward", "backward", "left", "right", "stop"] = Field(
        description="Direction de déplacement du rover"
    )
