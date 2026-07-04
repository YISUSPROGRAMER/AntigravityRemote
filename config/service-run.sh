#!/command/with-contenv bash
cd /workspace/antigravity_phone_chat
echo "=== SERVICE START DIAGNOSTICS ==="
echo "Environment variable APP_PASSWORD: $APP_PASSWORD"
echo "=== CONTAINER PROCESSES ==="
ps aux
echo "=== CONTAINER PORTS LISTENING ==="
netstat -tuln || ss -tuln
echo "[s6-service] Starting Antigravity Phone Connect server..."
exec node server.js
