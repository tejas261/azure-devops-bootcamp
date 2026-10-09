FROM python:3.12-slim AS build
WORKDIR /w
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim
RUN useradd -r -u 10001 appuser
WORKDIR /app
COPY --from=build /install /usr/local
COPY app.py .
ENV PORT=8080
EXPOSE 8080
USER 10001
HEALTHCHECK --interval=30s --timeout=3s CMD python -c "import urllib.request;urllib.request.urlopen('http://127.0.0.1:8080/healthz')"
CMD ["gunicorn", "-b", "0.0.0.0:8080", "-w", "2", "app:app"]
