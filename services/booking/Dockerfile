# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the source code into the container
COPY . .

# Load env vars at runtime
ENV PYTHONUNBUFFERED=1

# Ensure .env is available in container at /app/.env
# (your code should use python-dotenv to load this)

# Expose the application port (adjust per service)
EXPOSE 3001

# Run Alembic migrations and start the app
CMD ["sh", "-c", "alembic upgrade head && uvicorn main:app --host 0.0.0.0 --port=3001"]