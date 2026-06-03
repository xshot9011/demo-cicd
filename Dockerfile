FROM python:3.13-slim-bookworm AS build-venv

WORKDIR /opt/app/
ADD requirements.txt /opt/app/
RUN python3 -m venv /venv
RUN /venv/bin/pip install -r /opt/app/requirements.txt

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
COPY --from=build-venv /venv /venv
COPY app.py .
EXPOSE 8080

CMD ["python", "app.py"]
