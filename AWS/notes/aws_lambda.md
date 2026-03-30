# AWS Lambda — Key Pointers

## 🧭 What is it?
* Event-driven serverless compute that runs functions without managing servers; scales per-request and bills per ms.
* Supports multiple runtimes (Node, Python, Java, .NET, Go, custom container images) with managed execution environment.

## 📍 Where is it used?
* API backends (via API Gateway/ALB), webhooks, and lightweight microservices.
* Event processing for S3 uploads, DynamoDB streams, SNS/SQS/EventBridge messages, and scheduled jobs (EventBridge Cron).
* Data transformation/ETL, glue code across AWS services, and automation hooks in CI/CD or Ops workflows.

## ⚙️ How is it used?
* Package code (zip or container image), set handler/runtime, and attach an execution role; configure triggers/events.
* Lambda handles provisioning, scaling, retries, and metrics/logging (CloudWatch Logs/X-Ray); supports aliases for safe deployments.
* Deployment patterns: canary/linear/all-at-once via CodeDeploy; versions + aliases enable weighted traffic shifting.

## 🛠️ Configurations to know
* Resources: memory (drives CPU/IO), ephemeral storage (/tmp, up to 10 GB), timeout (up to 15 min), reserved/provisioned concurrency.
* Networking: VPC subnets + security groups when accessing private resources; ALB/API Gateway integration options.
* Packaging: layers for shared deps, container images (up to 10 GB), env vars + secrets from Parameter Store/Secrets Manager.
* Reliability: retries on async invokes, DLQs/SNS/SQS for failed events, idempotency keys, partial batch response for streams.
* Observability: structured logs to CloudWatch, X-Ray tracing, CloudWatch metrics; Lambda Telemetry API/Extensions.

## ✅ Pros
* No server management, automatic scaling, pay-per-use with fine-grained billing.
* Fast to iterate and integrate with AWS services; supports blue/green via versions/aliases/CodeDeploy.
* Good for spiky or unpredictable workloads; concurrency controls help with downstream protection.

## ⚠️ Cons
* Cold starts (esp. with VPC, large packages, or non-ARM/Java) can add latency; mitigated with provisioned concurrency.
* Execution limits (15-minute max, memory cap, stateless model) and ephemeral storage model may not fit all workloads.
* Debugging and local parity can be harder; vendor/platform coupling and service quotas must be managed.
