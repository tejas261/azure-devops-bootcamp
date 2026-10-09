from app import app


def test_index():
    r = app.test_client().get("/")
    assert r.status_code == 200
    assert r.get_json()["service"] == "orders"


def test_health():
    assert app.test_client().get("/healthz").status_code == 200
