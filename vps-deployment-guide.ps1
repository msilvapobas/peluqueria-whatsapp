# VPS Deployment - Alternative Method
# Since GitHub raw access might have issues, here are alternative deployment methods

Write-Host "=== VPS DEPLOYMENT ALTERNATIVES ===" -ForegroundColor Green

Write-Host "`n📋 OPTION 1: Copy deployment script manually" -ForegroundColor Cyan
Write-Host "1. Copy the deploy-vps.sh content from your local machine"
Write-Host "2. On VPS, create the file: nano deploy-vps.sh"
Write-Host "3. Paste the content and save"
Write-Host "4. Make executable: chmod +x deploy-vps.sh"
Write-Host "5. Run: ./deploy-vps.sh"

Write-Host "`n📋 OPTION 2: Direct git clone method" -ForegroundColor Cyan
Write-Host "Run these commands on your VPS:"
Write-Host ""
Write-Host "# Install prerequisites" -ForegroundColor Yellow
Write-Host "sudo apt update"
Write-Host "sudo apt install -y nodejs npm git"
Write-Host ""
Write-Host "# Clone repository" -ForegroundColor Yellow
Write-Host "cd /home/ubuntu"
Write-Host "git clone https://github.com/msilvapobas/peluqueria-whatsapp.git"
Write-Host "cd peluqueria-whatsapp"
Write-Host ""
Write-Host "# Install dependencies" -ForegroundColor Yellow
Write-Host "npm install"
Write-Host ""
Write-Host "# Install PM2 globally" -ForegroundColor Yellow
Write-Host "sudo npm install -g pm2"
Write-Host ""
Write-Host "# Create production environment file" -ForegroundColor Yellow
Write-Host "cp .env.production .env"
Write-Host "nano .env  # Edit with your AUTH_TOKEN"
Write-Host ""
Write-Host "# Start with PM2" -ForegroundColor Yellow
Write-Host "pm2 start ecosystem.config.json --env production"
Write-Host "pm2 startup"
Write-Host "pm2 save"

Write-Host "`n📋 OPTION 3: Manual step-by-step deployment" -ForegroundColor Cyan
Write-Host "If the repository is private, you can:"
Write-Host "1. Create a new public repository or"
Write-Host "2. Use SCP to copy files directly to VPS or"
Write-Host "3. Set up SSH key authentication for private repo access"

Write-Host "`n🔧 Current repository URL:" -ForegroundColor Yellow
Write-Host "   https://github.com/msilvapobas/peluqueria-whatsapp.git"

Write-Host "`n⚠️  NOTE: If repository is private, you'll need to:" -ForegroundColor Red
Write-Host "   - Make it public, or"
Write-Host "   - Add SSH key to GitHub account, or"
Write-Host "   - Use personal access token for authentication"
