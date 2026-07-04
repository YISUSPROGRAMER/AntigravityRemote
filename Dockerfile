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

# Copy patched phone chat application
COPY --chown=1000:1000 antigravity_phone_chat /workspace/antigravity_phone_chat

# Install NodeJS production dependencies
RUN cd /workspace/antigravity_phone_chat && npm install --omit=dev

# Install custom init configuration script for Webtop (runs once on container start)
COPY --chmod=755 config/init-setup.sh /custom-cont-init.d/99-phone-connect-setup

# Install custom s6 service to supervise the phone connect server
RUN mkdir -p /custom-services.d/phone-connect
COPY --chmod=755 config/service-run.sh /custom-services.d/phone-connect/run

# Set ownership of workspace to abc (Webtop user)
RUN chown -R 1000:1000 /workspace

# Copy desktop helper files to defaults staging
RUN mkdir -p /defaults/desktop-helpers
COPY config/Help_Install_Antigravity.sh /defaults/desktop-helpers/Help_Install_Antigravity.sh
COPY config/Antigravity_IDE.desktop /defaults/desktop-helpers/Antigravity_IDE.desktop
COPY config/Install_Helper.desktop /defaults/desktop-helpers/Install_Helper.desktop
RUN chmod +x /defaults/desktop-helpers/Help_Install_Antigravity.sh

# Expose ports
# - Port 3000: Webtop GUI (HTTP Web Desktop)
# - Port 3001: Webtop GUI (HTTPS Web Desktop)
# - Port 3100: Antigravity Phone Connect (Zero-Trust Frontend)
EXPOSE 3000 3001 3100

# Keep default LinuxServer Webtop entrypoint (/init), which manages the services
