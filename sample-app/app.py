import os
import random
from flask import Flask, jsonify, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
REQS = Counter("http_requests_total", "Total HTTP requests", ["path", "status"])
LAT = Histogram("http_request_duration_seconds", "Request latency", ["path"])
ERROR_RATE = float(os.getenv("ERROR_RATE", "0"))  # 0.0 - 1.0, used in observability lab


@app.route("/")
def index():
    with LAT.labels("/").time():
        if random.random() < ERROR_RATE:
            REQS.labels("/", "500").inc()
            return jsonify(error="injected failure"), 500
        REQS.labels("/", "200").inc()
        return jsonify(service="orders", version=os.getenv("APP_VERSION", "dev"))


@app.route("/healthz")
def healthz():
    return jsonify(status="ok")


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
