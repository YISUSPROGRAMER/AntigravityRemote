#!/usr/bin/with-contenv bash

echo "🚀 Starting Antigravity Phone Connect server supervised..."
cd /workspace/antigravity_phone_chat

# Exec into Node as the standard Webtop 'abc' user to keep privileges correct
exec s6-setuidgid abc node server.js
