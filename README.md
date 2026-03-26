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

### **AWS/**
Cloud infrastructure and EC2 deployment exercises.
- **aws-demo.config** - EC2 key pair management, SSH connections, file transfer setup
- **backend/** & **frontend/** - Containerized apps ready for EC2 deployment
- **docker-compose.yml** - Stack configuration for cloud deployment
- **Key Concepts**: EC2 instances, key pairs, SSH authentication, secure file transfer (SCP), instance configuration

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

1. **Linux Fundamentals** → System basics, CLI proficiency
2. **Python & Bash Scripting** → Automation, task scripting
3. **Web Applications** → Flask + MongoDB standalone setup
4. **Containerization** → Docker, multi-container orchestration
5. **AWS Cloud** → EC2 instances, key pairs, SSH/SCP, instance management
6. **Kubernetes** → Container orchestration at scale
7. **Terraform** → Infrastructure as Code
8. **Jenkins** → CI/CD pipelines
---

## Tech Stack

- **Backend**: Flask (Python)
- **Frontend**: Express.js (Node.js)
- **Database**: MongoDB
- **Container**: Docker & Docker Compose
- **Cloud**: AWS EC2
- **IaC**: Terraform, Jenkins (in progress)

---

## Notes for DevOps Engineers

- Use `.env-example` as template for environment configuration
- All services communicate via `demo-network` bridge
- Volume mounts enable live code reloading during development
- AWS EC2 setup: Manage key pairs securely, use SSH for remote access, SCP for file transfers
- Docker images in AWS/ ready for EC2 deployment
- SSH Configuration: `ssh -i path/to/key.pem ubuntu@ec2-public-ip`
- Service dependencies ensure proper startup order
- Scalable for multi-environment deployments (dev/staging/prod)

---

**Learning Focus**: AWS, Kubernetes, Terraform, Jenkins  
**Last Updated**: March 2026  
**Purpose**: Cloud & DevOps Engineering Learning  
**Status**: Active Learning Repository
