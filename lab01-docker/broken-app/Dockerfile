FROM python:latest
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENV PORT=8080
EXPOSE 8000
CMD python app.py
