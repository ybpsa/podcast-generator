# Pin the base image version instead of "latest" for reproducibility
FROM ubuntu:22.04

# install dependencies
# Avoid interactive prompts during apt installs (e.g. tzdata config screens)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
# - Combine update+install in one layer to avoid stale cache issues
# - Pin package versions where possible for reproducible builds
# - Clean up apt cache in the same layer to keep image size down
# - --no-install-recommends avoids pulling in unnecessary extra packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Pin the PyYAML version explicitly, use python3 -m pip for clarity,
# and disable pip's cache to keep the image lean
RUN python3 -m pip install --no-cache-dir pyyaml==6.0.1

# Create a non-root user to run the application (security best practice)
RUN useradd --create-home --shell /bin/bash appuser

COPY feed.py /usr/bin/feed.py

COPY entrypoint.sh /entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Switch to the non-root user before running the container
USER appuser

ENTRYPOINT ["/entrypoint.sh"]
