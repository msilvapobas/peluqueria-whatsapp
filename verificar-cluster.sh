#!/bin/bash
# Script para verificar configuración cluster del WhatsApp Bot

echo "🔍 VERIFICACIÓN DE CONFIGURACIÓN CLUSTER"
echo "========================================"
echo ""

# Verificar directorio
if [ ! -d "~/peluqueria-whatsapp" ]; then
    echo "❌ Directorio del proyecto no encontrado"
    exit 1
fi

cd ~/peluqueria-whatsapp

echo "📋 Estado actual de PM2:"
pm2 list
echo ""

echo "⚙️  Configuración del proceso:"
pm2 show app-sebaarevalo-wapp
echo ""

echo "📊 Información detallada:"
echo "   • Modo: $(pm2 jlist | jq -r '.[0].pm2_env.exec_mode // "No detectado"')"
echo "   • Instancias: $(pm2 jlist | jq -r '.[0].pm2_env.instances // "No detectado"')"
echo "   • Cron restart: $(pm2 jlist | jq -r '.[0].pm2_env.cron_restart // "No configurado"')"
echo "   • NODE_ENV: $(pm2 jlist | jq -r '.[0].pm2_env.NODE_ENV // "No detectado"')"
echo "   • Puerto: $(pm2 jlist | jq -r '.[0].pm2_env.PORT // "No detectado"')"
echo ""

echo "📱 Estado del servidor:"
netstat -tlnp | grep :300
echo ""

echo "📝 Últimos logs (últimas 15 líneas):"
pm2 logs app-sebaarevalo-wapp --lines 15
echo ""

echo "🔗 Verificando conectividad:"
if curl -s http://localhost:3001/health > /dev/null; then
    echo "   ✅ Servidor responde en puerto 3001"
elif curl -s http://localhost:3002/health > /dev/null; then
    echo "   ✅ Servidor responde en puerto 3002"
elif curl -s http://localhost:3000/health > /dev/null; then
    echo "   ✅ Servidor responde en puerto 3000"
else
    echo "   ❌ Servidor no responde en puertos 3000, 3001, 3002"
fi

echo ""
echo "📄 Configuración ecosystem.config.json:"
if [ -f "ecosystem.config.json" ]; then
    echo "   ✅ Archivo existe"
    echo "   Modo exec: $(cat ecosystem.config.json | jq -r '.apps[0].exec_mode')"
    echo "   Instancias: $(cat ecosystem.config.json | jq -r '.apps[0].instances')"
    echo "   Cron restart: $(cat ecosystem.config.json | jq -r '.apps[0].cron_restart')"
else
    echo "   ❌ Archivo ecosystem.config.json no encontrado"
fi

echo ""
echo "✅ Verificación completa"
