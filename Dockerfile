# Base image with Ubuntu XFCE Web Desktop
FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/config

# Install dependencies (NodeJS, Python, git, curl, wget)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Google Antigravity CLI globally
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- -d /usr/local/bin

# Create workspace directory
WORKDIR /workspace

# Install custom init configuration script for Webtop (runs once on container start)
COPY --chmod=755 config/init-setup.sh /custom-cont-init.d/99-webtop-setup

# Set ownership of workspace to abc (Webtop user)
RUN chown -R 1000:1000 /workspace

# Copy desktop helper files to defaults staging
RUN mkdir -p /defaults/desktop-helpers
COPY config/Help_Install_Antigravity.sh /defaults/desktop-helpers/Help_Install_Antigravity.sh
COPY config/Antigravity_IDE.desktop /defaults/desktop-helpers/Antigravity_IDE.desktop
COPY config/Antigravity_2.desktop /defaults/desktop-helpers/Antigravity_2.desktop
COPY config/Install_Helper.desktop /defaults/desktop-helpers/Install_Helper.desktop
RUN chmod +x /defaults/desktop-helpers/Help_Install_Antigravity.sh

# Expose ports
# - Port 3000: Webtop GUI (HTTP Web Desktop)
# - Port 3001: Webtop GUI (HTTPS Web Desktop)
EXPOSE 3000 3001

# Keep default LinuxServer Webtop entrypoint (/init), which manages the services
