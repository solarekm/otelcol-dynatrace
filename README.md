# OpenTelemetry Collector with Dynatrace Receiver

Custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for metrics collection and forwarding.

## Repository Contents

- **`builder-config.yaml`** - OpenTelemetry Collector Builder configuration with Dynatrace receiver
- **`collector-config.yaml`** - Runtime collector configuration  
- **`Dockerfile`** - Multi-stage Docker image for containerized deployment
- **`.github/workflows/build-and-deploy.yml`** - Manual workflow for building and deploying

## Quick Start

### Using Binary
```bash
./otelcol-dynatrace --config=collector-config.yaml
```

### Using Docker
```bash
docker run -d \
  -p 8888:8888 -p 13133:13133 -p 4317:4317 -p 4318:4318 \
  your-registry/otelcol-dynatrace:latest
```

## Manual Workflow

Go to **Actions** → **Build and Deploy OpenTelemetry Collector** → **Run workflow**

Available options:
- **Build binary artifact** - Creates Linux AMD64 binary
- **Deploy to JFrog Artifactory** - Uploads binary (requires JFrog secrets)
- **Build Docker image to ECR** - Creates and pushes Docker image (requires AWS secrets)

## GitHub Secrets

Configure in repository Settings > Secrets and variables > Actions:

### JFrog Artifactory (optional)
```
JFROG_URL=https://your-company.jfrog.io
JFROG_USERNAME=your-username
JFROG_PASSWORD=your-password
JFROG_REPOSITORY=your-repository
```

### AWS ECR (optional)
```
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=us-east-1
AWS_ECR_REGISTRY=123456789012.dkr.ecr.us-east-1.amazonaws.com
```

## Monitoring

- **Health**: http://localhost:13133/health
- **Metrics**: http://localhost:8888/metrics

## Artifact Naming

Follows OpenTelemetry naming convention:
- **Binary**: `otelcol-dynatrace_{version}_{os}_{arch}.tar.gz`
- **Docker**: `otelcol-dynatrace_{version}_{os}_{arch}:latest`

Examples:
- `otelcol-dynatrace_1.0.0_linux_amd64.tar.gz`
- `otelcol-dynatrace_dev-abc123-20251016152030_linux_amd64.tar.gz`
