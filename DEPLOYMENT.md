# 🚀 Deployment Guide - Peluquería WhatsApp Bot

Guía completa para hacer deployment del bot de WhatsApp en tu VPS.

## 📋 Pre-requisitos en el VPS

### 1. Instalar Node.js y npm
```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar instalación
node --version
npm --version
```

### 2. Instalar Git
```bash
sudo apt update
sudo apt install git
```

### 3. Configurar SSH (recomendado)
```bash
# Generar clave SSH en tu máquina local
ssh-keygen -t rsa -b 4096 -C "tu-email@ejemplo.com"

# Copiar clave pública al VPS
ssh-copy-id usuario@tu-vps-ip

# O manualmente:
cat ~/.ssh/id_rsa.pub | ssh usuario@tu-vps-ip "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## 🔧 Deployment Inicial

### 1. Subir código a GitHub
```bash
# En tu máquina local
cd "c:\Users\gr00v\Documents\Proyectos\peluqueria-whatsapp"

# Inicializar repo si no existe
git init
git add .
git commit -m "Initial commit: WhatsApp bot setup"

# Crear repo en GitHub y subir (ya configurado)
git remote add origin https://github.com/msilvapobas/peluqueria-whatsapp.git
git branch -M main
git push -u origin main
```

### 2. Deployment en VPS
```bash
# Conectar al VPS
ssh usuario@tu-vps-ip

# Descargar y ejecutar script de deployment
wget https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh
chmod +x deploy-vps.sh

# El script ya está configurado con la URL correcta del repositorio

# Ejecutar deployment
./deploy-vps.sh
```

### 3. Configurar variables de entorno
```bash
cd /home/ubuntu/peluqueria-whatsapp
nano .env

# Configurar:
PORT=3001
AUTH_TOKEN=TU_TOKEN_SUPER_SECRETO_AQUI
NODE_ENV=production
BASE_URL=https://tu-dominio.com
DEBUG=false
```

## 🔄 Actualizaciones

### Desde tu máquina local:
```bash
# Hacer cambios en el código
git add .
git commit -m "Descripción de cambios"
git push origin main
```

### En el VPS:
```bash
# Actualizar automáticamente
./deploy-vps.sh
```

## 🛠️ Comandos Útiles en VPS

```bash
# Estado de la aplicación
pm2 status

# Ver logs en tiempo real
pm2 logs app-sebaarevalo-wapp

# Reiniciar aplicación
pm2 restart app-sebaarevalo-wapp

# Parar aplicación
pm2 stop app-sebaarevalo-wapp

# Monitor de recursos
pm2 monit

# Ver logs específicos
tail -f logs/out.log
tail -f logs/error.log
```

## 🔒 Configuración SSL/HTTPS

### Opción 1: Certificados Let's Encrypt
```bash
# Instalar Certbot
sudo apt install certbot

# Obtener certificado
sudo certbot certonly --standalone -d tu-dominio.com

# Los certificados se guardan en:
# /etc/letsencrypt/live/tu-dominio.com/
```

### Opción 2: Reverse Proxy con Nginx
```bash
# Instalar Nginx
sudo apt install nginx

# Configurar
sudo nano /etc/nginx/sites-available/whatsapp-bot

# Contenido:
server {
    listen 80;
    server_name tu-dominio.com;
    
    location / {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Activar configuración
sudo ln -s /etc/nginx/sites-available/whatsapp-bot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 🚨 Troubleshooting

### Problema: "Error de permisos"
```bash
# Cambiar propietario de archivos
sudo chown -R ubuntu:ubuntu /home/ubuntu/peluqueria-whatsapp
```

### Problema: "Puerto en uso"
```bash
# Ver qué proceso usa el puerto
sudo lsof -i :3001
# Matar proceso si es necesario
sudo kill -9 PID
```

### Problema: "PM2 no guarda procesos"
```bash
# Reconfigurar PM2
pm2 kill
pm2 start ecosystem.config.json --env production
pm2 save
pm2 startup
```

### Problema: "WhatsApp no se conecta"
```bash
# Verificar logs
pm2 logs app-sebaarevalo-wapp
# Verificar que el QR esté disponible
curl -H "x-auth-token: TU_TOKEN" http://localhost:3001/get-qr
```

## 📱 Uso de la API

### Obtener QR para vincular WhatsApp
```bash
curl -H "x-auth-token: TU_TOKEN" http://tu-dominio.com/get-qr
```

### Enviar mensaje
```bash
curl -X POST http://tu-dominio.com/send-message \
  -H "Content-Type: application/json" \
  -H "x-auth-token: TU_TOKEN" \
  -d '{"phone": "5491234567890", "message": "Hola desde el bot!"}'
```

### Verificar estado
```bash
curl http://tu-dominio.com/status
```

## 📊 Monitoreo

### Logs importantes a revistar:
- `logs/out.log` - Salida normal de la aplicación
- `logs/error.log` - Errores de la aplicación  
- `logs/combined.log` - Todos los logs combinados

### Métricas a monitorear:
- Uso de CPU/memoria con `pm2 monit`
- Conexión de WhatsApp en logs
- Respuesta de endpoints con `curl`
