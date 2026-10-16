from app.services import auto_pilot
from app.state import update_state


def test_reset_coverage():
    auto_pilot.reset_coverage()
    assert auto_pilot._phase == auto_pilot._PHASE_LEG
    from app.state import rover_state

    assert rover_state["coverage"]["pattern"] == "lawnmower"


def test_obstacle_still_works():
    update_state(sensor_data={"distance": 10}, gps={"obstacles": 0})
    assert auto_pilot._obstacle_ahead() is True
