from app.models.schemas import GPSData
from app.state import rover_state, update_state
from app.routers import map as map_router


def setup_function():
    update_state(
        gps={"latitude": 1.0, "longitude": 2.0, "angle": 0, "obstacles": 0, "mines": 5},
        path=[],
        mine_events=[],
    )


def test_map_post_without_mines_preserves_counter():
    data = GPSData(latitude=1.1, longitude=2.2, angle=10, obstacles=1, mines=None)
    result = map_router.update_gps(data)
    assert result["mines"] == 5
    assert rover_state["gps"]["mines"] == 5
    assert rover_state["gps"]["latitude"] == 1.1


def test_map_post_with_mines_updates_counter():
    data = GPSData(latitude=1.1, longitude=2.2, angle=10, obstacles=1, mines=9)
    result = map_router.update_gps(data)
    assert result["mines"] == 9
    assert rover_state["gps"]["mines"] == 9
