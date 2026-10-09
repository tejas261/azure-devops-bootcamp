# Lab 01 solutions
| # | Symptom | Cause | Fix |
|---|---|---|---|
| 1 | `pip install` fails: no matching distribution | `gunicorn==99.0.0` doesn't exist | pin a real version (e.g. 22.0.0) or drop it |
| 2 | Connection reset/refused from host | App binds `127.0.0.1` inside the container; only loopback inside the netns | `host="0.0.0.0"` (or run via gunicorn `-b 0.0.0.0:8080`). Also `EXPOSE 8000` is wrong/doc-only: port is 8080. `EXPOSE` publishes nothing |
| 3 | Deps reinstalled on every code change | `COPY . /app` before `pip install` busts the cache | copy `requirements.txt` first, install, then copy source |
| 4 | ~1 GB image | `python:latest` full image + pip cache | `python:3.12-slim`, `--no-cache-dir`, multi-stage |
| 5 | Root user + secrets in image | no `USER`; no `.dockerignore` so `.env` copied | `USER` non-root; `.dockerignore`; secrets via runtime env/secret mounts. Deleting in a later layer leaves it in earlier layers (`docker save` + untar proves it) |
| 6 | `latest` moves under you | unpinned tag | pin minor tag; digest (`@sha256:`) for reproducibility; tag for human-readable updates + Renovate/Dependabot |
Also: `CMD python app.py` is shell form (PID 1 is `sh`, signals not forwarded) -> exec form `["python","app.py"]`.
Final reference: `../sample-app/Dockerfile`.
