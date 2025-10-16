# OpenTelemetry Collector with Dynatrace Receiver# OpenTelemetry Collector with Dynatrace Receiver# OpenTelemetry Collector with Dynatrace Receiver# OpenTelemetry Collector with Dynatrace Receiver



Custom OpenTelemetry Collector distribution with integrated Dynatrace receiver.



## Quick StartCustom OpenTelemetry Collector distribution with Dynatrace receiver integration.



### Using Binary

```bash

export DEPLOYMENT_ENVIRONMENT="production"## FeaturesA custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for seamless observability data collection and forwarding.This repository contains a custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for seamless metrics collection and forwarding.

export CLUSTER_NAME="prod-cluster-01"

./otelcol-dynatrace --config=collector-config.yaml

```

- Dynatrace receiver for metrics collection

### Using Docker

```bash- Manual workflow with independent build options  

docker run -d \

  -p 8888:8888 -p 13133:13133 -p 4317:4317 -p 4318:4318 \- Binary and Docker image builds## 🎯 Features## 📁 Repository Contents

  -e DEPLOYMENT_ENVIRONMENT="production" \

  -e CLUSTER_NAME="prod-cluster-01" \- Health monitoring and Prometheus metrics

  your-registry/otelcol-dynatrace:latest

```



## Manual Workflow## Quick Start



Go to **Actions** → **Build and Deploy OpenTelemetry Collector** → **Run workflow**- **Dynatrace Integration**: Native Dynatrace receiver for metrics collectionThis repository provides everything needed to build and deploy a custom OpenTelemetry Collector with Dynatrace integration:



Options:### Docker

- Build binary artifact (creates Linux AMD64 binary)

- Deploy to JFrog Artifactory (optional - requires secrets)```bash- **Manual Deployment Control**: Flexible workflow with independent build options

- Build Docker image to ECR (optional - requires secrets)

docker run -d \

## Required Environment Variables

  --name otelcol-dynatrace \- **Multiple Distribution Formats**: Binary artifacts, Docker images, JFrog uploads- **`builder-config.yaml`** - OpenTelemetry Collector Builder configuration with all required components

| Variable | Description | Example |

|----------|-------------|---------|  -p 8888:8888 \

| `DEPLOYMENT_ENVIRONMENT` | Environment name | `production` |

| `CLUSTER_NAME` | Cluster name | `prod-cluster-01` |  -p 13133:13133 \- **Production Ready**: Health checks, monitoring, and enterprise-grade configuration- **`collector-config.yaml`** - Ready-to-use collector configuration with Dynatrace receiver



## Optional Secrets (for workflow)  -e DEPLOYMENT_ENVIRONMENT="production" \



### JFrog (for binary upload)  -e CLUSTER_NAME="prod-cluster-01" \- **Official Naming Convention**: Follows OpenTelemetry community standards- **`Dockerfile`** - Multi-stage Docker image for containerized deployment

- `JFROG_URL`

- `JFROG_USERNAME`   your-registry/otelcol-dynatrace:latest

- `JFROG_PASSWORD`

- `JFROG_REPOSITORY````- **`.github/workflows/build-and-deploy.yml`** - Complete CI/CD pipeline for building and distributing binaries



### AWS ECR (for Docker push)

- `AWS_ACCESS_KEY_ID`

- `AWS_SECRET_ACCESS_KEY`### Binary## 🚀 Quick Start

- `AWS_DEFAULT_REGION`

- `AWS_ECR_REGISTRY````bash



## Monitoringexport DEPLOYMENT_ENVIRONMENT="production"## 🎯 What You Get



- Health: `http://localhost:13133/health`export CLUSTER_NAME="prod-cluster-01"

- Metrics: `http://localhost:8888/metrics`

./otelcol-dynatrace --config=collector-config.yaml### Using Docker

## Building

```

```bash

# Download OCB- **Dynatrace Receiver**: Native integration with Dynatrace Metrics API v2

curl -fL -o ocb https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.137.0/ocb_0.137.0_linux_amd64

chmod +x ocb## Manual Workflow



# Build```bash- **Linux Binary**: Optimized build for Red Hat Linux VM deployment (AMD64)

export VERSION=1.0.0

./ocb --config builder-config.yamlGo to **Actions** → **Build and Deploy OpenTelemetry Collector** → **Run workflow**

```

docker run -d \- **Docker Images**: Container images for AWS ECS deployment (opt-in to ECR)

## License

Options:

MIT
- ✅ Build binary artifact (always available)  --name otelcol-dynatrace \- **JFrog Distribution**: Binaries automatically uploaded to JFrog Artifactory

- ☐ Deploy to JFrog Artifactory (requires secrets)

- ☐ Build Docker image (requires secrets)  -p 8888:8888 \- **Production Ready**: Health checks, monitoring, and observability built-in



## Configuration  -p 13133:13133 \



### Required Environment Variables  -p 4317:4317 \## ⚙️ Required Configuration

- `DEPLOYMENT_ENVIRONMENT` - Environment name

- `CLUSTER_NAME` - Cluster identifier    -p 4318:4318 \



### Optional Secrets (GitHub)  -e DEPLOYMENT_ENVIRONMENT="production" \### GitHub Secrets

Only needed if using JFrog/ECR deployment:

  -e CLUSTER_NAME="prod-cluster-01" \

**JFrog Artifactory:**

- `JFROG_URL`  your-registry/otelcol-dynatrace_dev-latest_linux_amd64:latestConfigure these secrets in your GitHub repository (Settings > Secrets and variables > Actions):

- `JFROG_USERNAME` 

- `JFROG_PASSWORD````

- `JFROG_REPOSITORY`

#### JFrog Artifactory

**AWS ECR:**

- `AWS_ACCESS_KEY_ID`### Using Binary```

- `AWS_SECRET_ACCESS_KEY` 

- `AWS_DEFAULT_REGION`JFROG_URL=https://your-company.jfrog.io

- `AWS_ECR_REGISTRY`

```bashJFROG_USERNAME=your-jfrog-username

## Monitoring

# Download from GitHub Releases or build manuallyJFROG_PASSWORD=your-jfrog-password

- Health: `http://localhost:13133/health`

- Metrics: `http://localhost:8888/metrics`export DEPLOYMENT_ENVIRONMENT="production"JFROG_REPOSITORY=your-repository-name



## Buildingexport CLUSTER_NAME="prod-cluster-01"```



```bash

# Install OCB

curl -fL -o ocb https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.137.0/ocb_0.137.0_linux_amd64./otelcol-dynatrace --config=collector-config.yaml#### AWS ECR (for Docker deployment)

chmod +x ocb

```**Note**: ECR deployment is disabled by default. Enable it manually via workflow_dispatch.

# Build

export VERSION=1.0.0  

./ocb --config builder-config.yaml

```### Verify Deployment```



## LicenseAWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX



MIT - see [LICENSE](LICENSE)```bashAWS_SECRET_ACCESS_KEY=your-secret-access-key

# Health checkAWS_DEFAULT_REGION=us-east-1

curl http://localhost:13133/healthAWS_ECR_REGISTRY=123456789012.dkr.ecr.us-east-1.amazonaws.com

```

# Prometheus metrics

curl http://localhost:8888/metrics### Runtime Environment Variables



# Service infoThese variables must be set when running the collector:

curl http://localhost:13133/

```| Variable | Description | Example |

|----------|-------------|---------|

## ⚙️ Manual Workflow Control| `DYNATRACE_API_ENDPOINT` | Dynatrace Metrics API endpoint | `https://abc12345.live.dynatrace.com/api/v2/metrics/query` |

| `DYNATRACE_API_TOKEN` | Dynatrace API token | `dt0c01.xxx...` |

This repository uses a manual workflow with independent options:| `DEPLOYMENT_ENVIRONMENT` | Environment identifier | `production` |

| `CLUSTER_NAME` | Cluster identifier | `prod-cluster-01` |

### Available Options

### Dynatrace API Token Permissions

1. **Setup** - Always runs (generates build variables)

2. **Build Binary** - Creates Linux AMD64 binary artifact Your Dynatrace API token must have these permissions:

3. **Deploy to JFrog** - Uploads binary to JFrog Artifactory (optional)- `metrics.read` - Read metrics data

4. **Build Docker** - Creates and pushes Docker image to ECR (optional)- `entities.read` - Read entities information



### Trigger BuildGenerate the token at: Settings > Integration > Dynatrace API > Generate token



1. Go to **Actions** → **Build and Deploy OpenTelemetry Collector**## 🔧 Setup Instructions

2. Click **Run workflow**

3. Select desired options:### 1. Fork or Clone Repository

   - ✅ Build binary artifact```bash

   - ☐ Deploy binary to JFrog Artifactory  git clone https://github.com/solarekm/otelcol-dynatrace.git

   - ☐ Build and push Docker image to ECRcd otelcol-dynatrace

```

## 🏗️ Build Configuration

### 2. Configure GitHub Secrets

### Builder Config (`builder-config.yaml`)Add all required secrets listed above in your GitHub repository settings.



- **Distribution**: `otelcol-dynatrace`### 3. Create Release

- **Go Version**: 1.24Push a tag to trigger the build and deployment pipeline:

- **OCB Version**: 0.137.0```bash

- **Components**:git tag v1.0.0

  - OTLP Receivergit push origin v1.0.0

  - **Dynatrace Receiver** (custom)```

  - Prometheus Exporter  

  - Debug Exporter### 4. Deploy and Run

  - Batch ProcessorThe pipeline will automatically:

  - Health Check Extension- Build Linux AMD64 binary

- Upload binary to JFrog Artifactory  

### Collector Config (`collector-config.yaml`)- Create Docker image (if ECR deployment enabled)

- Push image to ECR (if ECR deployment enabled)

- **Receivers**: OTLP, Host Metrics, Dynatrace- Create GitHub release with artifacts

- **Processors**: Resource, Transform, Batch

- **Exporters**: Logging, Prometheus, Dynatrace## 🏃 Quick Start

- **Extensions**: Health Check

- **Monitoring**: Prometheus metrics on `:8888`, Health on `:13133`### Using Docker

```bash

## 🔧 Configurationdocker run -d \

  --name otelcol-dynatrace \

### Required Environment Variables  -p 8888:8888 \

  -p 13133:13133 \

| Variable | Description | Example |  -e DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query" \

|----------|-------------|---------|  -e DYNATRACE_API_TOKEN="your-api-token" \

| `DEPLOYMENT_ENVIRONMENT` | Environment identifier | `production` |  -e DEPLOYMENT_ENVIRONMENT="production" \

| `CLUSTER_NAME` | Cluster identifier | `prod-cluster-01` |  -e CLUSTER_NAME="prod-cluster-01" \

  your-ecr-registry/otelcol-dynatrace:latest

### Dynatrace Integration (Optional)```



If using Dynatrace receiver/exporter, add:### Using Binary

```bash

| Variable | Description | Example |export DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query"

|----------|-------------|---------|export DYNATRACE_API_TOKEN="your-api-token"

| `DYNATRACE_API_ENDPOINT` | Dynatrace API endpoint | `https://abc12345.live.dynatrace.com` |export DEPLOYMENT_ENVIRONMENT="production"

| `DYNATRACE_API_TOKEN` | Dynatrace API token | `dt0c01.xxx...` |export CLUSTER_NAME="prod-cluster-01"



**API Token Permissions**: `metrics.read`, `metrics.write`, `entities.read`./otelcol-dynatrace --config=collector-config.yaml

```

## 🚢 GitHub Secrets (Optional)

### Verify Deployment

Configure only if using optional features:```bash

# Check Prometheus metrics

### JFrog Artifactory (Optional)curl http://localhost:8888/metrics

```

JFROG_URL=https://company.jfrog.io# Check health

JFROG_USERNAME=username  curl http://localhost:13133/health

JFROG_PASSWORD=password```

JFROG_REPOSITORY=otel-binaries

```## 🔧 Building from Source



### AWS ECR (Optional)### Prerequisites

```- Go 1.21+

AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX- Docker (for container builds)

AWS_SECRET_ACCESS_KEY=secret-key

AWS_DEFAULT_REGION=us-east-1### Build Binary

AWS_ECR_REGISTRY=123456789012.dkr.ecr.us-east-1.amazonaws.com

``````bash

# Install OpenTelemetry Collector Builder

## 📦 Artifact Naming Conventioncurl --proto '=https' --tlsv1.2 -fL -o ocb \

https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.137.0/ocb_0.137.0_linux_amd64

Following OpenTelemetry official naming:chmod +x ocb



### Binary Artifacts# Build collector

```export VERSION=1.0.0

otelcol-dynatrace_{version}_{os}_{arch}.tar.gz./ocb --config builder-config.yaml

``````



Examples:### Build Docker Image

- `otelcol-dynatrace_1.0.0_linux_amd64.tar.gz` (tagged release)

- `otelcol-dynatrace_dev-abc123-20251016152030_linux_amd64.tar.gz` (dev build)```bash

docker build -t otelcol-dynatrace:latest .

### Docker Images  ```

```

{registry}/otelcol-dynatrace_{version}_{os}_{arch}:latest## 📊 Monitoring & Observability

```

### Health Checks

Examples:- **Health endpoint**: `http://localhost:13133/health`

- `my-ecr/otelcol-dynatrace_1.0.0_linux_amd64:latest`- **Metrics endpoint**: `http://localhost:8888/metrics`

- `my-ecr/otelcol-dynatrace_dev-abc123-20251016152030_linux_amd64:latest`

### Key Metrics

## 🏗️ Building from Source- `otelcol_dynatrace_receiver_accepted_metric_points`

- `otelcol_dynatrace_receiver_refused_metric_points`

### Prerequisites- `otelcol_dynatrace_exporter_sent_metric_points`

- Go 1.24+- `otelcol_process_memory_rss`

- Docker (for containers)- `otelcol_process_cpu_seconds`



### Build Binary## 🚢 Deployment



```bash### Docker Compose

# Install OCB

curl --proto '=https' --tlsv1.2 -fL -o ocb \```yaml

  https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.137.0/ocb_0.137.0_linux_amd64version: '3.8'

chmod +x ocbservices:

  otelcol-dynatrace:

# Build collector    image: your-ecr-registry/otelcol-dynatrace:latest

export VERSION=1.0.0    ports:

./ocb --config builder-config.yaml      - "8888:8888"

```      - "13133:13133"

    environment:

### Build Docker Image      - DYNATRACE_API_ENDPOINT=${DYNATRACE_API_ENDPOINT}

      - DYNATRACE_API_TOKEN=${DYNATRACE_API_TOKEN}

```bash      - DEPLOYMENT_ENVIRONMENT=production

docker build -t otelcol-dynatrace:latest .      - CLUSTER_NAME=prod-cluster-01

```    healthcheck:

      test: ["CMD", "curl", "-f", "http://localhost:13133/health"]

## 📊 Monitoring      interval: 30s

      timeout: 10s

### Endpoints      retries: 3

    restart: unless-stopped

- **Health Check**: `http://localhost:13133/health````

- **Prometheus Metrics**: `http://localhost:8888/metrics`  

- **Service Info**: `http://localhost:13133/`## 🔒 Security



### Key Metrics- **Non-root user**: Container runs as UID 10001

- **Distroless base**: Minimal attack surface

- `otelcol_receiver_accepted_metric_points_total`- **Secret management**: Environment variables for sensitive data

- `otelcol_receiver_refused_metric_points_total`

- `otelcol_exporter_sent_metric_points_total`## 📝 License

- `otelcol_process_memory_rss`

- `otelcol_process_cpu_seconds_total`MIT License - see [LICENSE](LICENSE) file for details.



## 🔒 Security## 🤝 Contributing



- **Non-root Execution**: Container runs as UID 100011. Fork the repository

- **Distroless Base**: Minimal attack surface  2. Create feature branch

- **TLS Ready**: CA certificates included3. Make changes

- **Secret Management**: Environment variables for sensitive data4. Add tests

5. Submit pull request

## 📄 Repository Structure

## 📞 Support

```

├── .github/workflows/build-and-deploy.yml  # CI/CD pipeline- **Issues**: [GitHub Issues](https://github.com/solarekm/otelcol-dynatrace/issues)

├── .gitignore                              # Git ignore rules- **Discussions**: [GitHub Discussions](https://github.com/solarekm/otelcol-dynatrace/discussions)
├── Dockerfile                              # Multi-stage container build
├── LICENSE                                 # MIT license
├── README.md                               # This file
├── builder-config.yaml                     # OCB configuration
├── collector-config.yaml                   # Collector runtime config
├── docker-compose.yml                      # Local development
└── scripts/docker-build.sh                 # Docker build helper
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Make changes and test thoroughly
4. Commit changes (`git commit -m 'Add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/solarekm/otelcol-dynatrace/issues)
- **Discussions**: [GitHub Discussions](https://github.com/solarekm/otelcol-dynatrace/discussions)
- **Security**: Report privately via GitHub Security Advisories

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using OpenTelemetry Community Standards**