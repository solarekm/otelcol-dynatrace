# Multi-stage Dockerfile for OpenTelemetry Collector with Dynatrace receiver

# Stage 1: Get certificates
FROM alpine:3.19 AS certs
RUN apk --update add ca-certificates

# Stage 2: Build OpenTelemetry Collector
FROM golang:1.24-alpine AS build-stage

# Install build dependencies
RUN apk add --no-cache git make curl

# Set working directory
WORKDIR /build

# Copy builder configuration
COPY builder-config.yaml builder-config.yaml

# Set version from build arg
ARG VERSION=1.0.0
ENV VERSION=${VERSION}

# Install OpenTelemetry Collector Builder (official approach)
ARG COLLECTOR_BUILDER_VERSION=v0.137.0
RUN VERSION_NO_V=$(echo ${COLLECTOR_BUILDER_VERSION} | sed 's/^v//') && \
    curl --proto '=https' --tlsv1.2 -fL -o ocb \
    "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2F${COLLECTOR_BUILDER_VERSION}/ocb_${VERSION_NO_V}_linux_amd64" && \
    chmod +x ocb

# Build the collector
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    ./ocb --config builder-config.yaml

# Stage 3: Final runtime image
FROM gcr.io/distroless/base-debian12:latest

# Set user
ARG USER_UID=10001
USER ${USER_UID}

# Copy certificates
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy collector binary
COPY --chmod=755 --from=build-stage /build/dist/otelcol-dynatrace /otelcol-dynatrace

# Copy default configuration
COPY collector-config.yaml /etc/otelcol/config.yaml

# Set labels
LABEL org.opencontainers.image.title="OpenTelemetry Collector with Dynatrace" \
      org.opencontainers.image.description="Custom OpenTelemetry Collector with Dynatrace receiver" \
      org.opencontainers.image.vendor="solarekm" \
      org.opencontainers.image.source="https://github.com/solarekm/otelcol-dynatrace"

# Expose ports
EXPOSE 4317 4318 8888 13133 1777 55679

# Health check - distroless doesn't have curl/wget, so we'll let Docker/K8s handle external health checks
# Users can add: curl -f http://localhost:13133/health in their deployment

# Set entrypoint
ENTRYPOINT ["/otelcol-dynatrace"]
CMD ["--config=/etc/otelcol/config.yaml"]