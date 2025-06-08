# VPS Deployment Commands - Copy and paste these to your VPS terminal

# Step 1: Download deployment script from GitHub
echo "🔽 Downloading deployment script from GitHub..."
curl -L -o deploy-vps.sh https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh

# Step 2: Make it executable
chmod +x deploy-vps.sh

# Step 3: Verify download
echo "📁 Downloaded file info:"
ls -la deploy-vps.sh
echo ""

# Step 4: Preview first few lines to verify content
echo "📝 First 10 lines of the script:"
head -10 deploy-vps.sh
echo ""

# Step 5: Run the deployment
echo "🚀 Starting deployment..."
./deploy-vps.sh

# Alternative command if curl doesn't work:
# wget https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh
