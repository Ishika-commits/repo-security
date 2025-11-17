# Safe base image (pinned to slim + digest recommended)
FROM ubuntu:22.04

# Add OCI labels (no secrets)
LABEL maintainer="admin@example.com" \
      org.opencontainers.image.description="Securely rebuilt image with Dockle best practices."

# Create a non-root user
RUN useradd -m -s /bin/bash appuser

# Update, install dependencies, and clean up in one layer
RUN apt-get update && \
    apt-get install -y vim curl && \
    rm -rf /var/lib/apt/lists/*

# Use COPY instead of ADD
COPY . /app
WORKDIR /app

# Switch to non-root user
USER appuser

# Add HEALTHCHECK (Dockle recommendation)
HEALTHCHECK --interval=60s --timeout=10s \
  CMD curl -f http://localhost:80/ || exit 1

# Expose port 80 only
EXPOSE 80

CMD ["bash"]
