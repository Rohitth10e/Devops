# Full-Stack AWS ECS Deployment (Fargate)

A production-ready deployment of a containerized full-stack application (Node.js Frontend & Flask Backend) using AWS ECS Fargate, featuring secure service-to-service communication.

## 🎯 Objective
The goal of this project was to move from a local `docker-compose` environment to a scalable, serverless cloud architecture on AWS, ensuring high availability and secure internal networking.

---

## 🏗️ Architecture Overview

* **Compute:** AWS Fargate (Serverless Container Orchestration)
* **Container Registry:** Amazon ECR (Private Repositories)
* **Database:** MongoDB Atlas (External Cloud-managed Cluster)
* **Networking:** Default VPC with **ECS Service Connect** for internal DNS resolution.
* **Logging:** Amazon CloudWatch for centralized application logs.

---

## 🛠️ Tech Stack
* **Frontend:** Node.js / Express / EJS
* **Backend:** Python / Flask / PyMongo
* **Infrastructure:** AWS (ECS, ECR, IAM, VPC, CloudWatch)
* **Database:** MongoDB Atlas

---

## 🚀 Key Implementation Steps

### 1. Image Orchestration
* Containerized both applications using Docker.
* Created private repositories in **Amazon ECR** (`flask/demo` and `express/demo`).
* Tagged and pushed images using AWS CLI.

### 2. Infrastructure Configuration
* **Task Definitions:** Defined CPU/Memory requirements and configured **Task Execution Roles** to allow ECS to pull images from ECR and stream logs to CloudWatch.
* **Environment Variables:** Injected sensitive connection strings like `MONGO_URI` and internal endpoints like `BACKEND_URL` directly into the task environment.

### 3. Networking & Service Discovery
* **Service Connect:** Enabled Service Connect to provide a stable internal alias (`http://backend:5000`). This replaced the need for hardcoding volatile Public IPs for server-to-server communication.
* **Security Groups:**
    * **Backend:** Inbound TCP 5000 (Restricted to Frontend Security Group).
    * **Frontend:** Inbound TCP 3000 (Open to 0.0.0.0/0 for user access).

---

## 💬 Interview Talking Points

### "Why Fargate?"
> "I opted for Fargate because it's serverless. By removing the need to manage underlying EC2 instances, I could focus entirely on application logic and container management rather than server patching or maintenance."

### "How did you handle Service Discovery?"
> "I implemented ECS Service Connect. In microservices, container IPs are ephemeral. Service Connect provides a managed service discovery layer that allows the frontend to communicate with the backend using a persistent DNS name, mirroring the developer experience of Docker Compose in a cloud-native way."

### "How is the application secured?"
> "Security was implemented at multiple layers: IAM roles were used for least-privilege resource access, and Security Groups acted as a virtual firewall. I ensured the backend was isolated from the public internet by only allowing traffic from the specific security group assigned to the frontend."

---

## 💰 Cost & Resource Management (Mumbai Region)
* **Fargate:** Utilized smallest task sizes (0.25 vCPU) to minimize compute costs.
* **Storage:** Monitored ECR usage to stay within the 500 MB Free Tier limit.
* **IPv4:** Accounted for the ~$0.005/hr charge per public IP.
* **Optimization:** In a production setting, I would use **Fargate Spot** to reduce compute costs by up to 70%.