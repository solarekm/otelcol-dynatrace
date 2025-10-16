# OpenTelemetry Collector with Dynatrace Receiver

This repository contains a custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for seamless metrics collection and forwarding.

## 📁 Repository Contents

This repository provides everything needed to build and deploy a custom OpenTelemetry Collector with Dynatrace integration:

- **`builder-config.yaml`** - OpenTelemetry Collector Builder configuration with all required components
- **`collector-config.yaml`** - Ready-to-use collector configuration with Dynatrace receiver
- **`Dockerfile`** - Multi-stage Docker image for containerized deployment
- **`.github/workflows/build-and-deploy.yml`** - Complete CI/CD pipeline for building and distributing binaries

## 🎯 What You Get

- **Dynatrace Receiver**: Native integration with Dynatrace Metrics API v2
- **Linux Binary**: Optimized build for Red Hat Linux VM deployment (AMD64)
- **Docker Images**: Container images for AWS ECS deployment (opt-in to ECR)
- **JFrog Distribution**: Binaries automatically uploaded to JFrog Artifactory
- **Production Ready**: Health checks, monitoring, and observability built-in

## ⚙️ Required Configuration

### GitHub Secrets

Configure these secrets in your GitHub repository (Settings > Secrets and variables > Actions):

#### JFrog Artifactory
```
JFROG_URL=https://your-company.jfrog.io
JFROG_USERNAME=your-jfrog-username
JFROG_PASSWORD=your-jfrog-password
JFROG_REPOSITORY=your-repository-name
```

#### AWS ECR (for Docker deployment)
**Note**: ECR deployment is disabled by default. Enable it manually via workflow_dispatch.

```
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_DEFAULT_REGION=us-east-1
AWS_ECR_REGISTRY=123456789012.dkr.ecr.us-east-1.amazonaws.com
```

### Runtime Environment Variables

These variables must be set when running the collector:

| Variable | Description | Example |
|----------|-------------|---------|
| `DYNATRACE_API_ENDPOINT` | Dynatrace Metrics API endpoint | `https://abc12345.live.dynatrace.com/api/v2/metrics/query` |
| `DYNATRACE_API_TOKEN` | Dynatrace API token | `dt0c01.xxx...` |
| `DEPLOYMENT_ENVIRONMENT` | Environment identifier | `production` |
| `CLUSTER_NAME` | Cluster identifier | `prod-cluster-01` |

### Dynatrace API Token Permissions

Your Dynatrace API token must have these permissions:
- `metrics.read` - Read metrics data
- `entities.read` - Read entities information

Generate the token at: Settings > Integration > Dynatrace API > Generate token

## 🔧 Setup Instructions

### 1. Fork or Clone Repository
```bash
git clone https://github.com/solarekm/otelcol-dynatrace.git
cd otelcol-dynatrace
```

### 2. Configure GitHub Secrets
Add all required secrets listed above in your GitHub repository settings.

### 3. Create Release
Push a tag to trigger the build and deployment pipeline:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### 4. Deploy and Run
The pipeline will automatically:
- Build Linux AMD64 binary
- Upload binary to JFrog Artifactory  
- Create Docker image (if ECR deployment enabled)
- Push image to ECR (if ECR deployment enabled)
- Create GitHub release with artifacts

## 🏃 Quick Start

### Using Docker
```bash
docker run -d \
  --name otelcol-dynatrace \
  -p 8888:8888 \
  -p 13133:13133 \
  -e DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query" \
  -e DYNATRACE_API_TOKEN="your-api-token" \
  -e DEPLOYMENT_ENVIRONMENT="production" \
  -e CLUSTER_NAME="prod-cluster-01" \
  your-ecr-registry/otelcol-dynatrace:latest
```

### Using Binary
```bash
export DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query"
export DYNATRACE_API_TOKEN="your-api-token"
export DEPLOYMENT_ENVIRONMENT="production"
export CLUSTER_NAME="prod-cluster-01"

./otelcol-dynatrace --config=collector-config.yaml
```

### Verify Deployment
```bash
# Check Prometheus metrics
curl http://localhost:8888/metrics

# Check health
curl http://localhost:13133/health
```

## 🔧 Building from Source

### Prerequisites
- Go 1.21+
- Docker (for container builds)

### Build Binary

```bash
# Install OpenTelemetry Collector Builder
curl --proto '=https' --tlsv1.2 -fL -o ocb \
https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.137.0/ocb_0.137.0_linux_amd64
chmod +x ocb

# Build collector
export VERSION=1.0.0
./ocb --config builder-config.yaml
```

### Build Docker Image

```bash
docker build -t otelcol-dynatrace:latest .
```

## 📊 Monitoring & Observability

### Health Checks
- **Health endpoint**: `http://localhost:13133/health`
- **Metrics endpoint**: `http://localhost:8888/metrics`

### Key Metrics
- `otelcol_dynatrace_receiver_accepted_metric_points`
- `otelcol_dynatrace_receiver_refused_metric_points`
- `otelcol_dynatrace_exporter_sent_metric_points`
- `otelcol_process_memory_rss`
- `otelcol_process_cpu_seconds`

## 🚢 Deployment

### Docker Compose

```yaml
version: '3.8'
services:
  otelcol-dynatrace:
    image: your-ecr-registry/otelcol-dynatrace:latest
    ports:
      - "8888:8888"
      - "13133:13133"
    environment:
      - DYNATRACE_API_ENDPOINT=${DYNATRACE_API_ENDPOINT}
      - DYNATRACE_API_TOKEN=${DYNATRACE_API_TOKEN}
      - DEPLOYMENT_ENVIRONMENT=production
      - CLUSTER_NAME=prod-cluster-01
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:13133/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped
```

## 🔒 Security

- **Non-root user**: Container runs as UID 10001
- **Distroless base**: Minimal attack surface
- **Secret management**: Environment variables for sensitive data

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/solarekm/otelcol-dynatrace/issues)
- **Discussions**: [GitHub Discussions](https://github.com/solarekm/otelcol-dynatrace/discussions)