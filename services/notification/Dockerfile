# services/notification/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --default-timeout=100 --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose container port
EXPOSE 3004

# Start service
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3004"]