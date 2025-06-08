#!/bin/bash

# =============================================================================
# SCRIPT AUTOMÁTICO PARA VPS - COPIA Y PEGA TODO ESTO
# =============================================================================

echo "🚀 Iniciando instalación automática del WhatsApp Bot..."
echo "================================================================"

# Colores para mostrar mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Función para mostrar mensajes
show_step() {
    echo -e "${GREEN}[PASO]${NC} $1"
}

show_warning() {
    echo -e "${YELLOW}[ATENCIÓN]${NC} $1"
}

show_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Paso 1: Actualizar sistema
show_step "1. Actualizando el sistema..."
apt update && apt upgrade -y

# Paso 2: Instalar curl
show_step "2. Instalando curl..."
apt install -y curl

# Paso 3: Instalar Node.js 18
show_step "3. Instalando Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Verificar Node.js
echo "Node.js instalado: $(node --version)"
echo "NPM instalado: $(npm --version)"

# Paso 4: Instalar Git
show_step "4. Instalando Git..."
apt install -y git

echo "Git instalado: $(git --version)"

# Paso 5: Instalar PM2
show_step "5. Instalando PM2..."
npm install -g pm2

echo "PM2 instalado: $(pm2 --version)"

# Paso 6: Clonar repositorio
show_step "6. Descargando el código del bot..."
cd /root

# Eliminar directorio si existe
if [ -d "peluqueria-whatsapp" ]; then
    show_warning "Eliminando instalación anterior..."
    rm -rf peluqueria-whatsapp
fi

# Clonar repositorio
git clone https://github.com/msilvapobas/peluqueria-whatsapp.git

# Entrar al directorio
cd peluqueria-whatsapp

# Paso 7: Instalar dependencias
show_step "7. Instalando dependencias del proyecto..."
npm install

# Paso 8: Configurar ambiente
show_step "8. Configurando ambiente de producción..."
cp .env.production .env

# Paso 9: Mostrar configuración actual
show_step "9. Configuración actual del .env:"
echo "=================================="
cat .env
echo "=================================="

# Paso 10: Preguntar por AUTH_TOKEN
show_warning "IMPORTANTE: Necesitas configurar tu AUTH_TOKEN"
echo ""
echo "Opciones:"
echo "1. Editar manualmente: nano .env"
echo "2. Usar token temporal: production-token-change-me"
echo ""
read -p "¿Quieres editar el .env ahora? (y/n): " edit_env

if [ "$edit_env" = "y" ] || [ "$edit_env" = "Y" ]; then
    nano .env
fi

# Paso 11: Iniciar aplicación
show_step "10. Iniciando aplicación con PM2..."

# Parar aplicación si existe
pm2 stop app-sebaarevalo-wapp 2>/dev/null || true
pm2 delete app-sebaarevalo-wapp 2>/dev/null || true

# Iniciar aplicación
pm2 start ecosystem.config.json --env production

# Configurar startup
pm2 startup systemd -u root --hp /root
pm2 save

# Paso 12: Verificar estado
show_step "11. Verificando instalación..."
echo ""
echo "Estado de la aplicación:"
pm2 status

echo ""
echo "Probando conexión local:"
sleep 3
curl -s http://localhost:3001/webhook || echo "La aplicación aún se está iniciando..."

# Paso 13: Mostrar comandos útiles
echo ""
echo "================================================================"
echo "✅ INSTALACIÓN COMPLETADA"
echo "================================================================"
echo ""
echo "🔧 Comandos útiles:"
echo "   pm2 status                      - Ver estado"
echo "   pm2 logs app-sebaarevalo-wapp   - Ver logs"
echo "   pm2 restart app-sebaarevalo-wapp - Reiniciar"
echo "   pm2 stop app-sebaarevalo-wapp   - Parar"
echo ""
echo "📁 Ubicación del proyecto:"
echo "   /root/peluqueria-whatsapp"
echo ""
echo "🔧 Configuración:"
echo "   nano /root/peluqueria-whatsapp/.env"
echo ""
echo "📊 Tu aplicación está corriendo en:"
echo "   http://localhost:3001"
echo ""

if [ "$edit_env" != "y" ] && [ "$edit_env" != "Y" ]; then
    show_warning "RECUERDA: Debes cambiar el AUTH_TOKEN en el archivo .env"
    echo "          Ejecuta: nano /root/peluqueria-whatsapp/.env"
fi

echo ""
echo "🎉 ¡Tu WhatsApp Bot está listo!"
