# AWS Elastic Beanstalk — Key Pointers

## 🧭 What is it?
* Managed PaaS that provisions and orchestrates infrastructure (EC2/ALB/ASG/RDS) for web apps and worker services.
* Supports multiple platforms (Node, Python, Java, .NET, Go, Docker) with built-in deployment and health monitoring.

## 📍 Where is it used?
* Rapidly hosting monoliths or microservices without writing IaC from scratch.
* Web APIs, background workers (via worker environments + SQS), staging/sandboxes for quick iterations.

## ⚙️ How is it used?
* Choose a platform + environment type (Web Server vs Worker) and deploy app code via console/CLI/CI.
* Beanstalk builds the app (or uses provided build), creates load balancer/ASG/EC2, configures logs/health checks.
* Deployments support rolling, rolling with batches, immutable, and blue/green via cloned environments + CNAME swap.

## 🛠️ Configurations to know
* `.ebextensions/` and saved configuration templates for environment settings, packages, files, and commands.
* Capacity & scaling: instance types, min/max/desired capacity, ASG policies, spot integration.
* Networking: VPC subnets, ALB/NLB choice, security groups, HTTPS termination, stickiness, health check paths.
* App settings: environment variables, secrets via Parameter Store/Secrets Manager, logging to CloudWatch, enhanced health.
* Data: optional RDS attachment (lifecycle-tied by default), EFS mounts for shared storage.

## ✅ Pros
* Minimal undifferentiated heavy lifting; fast path to a production-grade stack.
* Built-in scaling, monitoring, and deployment policies with AWS-native integrations.
* Supports zero-downtime patterns (blue/green) and platform updates with managed OS patching.

## ⚠️ Cons
* Less granular control than hand-crafted IaC; opinionated defaults can be limiting for complex topologies.
* Environment updates/provisioning can be slow; drift can occur if manual changes are made to underlying resources.
* Coupling to EB-specific abstractions; advanced customization may push you to raw ECS/EKS/EC2 + IaC instead.
