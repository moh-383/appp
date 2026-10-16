from app.services.detection import (
    build_calibration_from_samples,
    detect_mine,
    is_duplicate_mine_event,
    is_mine_detected,
)


def test_no_mine_by_default():
    assert detect_mine({}, calibration={"calibrated": False}) == "Aucune mine"


def test_invalid_distance_no_mine():
    assert (
        detect_mine(
            {"metal": 400, "magnetic_field": 150, "distance": -1},
            calibration={"calibrated": False},
        )
        == "Aucune mine"
    )


def test_mine_when_absolute_thresholds_met():
    status = detect_mine(
        {"metal": 400, "magnetic_field": 150, "distance": 10},
        calibration={"calibrated": False},
    )
    assert status == "Mine détectée"
    assert is_mine_detected(status)


def test_calibrated_detection_uses_baseline_delta():
    cal = {
        "calibrated": True,
        "baseline_metal": 200,
        "baseline_magnetic": 50,
        "metal_delta": 80,
        "mag_delta": 40,
    }
    # Just above baseline but below absolute-looking values
    assert (
        detect_mine(
            {"metal": 290, "magnetic_field": 95, "distance": 12},
            calibration=cal,
        )
        == "Mine détectée"
    )
    assert (
        detect_mine(
            {"metal": 250, "magnetic_field": 70, "distance": 12},
            calibration=cal,
        )
        == "Aucune mine"
    )


def test_build_calibration_from_samples():
    cal = build_calibration_from_samples(
        [
            {"metal": 100, "magnetic_field": 40},
            {"metal": 120, "magnetic_field": 60},
        ]
    )
    assert cal["calibrated"] is True
    assert cal["baseline_metal"] == 110
    assert cal["baseline_magnetic"] == 50


def test_gps_dedup():
    events = [{"latitude": 12.0, "longitude": -1.5}]
    assert is_duplicate_mine_event(12.00001, -1.50001, events) is True
    assert is_duplicate_mine_event(12.1, -1.5, events) is False


def test_is_mine_detected_variants():
    assert is_mine_detected("Mine détectée")
    assert is_mine_detected("MINE DETECTED")
    assert not is_mine_detected("Aucune mine")
