#!/bin/bash
set -euo pipefail

# Docker build script for OpenTelemetry Collector
# Usage: ./scripts/docker-build.sh <version> <ocb-version> <registry> <tag>

VERSION="$1"
OCB_VERSION="$2"  
REGISTRY="$3"
TAG="$4"

echo "Building Docker image with:"
echo "  Version: $VERSION"
echo "  OCB Version: $OCB_VERSION"  
echo "  Registry: $REGISTRY"
echo "  Tag: $TAG"

docker build \
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

echo "✅ Docker image built successfully: $REGISTRY:$TAG"