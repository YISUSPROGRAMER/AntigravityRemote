#!/command/with-contenv bash

echo "🔒 Starting Antigravity Phone Connect initialization..."

echo "=== DIAGNOSTICS: ANTIGRAVITY CLI ===" > /proc/1/fd/1
which antigravity > /proc/1/fd/1 2>&1
antigravity --version > /proc/1/fd/1 2>&1
antigravity --help > /proc/1/fd/1 2>&1

ENV_FILE="/workspace/antigravity_phone_chat/.env"
ENV_TEMPLATE="/workspace/antigravity_phone_chat/.env.example"

# 1. Create .env from template if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    echo "📄 Creating .env file from template..."
    cp "$ENV_TEMPLATE" "$ENV_FILE"
fi

# Helper function to read/set env values in .env file
set_env_val() {
    local key="$1"
    local val="$2"
    if grep -q "^${key}=" "$ENV_FILE"; then
        sed -i "s|^${key}=.*|${key}=${val}|" "$ENV_FILE"
    else
        echo "${key}=${val}" >> "$ENV_FILE"
    fi
}

# 2. Enforce secure container defaults
echo "🛡️ Enforcing Zero-Trust defaults..."
set_env_val "PORT" "3100"
set_env_val "TRUST_LAN" "false"

# 3. Generate random SESSION_SECRET if default or missing
CURRENT_SECRET=$(grep "^SESSION_SECRET=" "$ENV_FILE" | cut -d'=' -f2- || true)
if [ -z "$CURRENT_SECRET" ] || [ "$CURRENT_SECRET" = "antigravity_secret_key_1337" ]; then
    RANDOM_SECRET=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 || true)
    echo "🔑 Generating secure random SESSION_SECRET..."
    set_env_val "SESSION_SECRET" "$RANDOM_SECRET"
fi

# 4. Check/Generate APP_PASSWORD
if [ -n "$APP_PASSWORD" ] && [ "$APP_PASSWORD" != "antigravity" ]; then
    echo "👤 Enforcing APP_PASSWORD from Docker environment..."
    set_env_val "APP_PASSWORD" "$APP_PASSWORD"
else
    CURRENT_PASS=$(grep "^APP_PASSWORD=" "$ENV_FILE" | cut -d'=' -f2- || true)
    if [ -z "$CURRENT_PASS" ] || [ "$CURRENT_PASS" = "antigravity" ] || [ "$CURRENT_PASS" = "your-app-password" ]; then
        RANDOM_PASS=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 12 || true)
        echo "⚠️  No APP_PASSWORD set or using default. Generating a random passcode: $RANDOM_PASS"
        echo "💾 PLEASE SAVE THIS PASSCODE FOR LOGIN!"
        set_env_val "APP_PASSWORD" "$RANDOM_PASS"
    fi
fi

# 5. Check/Generate AUTH_SALT
CURRENT_SALT=$(grep "^AUTH_SALT=" "$ENV_FILE" | cut -d'=' -f2- || true)
if [ -z "$CURRENT_SALT" ] || [ "$CURRENT_SALT" = "antigravity_default_salt_99" ]; then
    RANDOM_SALT=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 || true)
    set_env_val "AUTH_SALT" "$RANDOM_SALT"
fi

# 6. Copy Webtop Desktop helper shortcuts
echo "🖥️ Setting up Desktop helper shortcuts..."
mkdir -p /config/Desktop
cp /defaults/desktop-helpers/Help_Install_Antigravity.sh /config/Desktop/Help_Install_Antigravity.sh
cp /defaults/desktop-helpers/Antigravity_IDE.desktop /config/Desktop/Antigravity_IDE.desktop
cp /defaults/desktop-helpers/Install_Helper.desktop /config/Desktop/Install_Helper.desktop
chmod +x /config/Desktop/Help_Install_Antigravity.sh
chmod +x /config/Desktop/*.desktop
chown -R 1000:1000 /config/Desktop

echo "✅ Initialization complete. Antigravity Phone Connect is secured."
