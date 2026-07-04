#!/command/with-contenv bash
cd /workspace/antigravity_phone_chat
echo "=== SERVICE START DIAGNOSTICS ==="
echo "Environment variable APP_PASSWORD: $APP_PASSWORD"
echo "Contents of .env file:"
cat .env
echo "[s6-service] Starting Antigravity Phone Connect server..."
exec node server.js
