# Multi-stage Dockerfile for OpenTelemetry Collector with Dynatrace receiver

# Stage 1: Get certificates
FROM alpine:3.19 AS certs
RUN apk --update add ca-certificates

# Stage 2: Build OpenTelemetry Collector
FROM golang:1.21-alpine AS build-stage

# Install build dependencies
RUN apk add --no-cache git make

# Set working directory
WORKDIR /build

# Copy builder configuration
COPY builder-config.yaml builder-config.yaml

# Set version from build arg
ARG VERSION=1.0.0
ENV VERSION=${VERSION}

# Install OpenTelemetry Collector Builder
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    GO111MODULE=on go install go.opentelemetry.io/collector/cmd/builder@v0.112.0

# Build the collector
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    builder --config builder-config.yaml

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

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD ["/otelcol-dynatrace", "--config=/etc/otelcol/config.yaml", "--dry-run"]

# Set entrypoint
ENTRYPOINT ["/otelcol-dynatrace"]
CMD ["--config=/etc/otelcol/config.yaml"]