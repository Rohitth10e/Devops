# DevOps Learning Repository

A hands-on DevOps and Cloud Engineering learning repository. Tracks progression from fundamentals to containerization and cloud deployment.

---

## Directory Structure

### **Docker/**
Multi-tier application containerization with Docker Compose.
- **backend/** - Flask Python API with MongoDB integration
- **frontend/** - Node.js/Express web application  
- **docker-compose.yml** - Orchestrates 3 services: MongoDB, Backend, Frontend on custom network
- **Key Concepts**: Container orchestration, service dependencies, volume mounts, environment variables, networking

### **Flask and mongoDB/**
Standalone Flask web application with MongoDB database.
- Basic CRUD operations with form submission
- Database connectivity and ORM patterns
- **Key Concepts**: Web frameworks, NoSQL databases, template rendering

### **Python and bash/**
Scripting fundamentals and automation exercises.
- **01_app.py to 04_app.py** - Progressive Python scripts (basics to advanced)
- **file.txt** - Data processing exercises
- **Key Concepts**: Automation, scripting, data handling

### **Linux/**
Linux command-line practice materials.
- Command usage, file management, system administration basics
- **Key Concepts**: Linux fundamentals, CLI proficiency, system operations

### **Kubernetes/**
Container orchestration fundamentals and cluster management.
- **notes/Query.md** - Core K8s concepts: differences from Docker, container orchestration principles, K8s vs AWS ECS comparison
- **Key Concepts**: Cluster architecture, nodes, control plane, auto-scaling, self-healing, load balancing, container orchestration

### **AWS/**
Cloud infrastructure: from EC2 to serverless ECS Fargate deployment.
- **aws-demo.config** - EC2 key pair management, SSH connections, file transfer setup
- **backend/** & **frontend/** - Containerized apps (Flask, Node.js) deployed to AWS ECS Fargate
- **docker-compose.yml** - Local docker-compose stack (foundation for cloud deployment)
- **notes/Ecs.md** - Full-stack AWS ECS Fargate deployment guide with Service Connect and MongoDB Atlas
- **Key Concepts**: 
  - **EC2**: Key pairs, SSH authentication, secure file transfer (SCP)
  - **ECS Fargate**: Serverless container orchestration, Task Definitions, IAM Task Execution Roles
  - **ECR**: Private container registries, image management
  - **Service Discovery**: ECS Service Connect for internal DNS resolution between microservices
  - **Networking**: Security Groups, VPC, service-to-service communication
  - **Databases**: MongoDB Atlas for cloud-managed databases
  - **Logging**: CloudWatch for centralized application logs
  - **Cost Optimization**: Fargate Spot instances, resource sizing (0.25 vCPU minimum)

---

## Quick Start

### Prerequisites
- Docker & Docker Compose installed
- Python 3.x
- Node.js & npm

### Run Docker Stack
```bash
cd Docker
cp .env-example .env
# Configure .env with MongoDB credentials
docker-compose up --build
```
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- MongoDB: localhost:27017

### Run Flask App (Standalone)
```bash
cd "Flask and mongoDB"
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r Requirements.txt
python app.py
```

---

## Learning Path

1. **Linux Fundamentals** → System basics, CLI proficiency ✓
2. **Python & Bash Scripting** → Automation, task scripting ✓
3. **Web Applications** → Flask + MongoDB standalone setup ✓
4. **Containerization** → Docker, multi-container orchestration ✓
5. **AWS Cloud - EC2** → Key pairs, SSH/SCP, instance management ✓
6. **AWS Cloud - Fargate** → Serverless container orchestration, ECS, ECR, Service Connect ✓
7. **Kubernetes** → Container orchestration at scale (In Progress)
8. **Terraform** → Infrastructure as Code (planned)
9. **Jenkins** → CI/CD pipelines (planned)
---

## Tech Stack

- **Backend**: Flask (Python)
- **Frontend**: Express.js (Node.js)
- **Database**: MongoDB (local), MongoDB Atlas (cloud)
- **Container**: Docker & Docker Compose
- **Cloud**: AWS (ECS Fargate, ECR, IAM, VPC, CloudWatch, Security Groups)
- **Service Discovery**: ECS Service Connect
- **IaC**: Terraform, Jenkins (planned)

---

## Notes for DevOps Engineers

- Use `.env-example` as template for environment configuration
- All services communicate via `demo-network` bridge
- Volume mounts enable live code reloading during development
- AWS EC2 setup: Manage key pairs securely, use SSH for remote access, SCP for file transfers

---

## AWS ECS Fargate - Key Learnings

### Architecture Decision
- **Why Fargate?** Serverless approach eliminates EC2 instance management. Focus on applications, not infrastructure patching/maintenance.

### Service Discovery
- **ECS Service Connect** provides stable internal DNS resolution (e.g., `http://backend:5000`) for service-to-service communication
- Replaces hardcoded volatile IPs and mimics Docker Compose networking in the cloud

### Security Implementation
- **IAM Task Execution Roles** - Least privilege access for ECR pulls and CloudWatch logging
- **Security Groups** - Firewall rules restrict backend (TCP 5000) to frontend traffic only
- **Network Isolation** - Backend not exposed to public internet

### Database Management
- **MongoDB Atlas** - Cloud-managed database reduces operational overhead
- Connection strings injected via task environment variables

### Cost Optimization (Mumbai Region)
- Use smallest Fargate task sizes (0.25 vCPU) to minimize compute costs
- **Fargate Spot** instances can reduce costs by up to 70% for non-critical workloads
- Monitor ECR storage usage to stay within free tier limits (~500 MB)
- Account for Public IP charges (~$0.005/hr per IP)
- SSH Configuration: `ssh -i path/to/key.pem ubuntu@ec2-public-ip`
- Service dependencies ensure proper startup order
- Scalable for multi-environment deployments (dev/staging/prod)

---

**Learning Focus**: AWS, Kubernetes, Terraform, Jenkins  
**Last Updated**: March 2026  
**Purpose**: Cloud & DevOps Engineering Learning  
**Status**: Active Learning Repository
