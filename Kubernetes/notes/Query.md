# Kubernetes Learning Questions

## 1. How is Kubernetes Different from Docker?

### Docker (Containerization)
Docker is a platform and toolset used to build and package your application (like a Spring Boot or Go backend) along with all its dependencies into a single, standardized unit called a **container**. It ensures that if the app runs on your laptop, it will run exactly the same way on a server.

### Kubernetes (Container Orchestration)
Once you have dozens or hundreds of Docker containers running, managing them manually becomes a nightmare. **Kubernetes (K8s)** is the system that manages those containers.

#### What K8s Does That Docker Doesn't:
- **Auto-scaling**: If traffic spikes, K8s automatically spins up more containers. When traffic drops, it kills them to save resources.
- **Self-healing**: If a container crashes or a server goes down, K8s detects it and automatically restarts or reschedules the container on a healthy machine.
- **Load Balancing**: K8s distributes incoming network traffic efficiently across your containers so no single one gets overwhelmed.

> **Pro-Tip for Interviews**: Kubernetes actually stopped using Docker as its underlying "engine" to run containers a few years ago (they switched to a lighter runtime called `containerd`). However, you still use Docker on your machine to build the container images, which Kubernetes then runs.

## 2. What's the Difference Between K8s Cluster/Node and AWS-ECS?

### K8s Anatomy

- **Node**: A single machine (could be a physical server or a virtual machine like an AWS EC2 instance). It provides the CPU and RAM needed to run your containers.
- **Cluster**: A group of Nodes tied together. A cluster consists of:
  - **Worker Nodes**: Where your apps actually run
  - **Control Plane**: The master brain that manages the workers and decides where containers should go

### AWS ECS (Elastic Container Service)

ECS is Amazon's own proprietary version of a container orchestrator. It solves the exact same problem as Kubernetes (managing containers at scale), but it goes about it differently.

### Comparison

| Feature | Kubernetes (K8s) | AWS ECS |
|---------|------------------|---------|
| **Origin / Lock-in** | Open-source. Cloud-agnostic. You can run it on AWS, GCP, Azure, or your own metal servers. | Proprietary to AWS. You are locked into the AWS ecosystem. |
| **Complexity** | High. Steep learning curve with its own concepts (Pods, Deployments, Ingress). | Low to Medium. Much simpler to set up using standard AWS concepts. |
| **Integration** | Requires configuration to talk to cloud services, though managed versions like Amazon EKS make this easier. | Native, seamless integration with AWS services like IAM, Application Load Balancers (ALB), and CloudWatch. |
| **Extensibility** | Extremely high. Massive open-source ecosystem of plugins and tools. | Limited to what AWS supports and provides. |
