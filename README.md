# OpenTelemetry Collector with Dynatrace Receiver

This repository contains a custom OpenTelemetry Collector distribution with integrated Dynatrace receiver for seamless metrics collection and forwarding.

## � Repository Contents

This repository provides everything needed to build and deploy a custom OpenTelemetry Collector with Dynatrace integration:

- **`builder-config.yaml`** - OpenTelemetry Collector Builder configuration with all required components
- **`collector-config.yaml`** - Ready-to-use collector configuration with Dynatrace receiver
- **`Dockerfile`** - Multi-stage Docker image for containerized deployment
- **`.github/workflows/build-and-deploy.yml`** - Complete CI/CD pipeline for building and distributing binaries
- **`.env.example`** - Environment variables template

## � What You Get

- **Dynatrace Receiver**: Native integration with Dynatrace Metrics API v2
- **Multi-platform Binaries**: Automated builds for Linux, macOS, Windows (amd64, arm64)
- **Docker Images**: Optimized container images pushed to AWS ECR
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

#### AWS ECR
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
- Build multi-platform binaries
- Create Docker images and push to ECR
- Upload binaries to JFrog Artifactory
- Create GitHub release with artifacts

## 🏃 Quick Start

### Using Docker
```bash
docker run -d \
  --name otelcol-dynatrace \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 8888:8888 \
  -e DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query" \
  -e DYNATRACE_API_TOKEN="your-api-token" \
  -e DEPLOYMENT_ENVIRONMENT="production" \
  your-ecr-registry/otelcol-dynatrace:latest
```

### Using Binary
```bash
export DYNATRACE_API_ENDPOINT="https://your-env.live.dynatrace.com/api/v2/metrics/query"
export DYNATRACE_API_TOKEN="your-api-token"
export DEPLOYMENT_ENVIRONMENT="production"

./otelcol-dynatrace --config=collector-config.yaml
```

3. **Verify metrics:**
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

## � Version Management

### Component Versions Overview

This collector is built with specific versions of OpenTelemetry components for stability and compatibility:

| Component | Current Version | Configuration Location |
|-----------|----------------|----------------------|
| **OpenTelemetry Core** | `v0.112.0` | `builder-config.yaml` → `dist.otelcol_version` |
| **Contrib Components** | `v0.112.0` | `builder-config.yaml` → `dist.version` |
| **Dynatrace Receiver** | `42196ef91a0b759530f94ba83881da7f978f73a9` | `builder-config.yaml` → `receivers.dynatrace` |
| **OCB (Builder)** | `v0.137.0` | Installation command |

### Checking Current Versions

```bash
# Check built collector version
./otelcol-dynatrace --version

# Inspect builder configuration
cat builder-config.yaml | grep -E "(version|commit)"

# Check OCB version
./ocb version
```

### Updating Component Versions

#### 1. Update OpenTelemetry Core & Contrib

Edit `builder-config.yaml`:
```yaml
dist:
  name: otelcol-dynatrace
  description: Custom OpenTelemetry Collector with Dynatrace receiver
  version: 1.0.0
  otelcol_version: 0.115.0  # ← Update core version
```

#### 2. Update Dynatrace Receiver

Monitor [MaCriMora's repository](https://github.com/MaCriMora/opentelemetry-collector-contrib) for updates:

```bash
# Check latest commits
curl -s https://api.github.com/repos/MaCriMora/opentelemetry-collector-contrib/commits | jq '.[0].sha'

# Update in builder-config.yaml
receivers:
  - gomod: github.com/MaCriMora/opentelemetry-collector-contrib/receiver/dynatracereceiver v0.0.0-20241014121513-NEW_COMMIT_HASH
```

#### 3. Update OCB Builder

```bash
# Download newer OCB version
curl --proto '=https' --tlsv1.2 -fL -o ocb \
https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv0.140.0/ocb_0.140.0_linux_amd64
chmod +x ocb
```

### Version Compatibility Matrix

| OTel Core | Contrib | OCB Builder | Go Version | Status |
|-----------|---------|-------------|------------|--------|
| v0.112.0 | v0.112.0 | v0.137.0 | 1.21+ | ✅ Current |
| v0.111.0 | v0.111.0 | v0.136.0 | 1.21+ | ✅ Supported |
| v0.110.0 | v0.110.0 | v0.135.0 | 1.20+ | ⚠️ EOL |

### Best Practices for Version Updates

1. **Test in Development First**
   ```bash
   # Build with new versions
   ./ocb --config builder-config.yaml --output-path ./test-build
   
   # Test functionality
   ./test-build/otelcol-dynatrace --config collector-config.yaml --dry-run
   ```

2. **Update Dependencies Gradually**
   - Update OCB first, then OTel components
   - Test each update independently
   - Keep Dynatrace receiver version stable until core is updated

3. **Monitor Breaking Changes**
   - Check [OpenTelemetry Release Notes](https://github.com/open-telemetry/opentelemetry-collector/releases)
   - Review [Contrib Changelog](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/CHANGELOG.md)
   - Watch MaCriMora's fork for Dynatrace receiver updates

4. **Automated Version Checks**
   ```bash
   # Add to CI pipeline
   ./scripts/check-versions.sh  # Script to validate version compatibility
   ```

### Rollback Strategy

If new versions cause issues:

```bash
# 1. Revert builder-config.yaml to previous versions
git checkout HEAD~1 -- builder-config.yaml

# 2. Rebuild with previous configuration
./ocb --config builder-config.yaml

# 3. Update CI/CD to use rollback version
git tag v1.0.1-rollback
git push origin v1.0.1-rollback
```

## �📊 Monitoring & Observability

### Health Checks
- **Health endpoint**: `http://localhost:13133/health`
- **Metrics endpoint**: `http://localhost:8888/metrics`
- **zPages**: `http://localhost:55679/debug/`
- **pprof**: `http://localhost:1777/debug/pprof/`

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
      - "4317:4317"
      - "4318:4318"
      - "8888:8888"
      - "13133:13133"
    environment:
      - DYNATRACE_API_ENDPOINT=${DYNATRACE_API_ENDPOINT}
      - DYNATRACE_API_TOKEN=${DYNATRACE_API_TOKEN}
      - DEPLOYMENT_ENVIRONMENT=production
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
- **TLS support**: OTLP with TLS encryption

## 🛠️ Troubleshooting

### Common Issues

1. **API Token Issues**
```bash
# Check token permissions
curl -H "Authorization: Api-Token $DYNATRACE_API_TOKEN" \
  "$DYNATRACE_API_ENDPOINT?metricSelector=builtin:host.cpu.usage"
```

2. **Memory Issues**
```bash
# Increase ballast size in config
extensions:
  ballast:
    size_mib: 512  # Increase from 165
```

3. **High CPU Usage**
```bash
# Reduce polling frequency
receivers:
  dynatrace:
    poll_interval: 60s  # Increase from 30s
```

### Debug Mode

```bash
# Enable debug logging
export OTEL_LOG_LEVEL=debug
./otelcol-dynatrace --config=collector-config.yaml
```

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
- **Security**: security@example.com