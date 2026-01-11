import requests

def test_homepage():
    r = requests.get("http://127.0.0.1:5000")

    assert r.status_code == 200
    assert "Microserviciul merge" in r.text

