# 🚀 Instafleet Microservices – FastAPI Backends

This directory contains all Python-based FastAPI microservices that power the Instafleet platform. Each service is containerized using Docker and designed to run independently in both local development and cloud environments like AWS ECS.

---

## 🧱 Project Structure

services/
├── auth/           # Handles user authentication and token issuance
├── booking/        # Manages trip bookings and reservations
├── driver/         # Manages driver profiles and availability
├── dispatch/       # Dispatches bookings to available drivers
└── notification/   # Sends out email/SMS/push notifications

Each microservice has:
- `main.py`: FastAPI application entry point
- `Dockerfile`: Build instructions for containerization
- `requirements.txt`: Python dependencies
- `.env`: Environment variables for local development
- `tests/`: Unit and integration tests
- `README.md`: (Optional) service-specific details

---

## ⚙️ Running Services Locally with Docker Compose

To spin up all services together locally:

```bash
cd services
docker-compose up --build

This command:
	•	Builds each service image
	•	Starts them on different ports
	•	Mounts code for hot-reloading (if volumes are configured)

🌐 Services and Default Ports

Auth
Login, register, JWT authentication
3000
http://localhost:3000/docs
Booking
Trip booking and history
3001
http://localhost:3001/docs
Driver
Driver profiles and locations
3002
http://localhost:3002/docs
Dispatch
Match bookings to drivers
3003
http://localhost:3003/docs
Notification
Email and SMS alerts
3004
http://localhost:3004/docs

All services expose their OpenAPI docs at /docs when running.


🧪 Environment Variables
Each service reads configuration from a .env file. Sample:

ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_NAME=instafleet
DB_USERNAME=postgres
DB_PASSWORD=postgres

Make sure to customize .env for each service based on your database and Redis/SQS/DynamoDB setup.

🧪 Testing

Each service may contain tests under the tests/ folder.

Run them using:

# Inside a service folder
pytest

📦 Dependencies

All services rely on:
	•	FastAPI for APIs
	•	Uvicorn as ASGI server
	•	Pydantic for data validation
	•	SQLAlchemy / Tortoise ORM or relevant database connector
	•	Docker for containerization


🔧 Monitoring and Metrics

For local observability, we plan to integrate:
	•	Prometheus for metrics collection
	•	Grafana for dashboards
	•	Custom /metrics endpoints for Prometheus scraping (using prometheus_fastapi_instrumentator)

📬 Messaging and Queues

The Dispatch and Notification services will eventually integrate with AWS SQS using Boto3 or an async-compatible library. For now, local testing may be done using mocks or elasticmq.

🏁 Status

✅ Services scaffolded
✅ Docker support
🔧 Monitoring in progress
🧪 Test coverage pending
🚀 CI/CD with GitHub Actions and Terraform planned

🙌 Contributing
	1.	Fork the repo
	2.	Create a feature branch
	3.	Push changes with meaningful commits
	4.	Open a Pull Request


📂 Related Folders
	•	/infrastructure/: Terraform code for AWS resources
	•	/monitoring/: Prometheus and Grafana configs
	•	/deployment/: GitHub Actions CI/CD workflows
	•	/docs/: Architecture and operational documentation
