#!/bin/bash

# Test script to download deploy-vps.sh from GitHub
# Using raw.githubusercontent.com for direct file access

echo "🔽 Testing download of deploy-vps.sh from GitHub..."

# URL correcta para archivos raw en GitHub
RAW_URL="https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh"

echo "📍 URL: $RAW_URL"

# Intentar descargar
if curl -f -L -o deploy-vps-downloaded.sh "$RAW_URL"; then
    echo "✅ Download successful!"
    chmod +x deploy-vps-downloaded.sh
    echo "📁 File saved as: deploy-vps-downloaded.sh"
    ls -la deploy-vps-downloaded.sh
else
    echo "❌ Download failed!"
    echo "🔍 Trying to diagnose the issue..."
    
    # Check if the repository is accessible
    if curl -f -L "https://api.github.com/repos/msilvapobas/peluqueria-whatsapp" > /dev/null 2>&1; then
        echo "✅ Repository is accessible via API"
    else
        echo "❌ Repository is not accessible"
    fi
fi
