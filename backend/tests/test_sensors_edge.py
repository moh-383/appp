from app.routers import sensors as sensors_router
from app.models.schemas import SensorData
from app.state import rover_state, update_state


def _clear():
    update_state(
        sensor_data=None,
        mine_status="Aucune mine",
        mine_events=[],
        gps={"latitude": 12.0, "longitude": -1.5, "angle": 0, "obstacles": 0, "mines": 0},
        auto_mode=False,
    )


def test_mine_counter_increments_once_on_rising_edge():
    _clear()
    payload = SensorData(
        metal=400, magnetic_field=150, distance=10, temperature=25, humidity=40
    )
    r1 = sensors_router.receive_sensor_data(payload)
    assert r1["mine_detected"] is True
    assert r1["mine_event_recorded"] is True
    assert rover_state["gps"]["mines"] == 1
    assert len(rover_state["mine_events"]) == 1

    r2 = sensors_router.receive_sensor_data(payload)
    assert r2["mine_detected"] is True
    assert r2["mine_event_recorded"] is False
    assert rover_state["gps"]["mines"] == 1
    assert len(rover_state["mine_events"]) == 1


def test_mine_counter_increments_again_after_clear():
    _clear()
    hot = SensorData(metal=400, magnetic_field=150, distance=10)
    cold = SensorData(metal=10, magnetic_field=10, distance=80)
    sensors_router.receive_sensor_data(hot)
    sensors_router.receive_sensor_data(cold)
    # Nouvelle position GPS (> dedup 3 m) pour compter une 2e mine
    update_state(
        gps={
            "latitude": 12.01,
            "longitude": -1.5,
            "angle": 0,
            "obstacles": 0,
            "mines": rover_state["gps"]["mines"],
        }
    )
    r = sensors_router.receive_sensor_data(hot)
    assert r["mine_event_recorded"] is True
    assert rover_state["gps"]["mines"] == 2


def test_same_gps_dedup_after_clear():
    _clear()
    hot = SensorData(metal=400, magnetic_field=150, distance=10)
    cold = SensorData(metal=10, magnetic_field=10, distance=80)
    sensors_router.receive_sensor_data(hot)
    sensors_router.receive_sensor_data(cold)
    r = sensors_router.receive_sensor_data(hot)
    assert r["mine_detected"] is True
    assert r["mine_event_recorded"] is False
    assert rover_state["gps"]["mines"] == 1
