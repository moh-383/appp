from app.services import auto_pilot
from app.state import update_state


def test_obstacle_ahead_from_distance():
    update_state(sensor_data={"distance": 10}, gps={"obstacles": 0})
    assert auto_pilot._obstacle_ahead() is True


def test_obstacle_ahead_from_gps_flag():
    update_state(sensor_data={"distance": 80}, gps={"obstacles": 1})
    assert auto_pilot._obstacle_ahead() is True


def test_no_obstacle():
    update_state(sensor_data={"distance": 80}, gps={"obstacles": 0})
    assert auto_pilot._obstacle_ahead() is False


def test_invalid_distance_not_obstacle():
    update_state(sensor_data={"distance": -1}, gps={"obstacles": 0})
    assert auto_pilot._obstacle_ahead() is False
