#!/command/with-contenv bash

echo "🔒 Starting Antigravity Development Desktop initialization..."

echo "=== DIAGNOSTICS: ANTIGRAVITY CLI ===" > /proc/1/fd/1
which antigravity > /proc/1/fd/1 2>&1
antigravity --version > /proc/1/fd/1 2>&1
antigravity --help > /proc/1/fd/1 2>&1

# Copy Webtop Desktop helper shortcuts
echo "🖥️ Setting up Desktop helper shortcuts..."
mkdir -p /config/Desktop
cp /defaults/desktop-helpers/Help_Install_Antigravity.sh /config/Desktop/Help_Install_Antigravity.sh
cp /defaults/desktop-helpers/Antigravity_IDE.desktop /config/Desktop/Antigravity_IDE.desktop
cp /defaults/desktop-helpers/Antigravity_2.desktop /config/Desktop/Antigravity_2.desktop
cp /defaults/desktop-helpers/Install_Helper.desktop /config/Desktop/Install_Helper.desktop
chmod +x /config/Desktop/Help_Install_Antigravity.sh
chmod +x /config/Desktop/*.desktop
chown -R 1000:1000 /config/Desktop

# 2. Enforce file-based password store (basic keyring) for all VS Code / Antigravity IDE instances
DIRS=(
    "/config/.vscode"
    "/config/.antigravity"
    "/config/.antigravity-ide"
    "/config/.config/Antigravity"
    "/config/.config/antigravity"
    "/config/.config/antigravity-ide"
)

for DIR in "${DIRS[@]}"; do
    mkdir -p "$DIR"
    ARGV_FILE="$DIR/argv.json"
    echo "⚙️ Writing password-store config to $ARGV_FILE..." > /proc/1/fd/1
    echo '{"password-store": "basic"}' > "$ARGV_FILE"
    chown -R 1000:1000 "$DIR"
done

echo "✅ Initialization complete."
