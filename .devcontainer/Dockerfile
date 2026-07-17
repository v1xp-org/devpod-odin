FROM ghcr.io/v1xp-org/devpod-cli-uv:latest

USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  build-essential \
  clang \
  lld \
  x11-utils \
  x11-xserver-utils \
  libgl1-mesa-dev \
  libx11-dev \
  libxrandr-dev \
  libxinerama-dev \
  libxcursor-dev \
  libxi-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH

RUN echo "Installing Odin compiler..." \
  && ODIN_URL=$(curl -fsSL https://api.github.com/repos/odin-lang/Odin/releases/latest | grep '"browser_download_url"' | grep "linux-amd64" | cut -d '"' -f 4) \
  && wget -q -O odin.tar.gz "${ODIN_URL}" \
  && mkdir -p /opt/odin \
  && tar xf odin.tar.gz -C /opt/odin --strip-components=1 \
  && rm -f odin.tar.gz \
  && ln -sf /opt/odin/odin /usr/local/bin/odin

# Copy Docker-in-Docker startup script
COPY start-docker.sh /usr/local/bin/start-docker.sh
RUN chmod +x /usr/local/bin/start-docker.sh

# Copy post-create script
COPY post-create.sh /usr/local/bin/post-create.sh
RUN chmod +x /usr/local/bin/post-create.sh

# Auto-start Docker daemon on interactive shell open
RUN printf '\n# Auto-start Docker daemon (DevPod DinD)\nif [ -x /usr/local/bin/start-docker.sh ]; then\n  /usr/local/bin/start-docker.sh >/dev/null 2>&1 &\nfi\n' >> /etc/bash.bashrc

USER vscode
ENV DOCKER_IMAGE_NAME="ODIN DevPod"
