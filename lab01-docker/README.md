# Lab 01 — Docker: debug + harden (local, no cloud cost)
Time: 2-3 h. Prereq: Docker installed.

## Part A — Debug (`broken-app/`)
Symptom list. Don't read the Dockerfile first; run things.
1. `docker build -t orders:bad broken-app/` fails. Fix it. Document how you found the cause.
2. Build succeeds but `docker run -p 8080:8080 orders:bad` and `curl localhost:8080` gets connection reset/refused. Find out why using `docker logs`, `docker exec`, `ss -tlnp` inside the container.
3. Change one line in app.py, rebuild: why does `pip install` run again? Fix the layer order, prove it with build output.
4. `docker history` / `docker images`: image is ~1 GB. Get it under 200 MB.
5. `docker run --rm orders:bad id` — what user? Fix. `docker run --rm orders:bad ls -a /app` — what secret is in the image? Prove it with `docker run ... cat`. Fix, and explain why deleting the file in a later layer isn't enough.
6. Pin the base image properly. Explain tag vs digest and when each matters.

## Part B — Setup
7. Add a `HEALTHCHECK`, run with `--read-only --cap-drop=ALL --security-opt no-new-privileges`. Make the app still work (hint: tmpfs).
8. Write `docker-compose.yml` with the app + a redis container + a named volume; make the app wait for redis properly (healthcheck + `depends_on: condition`).
9. Compare your final Dockerfile with `../sample-app/Dockerfile` only AFTER you finish.

## Deliverables
`fixed-app/` with Dockerfile, `.dockerignore`, 1-page notes: each bug -> symptom -> diagnosis command -> fix.
Incident report: not required here (use the template from Lab 05 onward).

## Interview questions you must answer cold
CMD vs ENTRYPOINT; COPY vs ADD; layer caching; multi-stage; why PID 1 matters (signals/zombies); what `EXPOSE` actually does; image vs container; why `latest` is dangerous; how to reduce attack surface.
