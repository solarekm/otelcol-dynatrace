# Multi-stage Dockerfile for OpenTelemetry Collector with Dynatrace receiver
# Builds collector from source when no prebuilt binary is available

# Stage 1: Get CA certificates for SSL/TLS connections
FROM alpine:3.19 AS certs
RUN apk --update add ca-certificates

# Stage 2: Build OpenTelemetry Collector from source
FROM golang:1.24-alpine AS build-stage

# Install build dependencies
RUN apk add --no-cache git make curl

# Set working directory for build
WORKDIR /build

# Copy builder configuration
COPY builder-config.yaml builder-config.yaml

# Set version from build argument (passed from docker-build.sh)
ARG VERSION=1.0.0
ENV VERSION=${VERSION}

# Install OpenTelemetry Collector Builder (OCB) - official tool for building custom collectors
ARG COLLECTOR_BUILDER_VERSION=v0.137.0
RUN VERSION_NO_V=$(echo ${COLLECTOR_BUILDER_VERSION} | sed 's/^v//') && \
    curl --proto '=https' --tlsv1.2 -fL -o ocb \
    "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2F${COLLECTOR_BUILDER_VERSION}/ocb_${VERSION_NO_V}_linux_amd64" && \
    chmod +x ocb

# Build the collector using OCB with Go build cache for faster subsequent builds
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    ./ocb --config builder-config.yaml

# Stage 3: Final runtime image using distroless for minimal attack surface
FROM gcr.io/distroless/base-debian12:latest

# Set non-root user for security
ARG USER_UID=10001
USER ${USER_UID}

# Copy CA certificates from first stage
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy collector binary from build stage with execute permissions
COPY --chmod=755 --from=build-stage /build/dist/otelcol-dynatrace /otelcol-dynatrace

# Copy default configuration file
COPY collector-config.yaml /etc/otelcol/config.yaml

# Set container metadata labels for better image management
LABEL org.opencontainers.image.title="OpenTelemetry Collector with Dynatrace" \
      org.opencontainers.image.description="Custom OpenTelemetry Collector with Dynatrace receiver" \
      org.opencontainers.image.vendor="solarekm" \
      org.opencontainers.image.source="https://github.com/solarekm/otelcol-dynatrace"

# Expose standard OpenTelemetry Collector ports:
# 4317: OTLP gRPC receiver
# 4318: OTLP HTTP receiver  
# 8888: Prometheus metrics endpoint
# 13133: Health check endpoint
# 1777: pprof profiling endpoint
# 55679: zpages endpoint
EXPOSE 4317 4318 8888 13133 1777 55679

# Health check endpoint is available but distroless doesn't have curl/wget
# Users can add external health checks: curl -f http://localhost:13133/health

# Set entrypoint and default configuration
ENTRYPOINT ["/otelcol-dynatrace"]
CMD ["--config=/etc/otelcol/config.yaml"]