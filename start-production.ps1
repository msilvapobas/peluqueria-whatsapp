# Script de inicio para producción del bot de WhatsApp (Windows)
# Uso: .\start-production.ps1

Write-Host "🚀 Iniciando bot de WhatsApp en modo PRODUCCIÓN..." -ForegroundColor Green

# Crear directorio de logs si no existe
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs"
    Write-Host "📁 Directorio logs creado" -ForegroundColor Yellow
}

# Verificar que PM2 esté instalado
$pm2Installed = Get-Command pm2 -ErrorAction SilentlyContinue
if (!$pm2Installed) {
    Write-Host "❌ PM2 no está instalado. Instalando..." -ForegroundColor Red
    npm install -g pm2
}

# Parar la aplicación si ya está corriendo
Write-Host "🛑 Deteniendo instancia anterior..." -ForegroundColor Yellow
pm2 stop whatsapp-bot 2>$null
pm2 delete whatsapp-bot 2>$null

# Instalar dependencias
Write-Host "📦 Instalando dependencias..." -ForegroundColor Cyan
npm install --production

# Verificar que existe el archivo .env
if (!(Test-Path ".env")) {
    Write-Host "❌ Archivo .env no encontrado" -ForegroundColor Red
    if (Test-Path ".env.production") {
        Write-Host "📝 Copiando template de producción..." -ForegroundColor Yellow
        Copy-Item ".env.production" ".env"
        Write-Host "⚠️  IMPORTANTE: Edita el archivo .env y configura AUTH_TOKEN" -ForegroundColor Red
        Write-Host "⚠️  Ejecuta: notepad .env" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "❌ No se encontró .env.production" -ForegroundColor Red
        exit 1
    }
}

# Iniciar con PM2
Write-Host "🎯 Iniciando aplicación con PM2..." -ForegroundColor Green
pm2 start ecosystem.config.json --env production

# Guardar configuración de PM2
pm2 save

# Mostrar status
Write-Host "✅ Aplicación iniciada!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Estado actual:" -ForegroundColor Cyan
pm2 status

Write-Host ""
Write-Host "📝 Comandos útiles:" -ForegroundColor Yellow
Write-Host "  Ver logs:     pm2 logs whatsapp-bot" -ForegroundColor White
Write-Host "  Ver status:   pm2 status" -ForegroundColor White
Write-Host "  Reiniciar:    pm2 restart whatsapp-bot" -ForegroundColor White
Write-Host "  Parar:        pm2 stop whatsapp-bot" -ForegroundColor White
Write-Host "  Monitoreo:    pm2 monit" -ForegroundColor White
