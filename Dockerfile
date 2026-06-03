# Multi-arch friendly: relies on buildx setting TARGETPLATFORM under the hood.
FROM gcr.io/distroless/python3-debian13

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]
