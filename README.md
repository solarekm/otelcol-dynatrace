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

## Manual Workflows

### Multi-Job Workflow (Recommended)

Go to **Actions** → **Build and Deploy OpenTelemetry Collector** → **Run workflow**

**Environment Selection**: Choose DEV or TST environment from dropdown

**Binary artifact is always built** to ensure artifact availability for downstream jobs.

Available options:
- **Deploy to JFrog Artifactory** - Uploads binary archive (uses repository secrets)
- **Build Docker image to ECR** - Creates and pushes Docker image to AWS ECR (uses environment secrets)

### Single Job Workflow (Alternative)

Go to **Actions** → **Build and Deploy OT Collector - Single Job** → **Run workflow**

**Environment Selection**: Choose DEV or TST environment from dropdown

**All operations in one job** for simplified execution and shared filesystem.

Available options:
- **Deploy to JFrog Artifactory** - Separate job using repository secrets
- **Build Docker image to ECR** - Main job using environment secrets

**Differences:**
- ✅ **Single Job**: Shared filesystem, no artifacts needed, simpler dependencies
- ✅ **Multi Job**: Parallel execution, better error isolation, reusable artifacts

## GitHub Environments & Secrets

The repository uses **GitHub Environments** for environment segregation:
- **DEV** - Development environment 
- **TST** - Test environment

### Repository Secrets (Shared)

Configure JFrog secrets at repository level (Settings > Secrets and variables > Actions):

```
JFROG_URL=https://your-company.jfrog.io
JFROG_USERNAME=your-username
JFROG_PASSWORD=your-password
JFROG_REPOSITORY=your-repository
```

### Environment Secrets (DEV/TST Specific)

Configure AWS secrets per environment (Settings > Environments > [DEV/TST] > Secrets):

**DEV Environment:**
```
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=your-dev-secret-key
AWS_DEFAULT_REGION=eu-central-1
AWS_ECR_REGISTRY=123456789012.dkr.ecr.eu-central-1.amazonaws.com
```

**TST Environment:**
```
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=your-tst-secret-key
AWS_DEFAULT_REGION=eu-central-1
AWS_ECR_REGISTRY=123456789012.dkr.ecr.eu-central-1.amazonaws.com
```

## Workflow Usage

Both workflows support **environment selection** via dropdown:
- Select **DEV** or **TST** environment when running manually
- JFrog deployment uses repository secrets (shared)
- AWS deployment uses environment-specific secrets

## Environment Architecture

### JFrog Artifactory (Shared Repository)
- Uses **repository-level secrets** (accessible to all jobs)
- Deploys to environment-specific paths: `/otelcol-dynatrace/{ENV}/{VERSION}/`
- Single JFrog repository serves both DEV and TST environments

### AWS ECR (Environment Segregation)
- Uses **environment-level secrets** (DEV/TST specific)
- Requires environment selection for credential access
- Separate ECR registries for DEV and TST

### Secrets Configuration Summary
- **Repository Secrets**: JFROG_* (shared across environments)
- **Environment Secrets**: AWS_* (DEV/TST specific)
- **Naming Convention**: Consistent hyphen-separated format

## Artifact Naming

Consistent hyphen-separated naming convention:
- **Binary archive**: `otelcol-dynatrace-{env}-{version}-{os}-{arch}.tar.gz`
- **Docker image tag**: `otelcol-dynatrace-{env}-{version}-{os}-{arch}`

Examples:
- **Development**: `otelcol-dynatrace-dev-abc12345-20241230123456-linux-amd64.tar.gz`
- **Tagged release**: `otelcol-dynatrace-tst-v1.2.3-linux-amd64.tar.gz`

JFrog artifact paths: `/otelcol-dynatrace/{ENV}/{VERSION}/linux-amd64/`

## Build Optimization

The workflow is optimized to avoid duplicate OpenTelemetry builds:
- Binary artifact is **always built** to ensure consistency
- Docker build **reuses the binary artifact** when both options are selected
- **Artifacts are automatically removed** after 1 day retention period
- This reduces build time and ensures consistency between binary and Docker outputs
