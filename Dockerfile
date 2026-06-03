# ---- build stage: install deps into a venv ----
# Match the Python minor version of the distroless runtime (debian12 => 3.11),
# otherwise the installed packages won't be importable at runtime.
FROM python:3.11-slim-bookworm AS build-venv

WORKDIR /opt/app
COPY requirements.txt .
RUN python3 -m venv /venv \
 && /venv/bin/pip install --no-cache-dir --upgrade pip \
 && /venv/bin/pip install --no-cache-dir -r requirements.txt

# ---- runtime stage: distroless ----
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Make the venv's site-packages importable by the distroless interpreter.
COPY --from=build-venv /venv/lib/python3.11/site-packages /app/site-packages
ENV PYTHONPATH=/app/site-packages

COPY app.py .

EXPOSE 8080

# The distroless python3 image's ENTRYPOINT is already ["/usr/bin/python3"],
# so we pass ONLY the script/args here — no leading "python3".
CMD ["app.py"]
