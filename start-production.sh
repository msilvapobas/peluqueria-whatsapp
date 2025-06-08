#!/bin/bash

# Script de inicio para producción del bot de WhatsApp
# Uso: ./start-production.sh

echo "🚀 Iniciando bot de WhatsApp en modo PRODUCCIÓN..."

# Crear directorio de logs si no existe
mkdir -p logs

# Verificar que PM2 esté instalado
if ! command -v pm2 &> /dev/null; then
    echo "❌ PM2 no está instalado. Instalando..."
    npm install -g pm2
fi

# Parar la aplicación si ya está corriendo
echo "🛑 Deteniendo instancia anterior..."
pm2 stop whatsapp-bot 2>/dev/null || true
pm2 delete whatsapp-bot 2>/dev/null || true

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm install --production

# Verificar que existe el archivo .env
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    if [ -f ".env.production" ]; then
        echo "📝 Copiando template de producción..."
        cp .env.production .env
        echo "⚠️  IMPORTANTE: Edita el archivo .env y configura AUTH_TOKEN"
        echo "⚠️  Ejecuta: nano .env"
        exit 1
    else
        echo "❌ No se encontró .env.production"
        exit 1
    fi
fi

# Iniciar con PM2
echo "🎯 Iniciando aplicación con PM2..."
pm2 start ecosystem.config.json --env production

# Guardar configuración de PM2
pm2 save

# Mostrar status
echo "✅ Aplicación iniciada!"
echo ""
echo "📊 Estado actual:"
pm2 status

echo ""
echo "📝 Comandos útiles:"
echo "  Ver logs:     pm2 logs whatsapp-bot"
echo "  Ver status:   pm2 status"
echo "  Reiniciar:    pm2 restart whatsapp-bot"
echo "  Parar:        pm2 stop whatsapp-bot"
echo "  Monitoreo:    pm2 monit"
