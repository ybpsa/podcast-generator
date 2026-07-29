FROM ubuntu:latest

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

COPY feed.py /usr/bin/feed.py

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
