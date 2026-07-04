#!/command/with-contenv bash
cd /workspace/antigravity_phone_chat
echo "[s6-service] Starting Antigravity Phone Connect server..." > /proc/1/fd/1
exec node server.js > /proc/1/fd/1 2>&1
