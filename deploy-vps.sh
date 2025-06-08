#!/bin/bash

# Script de deployment para VPS
# Deployment automático desde GitHub para peluqueria-whatsapp

set -e  # Salir si hay cualquier error

# Configuración
REPO_URL="https://github.com/TU_USUARIO/peluqueria-whatsapp.git"
APP_DIR="/home/ubuntu/peluqueria-whatsapp"
APP_NAME="app-sebaarevalo-wapp"

echo "🚀 Iniciando deployment de peluqueria-whatsapp..."
echo "📅 $(date)"

# Función para log con colores
log_info() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

log_warn() {
    echo -e "\033[33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# Verificar si el directorio existe
if [ -d "$APP_DIR" ]; then
    log_info "Directorio existe, actualizando código..."
    cd "$APP_DIR"
    
    # Parar la aplicación si está corriendo
    log_info "Deteniendo aplicación..."
    pm2 stop $APP_NAME 2>/dev/null || log_warn "Aplicación no estaba corriendo"
    
    # Hacer backup de configuración actual
    if [ -f ".env" ]; then
        cp .env .env.backup
        log_info "Backup de .env creado"
    fi
    
    # Actualizar código
    git fetch origin
    git reset --hard origin/main
    log_info "Código actualizado desde GitHub"
    
    # Restaurar configuración
    if [ -f ".env.backup" ]; then
        cp .env.backup .env
        log_info "Configuración restaurada"
    fi
    
else
    log_info "Clonando repositorio..."
    cd /home/ubuntu
    git clone $REPO_URL
    cd "$APP_DIR"
fi

# Instalar/actualizar dependencias
log_info "Instalando dependencias..."
npm install --production

# Crear directorio de logs
mkdir -p logs

# Configurar archivo .env si no existe
if [ ! -f ".env" ]; then
    if [ -f ".env.production" ]; then
        log_warn "Archivo .env no encontrado, copiando template..."
        cp .env.production .env
        log_error "⚠️  IMPORTANTE: Debes editar .env y configurar AUTH_TOKEN"
        log_error "⚠️  Ejecuta: nano .env"
        echo ""
        echo "Presiona ENTER cuando hayas configurado .env..."
        read
    else
        log_error "No se encontró .env.production template"
        exit 1
    fi
fi

# Verificar que PM2 esté instalado
if ! command -v pm2 &> /dev/null; then
    log_info "Instalando PM2..."
    npm install -g pm2
fi

# Iniciar aplicación
log_info "Iniciando aplicación con PM2..."
pm2 start ecosystem.config.json --env production

# Guardar configuración de PM2
pm2 save

# Configurar PM2 para auto-inicio
pm2 startup | grep "sudo" | bash || log_warn "PM2 startup ya configurado"

log_info "✅ Deployment completado!"
echo ""
echo "📊 Estado de la aplicación:"
pm2 status

echo ""
echo "📝 Comandos útiles:"
echo "  Ver logs:      pm2 logs $APP_NAME"
echo "  Ver status:    pm2 status"
echo "  Reiniciar:     pm2 restart $APP_NAME"
echo "  Parar:         pm2 stop $APP_NAME"
echo "  Monitoreo:     pm2 monit"
echo ""
echo "🔧 Para actualizaciones futuras:"
echo "  ./deploy-vps.sh"
