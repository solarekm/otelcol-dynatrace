#!/bin/bash
set -euo pipefail

# Docker build script for OpenTelemetry Collector
# Intelligently detects prebuilt binary artifacts and uses them when available
# Fallback to building from source if no prebuilt binary is found
#
# Usage: ./scripts/docker-build.sh <version> <ocb-version> <registry> <tag>
#
# Arguments:
#   version     - Collector version (e.g., dev-abc12345-20231023)
#   ocb-version - OpenTelemetry Collector Builder version (e.g., v0.137.0)
#   registry    - Docker registry URL (e.g., 123456789.dkr.ecr.region.amazonaws.com)
#   tag         - Docker image tag (e.g., otelcol-dynatrace_version_linux_amd64)

VERSION="$1"
OCB_VERSION="$2"  
REGISTRY="$3"
TAG="$4"

echo "Building Docker image with:"
echo "  Version: $VERSION"
echo "  OCB Version: $OCB_VERSION"  
echo "  Registry: $REGISTRY"
echo "  Tag: $TAG"

# Check if prebuilt binary exists and extract it
if [ -d "./prebuilt-binary" ] && [ -n "$(ls -A ./prebuilt-binary 2>/dev/null)" ]; then
    echo "📦 Using prebuilt binary..."
    mkdir -p ./dist
    cd ./prebuilt-binary
    # Extract binary from GitHub Actions artifact archive
    tar -xzf ./*.tar.gz -C ../dist/
    cd ..
    
    # Use a simpler Dockerfile for prebuilt binary (no build dependencies needed)
    cat > Dockerfile.prebuilt << 'EOF'
# Stage 1: Get CA certificates for SSL/TLS connections
FROM alpine:3.19 AS certs
RUN apk --update add ca-certificates

# Stage 2: Final runtime image using distroless for security
FROM gcr.io/distroless/base-debian12:latest
ARG USER_UID=10001
USER ${USER_UID}

# Copy certificates from builder stage
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# Copy prebuilt binary with execute permissions
COPY --chmod=755 dist/otelcol-dynatrace /otelcol-dynatrace
# Copy default collector configuration
COPY collector-config.yaml /etc/otelcol/config.yaml

# Container metadata labels
LABEL org.opencontainers.image.title="OpenTelemetry Collector with Dynatrace" \
      org.opencontainers.image.description="Custom OpenTelemetry Collector with Dynatrace receiver" \
      org.opencontainers.image.vendor="solarekm" \
      org.opencontainers.image.source="https://github.com/solarekm/otelcol-dynatrace"

# Expose standard OpenTelemetry ports
EXPOSE 4317 4318 8888 13133 1777 55679
ENTRYPOINT ["/otelcol-dynatrace"]
CMD ["--config=/etc/otelcol/config.yaml"]
EOF

    echo "🚀 Building Docker image with prebuilt binary..."
    DOCKERFILE_PATH="Dockerfile.prebuilt"
else
    echo "🔨 No prebuilt binary found, building from source..."
    DOCKERFILE_PATH="Dockerfile"  # Use standard Dockerfile that builds from source
fi

# Build Docker image with comprehensive labeling
docker build \
  --file "$DOCKERFILE_PATH" \
  --build-arg VERSION="$VERSION" \
  --build-arg COLLECTOR_BUILDER_VERSION="$OCB_VERSION" \
  --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  --label "org.opencontainers.image.description=Custom OpenTelemetry Collector with Dynatrace receiver" \
  --label "org.opencontainers.image.licenses=MIT" \
  --label "org.opencontainers.image.revision=${GITHUB_SHA:-$(git rev-parse HEAD)}" \
  --label "org.opencontainers.image.source=${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}" \
  --label "org.opencontainers.image.title=otelcol-dynatrace" \
  --label "org.opencontainers.image.url=${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}" \
  --label "org.opencontainers.image.version=$VERSION" \
  --tag "$REGISTRY:$TAG" \
  .

# Clean up temporary files to avoid polluting the workspace
[ -f "Dockerfile.prebuilt" ] && rm Dockerfile.prebuilt
[ -d "./dist" ] && rm -rf ./dist

echo "✅ Docker image built successfully: $REGISTRY:$TAG"