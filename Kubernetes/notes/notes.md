# Kubernetes Learning & Deployment Guide

## Table of Contents
1. [Learning Path](#learning-path)
2. [Core Concepts](#core-concepts)
3. [Kubernetes Setup](#kubernetes-setup)
4. [Deploying Code to Kubernetes](#deploying-code-to-kubernetes)
5. [Practical Workflow](#practical-workflow)
6. [Troubleshooting](#troubleshooting)

---

## Learning Path

### Phase 1: Fundamentals (Completed)
- ✓ Difference between Docker and Kubernetes (containerization vs orchestration)
- ✓ Kubernetes vs AWS ECS comparison (open-source vs proprietary)
- ✓ Core concepts: Nodes, Cluster, Control Plane, Worker Nodes
- ✓ Key features: auto-scaling, self-healing, load balancing

### Phase 2: Core Components & Architecture
- Kubernetes architecture and components
- API Server, etcd, Scheduler, Controller Manager
- Worker Node components: kubelet, kube-proxy, container runtime

### Phase 3: Kubernetes Objects & Resources
- Pods: smallest deployable unit
- Deployments: manage replicas and rolling updates
- Services: expose applications and handle networking
- ConfigMaps & Secrets: configuration management
- StatefulSets: for stateful applications

### Phase 4: Networking & Storage
- ClusterIP, NodePort, LoadBalancer services
- Ingress for HTTP/HTTPS routing
- PersistentVolumes (PV) & PersistentVolumeClaims (PVC)
- Storage classes for dynamic provisioning

### Phase 5: Practical Deployment
- Creating and managing deployments
- Deploying the Flask + Node.js application stack
- Service discovery and inter-pod communication
- Monitoring and logging

---

## Core Concepts

### Kubernetes Cluster Architecture
```
┌─────────────────────────────────────────────┐
│      Control Plane (Master)                 │
│  ┌────────────────────────────────────────┐ │
│  │ API Server, etcd, Scheduler,           │ │
│  │ Controller Manager, Cloud Manager      │ │
│  └────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
            ↓        ↓        ↓
┌──────────────────────────────────────────────────────┐
│  Worker Nodes (Container Runtime Nodes)             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐    │
│  │ Node 1     │  │ Node 2     │  │ Node N     │    │
│  │ ┌────────┐ │  │ ┌────────┐ │  │ ┌────────┐ │    │
│  │ │ Pods   │ │  │ │ Pods   │ │  │ │ Pods   │ │    │
│  │ └────────┘ │  │ └────────┘ │  │ └────────┘ │    │
│  │ kubelet    │  │ kubelet    │  │ kubelet    │    │
│  │ kube-proxy │  │ kube-proxy │  │ kube-proxy │    │
│  └────────────┘  └────────────┘  └────────────┘    │
└──────────────────────────────────────────────────────┘
```

### Pod
- Smallest deployable unit in Kubernetes
- Can contain one or more containers (usually one)
- Containers in a pod share network namespace (same IP address)
- Example: Flask backend pod, Node.js frontend pod

### Deployment
- Manages pods through ReplicaSets
- Ensures desired number of replicas are running
- Handles rolling updates and rollbacks
- Declarative: you describe desired state, K8s makes it happen

### Service
- Stable endpoint to access pods
- Types:
  - **ClusterIP**: Internal communication only (default)
  - **NodePort**: Exposes on each node's IP
  - **LoadBalancer**: Cloud provider's load balancer
- Provides DNS name for service discovery

### ConfigMap & Secrets
- **ConfigMap**: Store non-sensitive configuration data
- **Secrets**: Store sensitive data (passwords, API keys, tokens)

---

## Kubernetes Setup

### Prerequisites
- Docker installed and working
- Docker images already built for backend and frontend
- Basic understanding of YAML syntax

### Local Kubernetes Options

#### 1. Docker Desktop (Recommended for Learning)
```bash
# Enable Kubernetes in Docker Desktop
# Settings → Kubernetes → Enable Kubernetes
# Verify installation
kubectl cluster-info
kubectl get nodes
```

#### 2. Minikube (Single-node cluster)
```bash
# Install Minikube
# https://minikube.sigs.k8s.io/docs/start/

# Start cluster
minikube start

# Verify
minikube status
kubectl get nodes
```

#### 3. Kind (Kubernetes in Docker)
```bash
# Install Kind
# https://kind.sigs.k8s.io/docs/user/quick-start/

# Create cluster
kind create cluster --name devops

# Verify
kubectl cluster-info --context kind-devops
```

### kubectl Installation
```bash
# Windows (using Chocolatey)
choco install kubernetes-cli

# Or download from: https://kubernetes.io/docs/tasks/tools/

# Verify
kubectl version --client
```

---

## Deploying Code to Kubernetes

### Step 1: Prepare Docker Images

Ensure your Docker images are available:
```bash
# Build images (from Docker folder)
cd Docker
docker-compose build

# Or build individually
docker build -t myapp/backend:1.0 ./backend
docker build -t myapp/frontend:1.0 ./frontend

# Verify images exist
docker images | grep myapp
```

### Step 2: Make Images Available to Kubernetes

#### Option A: Load local Docker images (for local clusters)
```bash
# For Docker Desktop K8s: images are automatically available
# For Minikube: load the image
minikube image load myapp/backend:1.0
minikube image load myapp/frontend:1.0

# For Kind: load the image
kind load docker-image myapp/backend:1.0 --name devops
kind load docker-image myapp/frontend:1.0 --name devops
```

#### Option B: Push to Container Registry (for cloud)
```bash
# Push to Docker Hub
docker tag myapp/backend:1.0 yourusername/myapp-backend:1.0
docker push yourusername/myapp-backend:1.0

# Or use ECR, GCR, etc.
```

### Step 3: Create Kubernetes Manifests

Create YAML files defining your Kubernetes resources in `Kubernetes/` folder.

#### 3.1 Namespace (Optional but recommended)
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: devops-app
```

#### 3.2 ConfigMap for MongoDB Connection
```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: devops-app
data:
  MONGO_CONNECTION: "mongodb://mongodb:27017"
  DATABASE_NAME: "formdata"
```

#### 3.3 Secret for Sensitive Data
```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: devops-app
type: Opaque
stringData:
  MONGO_USER: "root"
  MONGO_PASSWORD: "password123"
```

#### 3.4 MongoDB Deployment
```yaml
# mongodb-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  namespace: devops-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:5.0
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: MONGO_USER
        - name: MONGO_INITDB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: MONGO_PASSWORD
```

#### 3.5 MongoDB Service
```yaml
# mongodb-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mongodb
  namespace: devops-app
spec:
  selector:
    app: mongodb
  ports:
  - port: 27017
    targetPort: 27017
  type: ClusterIP
```

#### 3.6 Backend Deployment
```yaml
# backend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: devops-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: myapp/backend:1.0
        imagePullPolicy: Never  # For local images; use IfNotPresent for registry
        ports:
        - containerPort: 5000
        env:
        - name: MONGO_CONNECTION
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: MONGO_CONNECTION
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

#### 3.7 Backend Service
```yaml
# backend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: devops-app
spec:
  selector:
    app: backend
  ports:
  - port: 5000
    targetPort: 5000
  type: ClusterIP
```

#### 3.8 Frontend Deployment
```yaml
# frontend-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: devops-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: myapp/frontend:1.0
        imagePullPolicy: Never
        ports:
        - containerPort: 3000
        env:
        - name: BACKEND_URL
          value: "http://backend:5000"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
```

#### 3.9 Frontend Service
```yaml
# frontend-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: devops-app
spec:
  selector:
    app: frontend
  ports:
  - port: 3000
    targetPort: 3000
  type: NodePort  # Expose externally
```

### Step 4: Deploy to Kubernetes

```bash
# Navigate to Kubernetes directory
cd Kubernetes

# Create namespace
kubectl apply -f namespace.yaml

# Create ConfigMap and Secrets
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml

# Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# Deploy Backend
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# Deploy Frontend
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

# Or deploy everything at once
kubectl apply -f .
```

### Step 5: Verify Deployment

```bash
# Check all resources
kubectl get all -n devops-app

# Check pod status
kubectl get pods -n devops-app

# Check services
kubectl get svc -n devops-app

# Check deployments
kubectl get deployments -n devops-app

# Describe a resource (detailed info)
kubectl describe pod <pod-name> -n devops-app
```

### Step 6: Access the Application

#### For Docker Desktop/Local Kubernetes
```bash
# Get the NodePort for frontend
kubectl get svc frontend -n devops-app

# Access application
# http://localhost:<NodePort>
```

#### Forward port to test
```bash
# Forward frontend port
kubectl port-forward svc/frontend 3000:3000 -n devops-app

# Access: http://localhost:3000

# Forward backend port
kubectl port-forward svc/backend 5000:5000 -n devops-app

# Test backend: http://localhost:5000
```

---

## Practical Workflow

### Development Cycle

#### 1. Make code changes
```bash
# Edit application code (backend/app.py or frontend/app.js)
```

#### 2. Rebuild Docker image
```bash
docker build -t myapp/backend:1.1 ./backend
```

#### 3. Load image to Kubernetes
```bash
# For local clusters
minikube image load myapp/backend:1.1
```

#### 4. Update deployment manifest
```yaml
# backend-deployment.yaml
image: myapp/backend:1.1
```

#### 5. Apply changes
```bash
kubectl apply -f backend-deployment.yaml
```

#### 6. Verify rollout
```bash
kubectl rollout status deployment/backend -n devops-app
```

### Scaling
```bash
# Scale backend to 3 replicas
kubectl scale deployment backend --replicas=3 -n devops-app

# Or edit deployment directly
kubectl edit deployment backend -n devops-app
```

### Rolling Updates
```bash
# Update image with rolling strategy
kubectl set image deployment/backend backend=myapp/backend:1.2 -n devops-app

# Monitor rollout
kubectl rollout status deployment/backend -n devops-app

# Rollback if needed
kubectl rollout undo deployment/backend -n devops-app
```

### Viewing Logs
```bash
# Logs from a specific pod
kubectl logs <pod-name> -n devops-app

# Follow logs
kubectl logs -f <pod-name> -n devops-app

# Logs from all pods of a deployment
kubectl logs -l app=backend -n devops-app
```

### Interactive Debugging
```bash
# Shell into a pod
kubectl exec -it <pod-name> -n devops-app -- /bin/bash

# Run a command in a pod
kubectl exec <pod-name> -n devops-app -- python app.py --version
```

---

## Troubleshooting

### Pods not starting
```bash
# Check pod status and events
kubectl describe pod <pod-name> -n devops-app

# Common issues:
# - Image not found: Ensure image is loaded locally
# - CrashLoopBackOff: Application crashed, check logs
# - Pending: Waiting for resources or image pull

# Check logs
kubectl logs <pod-name> -n devops-app
```

### Service connectivity issues
```bash
# Verify service endpoints
kubectl get endpoints -n devops-app

# Test DNS from a pod
kubectl run -it debugging --image=busybox --restart=Never -n devops-app -- sh
# nslookup backend
# wget -O- http://backend:5000
```

### Resource constraints
```bash
# Check node resources
kubectl top nodes
kubectl top pods -n devops-app

# Check resource requests/limits
kubectl describe deployment backend -n devops-app
```

### Common kubectl commands
```bash
# Get resources with detailed info
kubectl get pods -n devops-app -o wide

# Watch resources in real-time
kubectl get pods -n devops-app -w

# Delete resources
kubectl delete pod <pod-name> -n devops-app
kubectl delete deployment backend -n devops-app
kubectl delete namespace devops-app
```

---

## Key Takeaways

1. **Kubernetes manages containers** at scale with automatic orchestration
2. **Declarative approach**: Define desired state in YAML, K8s makes it happen
3. **Services provide stable networking** between microservices
4. **ConfigMaps and Secrets** keep configuration separate from code
5. **Rolling updates and self-healing** ensure high availability
6. **Local development**: Use Docker Desktop, Minikube, or Kind
7. **Cloud deployment**: Push images to registry, update manifests, apply to cloud K8s cluster

---

## Next Steps

- [ ] Set up local Kubernetes (Docker Desktop or Minikube)
- [ ] Create YAML manifests for the devops-app
- [ ] Deploy application stack locally
- [ ] Practice scaling and rolling updates
- [ ] Test self-healing by deleting pods
- [ ] Implement Ingress for better routing
- [ ] Set up persistent storage for MongoDB
- [ ] Deploy to Amazon EKS or GKE
