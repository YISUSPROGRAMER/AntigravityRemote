#!/command/with-contenv bash
cd /workspace/antigravity_phone_chat
echo "=== SERVICE START DIAGNOSTICS ===" > /proc/1/fd/1
echo "Environment variable APP_PASSWORD: $APP_PASSWORD" > /proc/1/fd/1
echo "Contents of .env file:" > /proc/1/fd/1
cat .env > /proc/1/fd/1 2>&1
echo "[s6-service] Starting Antigravity Phone Connect server..." > /proc/1/fd/1
exec node server.js > /proc/1/fd/1 2>&1
