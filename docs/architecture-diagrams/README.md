# 🏗️ Instafleet – System Architecture

This folder documents the full system design and cloud architecture of **Instafleet**, a containerized microservices platform.

---

## 📐 Key Architecture Components

| Service               | Purpose                                                             |
|------------------------|----------------------------------------------------------------------|
| **Amazon ECS (Fargate)** | Runs containerized microservices with managed compute                |
| **Application Load Balancer (ALB)** | Distributes traffic across ECS tasks                         |
| **Amazon RDS (PostgreSQL)** | Primary relational database for critical services                 |
| **Amazon DynamoDB**     | NoSQL database used for high-speed notification data               |
| **ElastiCache (Redis)** | In-memory cache for sessions and quick lookups                     |
| **Amazon S3**           | Stores user-uploaded files like receipts, documents, and media     |
| **Amazon SQS**          | Asynchronous communication between microservices                   |
| **Secrets Manager**     | Stores sensitive data like DB credentials securely                 |
| **CloudWatch**          | Collects logs and metrics; manages alarms and alerts               |
| **Prometheus + Grafana** | Local observability stack for development monitoring                |
| **GitHub Actions**      | CI/CD pipeline for automated testing, containerization, and deploy |

---

## 🧱 Microservices Overview

Each service is independently containerized, deployed as a Fargate task:

| Service        | Port | Description                            |
|----------------|------|----------------------------------------|
| Auth           | 3000 | Authentication and user access control |
| Booking        | 3001 | Ride scheduling and management         |
| Driver         | 3002 | Driver profiles and assignments        |
| Dispatch       | 3003 | Vehicle allocation and trip dispatching|
| Notification   | 3004 | Email/SMS notifications and alerts     |

---

## 🌐 Network Design

**Virtual Private Cloud (VPC)** spans multiple Availability Zones with the following structure:

### 🛰️ Public Subnets
- **Application Load Balancer (ALB)**
- **NAT Gateway** (for ECS tasks to access the internet securely)

### 🔐 Private Subnets
- **ECS Tasks** (microservices)
- **RDS (PostgreSQL)**
- **ElastiCache Redis**
- **DynamoDB** access (via VPC endpoint if needed)

> ✅ Ensures all sensitive workloads are isolated from direct internet access.

---

## 🔐 IAM Roles & Policies

| Role                        | Scope                                  |
|-----------------------------|----------------------------------------|
| **ECS Task Execution Role** | Pulls secrets, pushes logs, pulls from ECR |
| **Service Task Roles**      | SQS send/receive, DB connection, etc.  |
| **Secrets Manager Policies**| Grants least privilege DB access        |

---

## 📂 Diagrams

| Diagram File                     | Description                              |
|----------------------------------|------------------------------------------|
| `full-architecture.drawio`       | Complete cloud architecture layout       |
| `ecs-cluster-overview.drawio`    | ECS cluster, services, and containers    |
| `devops-pipeline.drawio`         | CI/CD flow using GitHub Actions & ECR    |

> 🔍 You can open these `.drawio` files with **Draw.io** or import into **Lucidchart**.

---

## 📊 Monitoring & Observability

### ☁️ AWS CloudWatch
- **Logs**: Aggregated from all ECS containers using `awslogs`
- **Metrics**: ECS task CPU/memory, ALB response time, etc.
- **Alarms**: Thresholds for CPU usage, DB availability, queue depth

### 🖥️ Local Monitoring (Dev Only)
- **Prometheus** scrapes service metrics via FastAPI instrumentations
- **Grafana** visualizes metrics (dashboards for each service)

---

## 🚦 CI/CD Flow (GitHub Actions)

1. Push to `development` → Build Docker image
2. Push to `main` → Deploy to ECS via Terraform/ECR
3. Secrets fetched from AWS Secrets Manager
4. Monitoring configured automatically

---

## ☁️ Additional Considerations

- **VPC Endpoints** used for DynamoDB or S3 in private subnets (no NAT cost)
- **S3 Uploads** used by booking/dispatch services for receipt and trip files
- **SQS Queues** help decouple dispatch and notification services
- **Redis** helps cache driver sessions and real-time location state

---

## 🔚 Summary

Instafleet’s architecture is designed to be:
- 🔒 Secure (isolated subnets + IAM least privilege)
- 📦 Modular (independent services with clear boundaries)
- ⚙️ Automated (full CI/CD and observability)
- ☁️ Cloud-native (fully on AWS with modern serverless/Fargate patterns)