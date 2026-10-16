from app.services.geo import gps_fix, haversine_m


def test_haversine_same_point():
    assert haversine_m(12.0, -1.5, 12.0, -1.5) == 0


def test_haversine_known_distance():
    # ~111 km per degree latitude
    d = haversine_m(0, 0, 1, 0)
    assert 110_000 < d < 112_000


def test_gps_fix():
    assert gps_fix(0, 0) is False
    assert gps_fix(12.3, -1.5) is True
