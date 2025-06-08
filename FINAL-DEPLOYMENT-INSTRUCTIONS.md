# =============================================================================
# FINAL VPS DEPLOYMENT INSTRUCTIONS
# =============================================================================

✅ READY TO DEPLOY TO VPS!

📋 DEPLOYMENT METHOD (Choose one):

=== METHOD 1: Direct Git Clone (RECOMMENDED) ===
Copy and paste these commands to your VPS terminal:

```bash
# Connect to VPS
ssh -p5661 root@149.50.144.227

# Install prerequisites
apt update
apt install -y curl

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Git
apt install -y git

# Install PM2 globally
npm install -g pm2

# Clone repository
cd /root
git clone https://github.com/msilvapobas/peluqueria-whatsapp.git
cd peluqueria-whatsapp

# Install dependencies
npm install

# Setup environment
cp .env.production .env
nano .env
# ⚠️ IMPORTANT: Change AUTH_TOKEN to a secure value!

# Start with PM2
pm2 start ecosystem.config.json --env production
pm2 startup systemd -u root --hp /root
pm2 save

# Check status
pm2 status
```

=== METHOD 2: Manual Script Copy ===
If git clone doesn't work:

1. Copy the content of 'deploy-vps-complete.sh' from your local machine
2. On VPS: nano deploy-vps.sh
3. Paste the content and save
4. chmod +x deploy-vps.sh
5. ./deploy-vps.sh

=== METHOD 3: SCP Transfer ===
Transfer files directly from your Windows machine:

```powershell
# Install OpenSSH client if not available
# Then use SCP to transfer files
scp -P 5661 -r "c:\Users\gr00v\Documents\Proyectos\peluqueria-whatsapp" root@149.50.144.227:/root/
```

📊 POST-DEPLOYMENT CHECKLIST:

✅ Application Status:
   pm2 status

✅ View Logs:
   pm2 logs app-sebaarevalo-wapp

✅ Check Application URL:
   curl http://localhost:3001/webhook
   
✅ Test Webhook:
   curl -X POST http://localhost:3001/webhook \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
   -d '{"test": "message"}'

✅ Configure SSL (if needed):
   - Update .env with SSL certificate paths
   - Ensure certificates exist in specified locations

🔧 USEFUL PM2 COMMANDS:
   pm2 restart app-sebaarevalo-wapp    # Restart app
   pm2 stop app-sebaarevalo-wapp       # Stop app  
   pm2 logs app-sebaarevalo-wapp       # View logs
   pm2 monit                           # Resource monitor
   pm2 startup                         # Setup auto-start
   pm2 save                            # Save current processes

🔍 TROUBLESHOOTING:
   - Check logs: pm2 logs app-sebaarevalo-wapp
   - Check environment: cat /root/peluqueria-whatsapp/.env
   - Check port: netstat -tlnp | grep 3001
   - Check process: ps aux | grep node

⚠️ SECURITY REMINDERS:
   1. Change AUTH_TOKEN in .env file
   2. Configure firewall for port 3001
   3. Set up SSL certificates for production
   4. Regular backups of WhatsApp session data

🎯 YOUR VPS CONNECTION:
   ssh -p5661 root@149.50.144.227

Ready to deploy! Choose your preferred method above.
