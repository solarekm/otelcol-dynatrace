# OpenTelemetry Collector with Dynatrace Receiver

Custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for metrics collection and forwarding.

## Repository Contents

- **`builder-config.yaml`** - OpenTelemetry Collector Builder configuration with Dynatrace receiver
- **`collector-config.yaml`** - Runtime collector configuration with Dynatrace receiver setup
- **`Dockerfile`** - Multi-stage Docker image for containerized deployment
- **`.github/workflows/build-and-deploy.yml`** - Manual workflow for building and deploying

## Configuration

Before running the collector, update `collector-config.yaml` with your Dynatrace credentials:

```yaml
receivers:
  dynatracereceiver:
    endpoint: "https://your-dynatrace-tenant.live.dynatrace.com"
    api_token: "your-api-token"
```

## Quick Start

### Using Binary
```bash
# Download from GitHub Actions artifacts or build using workflow
./otelcol-dynatrace --config=collector-config.yaml
```

### Using Docker
```bash
docker run -d \
  -p 8888:8888 -p 13133:13133 -p 4317:4317 -p 4318:4318 \
  -v $(pwd)/collector-config.yaml:/etc/otelcol/config.yaml \
  {ecr-registry}:otelcol-dynatrace_{version}_linux_amd64
```

## Manual Workflow

Go to **Actions** → **Build and Deploy OpenTelemetry Collector** → **Run workflow**

**Binary artifact is always built** to ensure artifact availability for downstream jobs.

Available options:
- **Deploy to JFrog Artifactory** - Uploads binary archive (requires JFrog secrets)
- **Build Docker image to ECR** - Creates and pushes Docker image to AWS ECR (requires AWS secrets)

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
AWS_DEFAULT_REGION=eu-central-1
AWS_ECR_REGISTRY=123456789012.dkr.ecr.eu-central-1.amazonaws.com
```

## Artifact Naming

Follows OpenTelemetry naming convention:
- **Binary archive**: `otelcol-dynatrace_{version}_{os}_{arch}.tar.gz`
- **Docker image tag**: `otelcol-dynatrace_{version}_{os}_{arch}`

Examples:
- **Binary archive**: `otelcol-dynatrace_dev-e85090ec-20251016172801_linux_amd64.tar.gz`
- **Docker image tag**: `otelcol-dynatrace_dev-e85090ec-20251016172801_linux_amd64`

## Build Optimization

The workflow is optimized to avoid duplicate OpenTelemetry builds:
- Binary artifact is **always built** to ensure consistency
- Docker build **reuses the binary artifact** when both options are selected
- **Artifacts are automatically removed** after 1 day retention period
- This reduces build time and ensures consistency between binary and Docker outputs
