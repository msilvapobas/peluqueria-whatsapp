#!/bin/bash
# =============================================================================
# WHATSAPP BOT - VPS DEPLOYMENT SCRIPT
# Repository: https://github.com/msilvapobas/peluqueria-whatsapp.git
# =============================================================================

echo "🚀 WhatsApp Bot Deployment for VPS"
echo "==================================="
echo "Server: root@149.50.144.227:5661"
echo "Date: $(date)"
echo ""

# Configuration
REPO_URL="https://github.com/msilvapobas/peluqueria-whatsapp.git"
APP_DIR="/root/peluqueria-whatsapp"
APP_NAME="app-sebaarevalo-wapp"
NODE_VERSION="18"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (current user: $(whoami))"
    exit 1
fi

print_status "Starting deployment process..."

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    print_status "Installing Node.js $NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
    apt-get install -y nodejs
else
    print_status "Node.js already installed: $(node --version)"
fi

# Install Git if not present
if ! command -v git &> /dev/null; then
    print_status "Installing Git..."
    apt update
    apt install -y git
else
    print_status "Git already installed: $(git --version)"
fi

# Install PM2 globally if not present
if ! command -v pm2 &> /dev/null; then
    print_status "Installing PM2..."
    npm install -g pm2
else
    print_status "PM2 already installed: $(pm2 --version)"
fi

# Clone or update repository
if [ -d "$APP_DIR" ]; then
    print_status "Directory exists, updating code..."
    cd "$APP_DIR"
    
    # Stop application if running
    print_status "Stopping application..."
    pm2 stop $APP_NAME 2>/dev/null || print_warning "Application was not running"
    
    # Backup environment file
    if [ -f ".env" ]; then
        cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
        print_status "Environment file backed up"
    fi
    
    # Update code
    git fetch origin
    git reset --hard origin/main
    print_status "Code updated from GitHub"
    
    # Restore environment if backup exists
    if [ -f ".env.backup.$(date +%Y%m%d_%H%M%S)" ]; then
        cp .env.backup.$(date +%Y%m%d_%H%M%S) .env
        print_status "Environment file restored from backup"
    fi
else
    print_status "Cloning repository..."
    cd $(dirname "$APP_DIR")
    git clone "$REPO_URL" $(basename "$APP_DIR")
    cd "$APP_DIR"
    print_status "Repository cloned successfully"
fi

# Install dependencies
print_status "Installing Node.js dependencies..."
npm install

# Setup environment file
if [ ! -f ".env" ]; then
    print_status "Creating production environment file..."
    cp .env.production .env
    print_warning "IMPORTANT: Edit .env file to set your AUTH_TOKEN!"
    print_warning "Run: nano .env"
else
    print_status "Environment file already exists"
fi

# Create logs directory
mkdir -p logs

# Start application with PM2
print_status "Starting application with PM2..."
pm2 start ecosystem.config.json --env production

# Setup PM2 startup
print_status "Setting up PM2 startup..."
pm2 startup systemd -u root --hp /root
pm2 save

# Show status
print_status "Deployment completed!"
echo ""
echo "📊 Application Status:"
pm2 status

echo ""
echo "🔧 Useful Commands:"
echo "   pm2 status                     - Check app status"
echo "   pm2 logs $APP_NAME            - View logs"
echo "   pm2 restart $APP_NAME         - Restart app"
echo "   pm2 stop $APP_NAME            - Stop app"
echo "   pm2 monit                      - Monitor resources"
echo ""
echo "📝 Configuration:"
echo "   Application: $APP_DIR"
echo "   Environment: $APP_DIR/.env"
echo "   Logs: $APP_DIR/logs/"
echo ""
echo "⚠️  NEXT STEPS:"
echo "   1. Edit environment: nano $APP_DIR/.env"
echo "   2. Set secure AUTH_TOKEN value"
echo "   3. Test the application"
echo ""
echo "✅ Deployment completed successfully!"
