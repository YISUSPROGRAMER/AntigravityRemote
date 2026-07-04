#!/bin/bash
echo "📦 Antigravity IDE Auto-Extractor"
echo "---------------------------------"
cd /config/Downloads 2>/dev/null || { echo "❌ Downloads folder not found."; mkdir -p /config/Downloads; cd /config/Downloads; }

# Find the downloaded tar.gz
TAR_FILE=$(ls -t antigravity-*.tar.gz 2>/dev/null | head -n 1)

if [ -n "$TAR_FILE" ]; then
    echo "🔍 Found: $TAR_FILE"
    echo "🚚 Extracting to /config/antigravity-ide..."
    mkdir -p /config/antigravity-ide
    tar -xzf "$TAR_FILE" -C /config/antigravity-ide --strip-components=1
    echo "✅ Extraction complete!"
    echo "🚀 You can now close this terminal and double-click the 'Antigravity IDE' icon on your desktop."
else
    echo "❌ No 'antigravity-*.tar.gz' file found in your Downloads folder."
    echo "💡 Please open Chrome inside this Desktop, visit https://antigravity.google/download,"
    echo "   download the Linux (.tar.gz) package, and run this script again!"
fi
read -p "Press Enter to exit..."
