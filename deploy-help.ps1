# Quick Start Script para Windows
# Uso: .\deploy-help.ps1

Write-Host "Quick Deploy - Peluqueria WhatsApp Bot" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Cyan

# Verificar si estamos en el directorio correcto
if (!(Test-Path "app.js")) {
    Write-Host "Error: Ejecuta este script desde el directorio del proyecto" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Pasos para hacer deployment:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Subir codigo a GitHub:" -ForegroundColor Yellow
Write-Host "   git add ." -ForegroundColor White
Write-Host "   git commit -m 'Update bot'" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor White
Write-Host ""

Write-Host "2. Conectar a tu VPS:" -ForegroundColor Yellow
Write-Host "   ssh usuario@tu-vps-ip" -ForegroundColor White
Write-Host ""

Write-Host "3. Primer deployment en VPS:" -ForegroundColor Yellow
Write-Host "   wget https://raw.githubusercontent.com/TU_USUARIO/peluqueria-whatsapp/main/deploy-vps.sh" -ForegroundColor White
Write-Host "   chmod +x deploy-vps.sh" -ForegroundColor White
Write-Host "   ./deploy-vps.sh" -ForegroundColor White
Write-Host ""

Write-Host "4. Actualizaciones futuras:" -ForegroundColor Yellow
Write-Host "   ./deploy-vps.sh" -ForegroundColor White
Write-Host ""

Write-Host "Comandos utiles en VPS:" -ForegroundColor Cyan
Write-Host "   pm2 status" -ForegroundColor White
Write-Host "   pm2 logs app-sebaarevalo-wapp" -ForegroundColor White
Write-Host "   pm2 restart app-sebaarevalo-wapp" -ForegroundColor White
Write-Host "   pm2 stop app-sebaarevalo-wapp" -ForegroundColor White
Write-Host ""

Write-Host "Configuracion importante:" -ForegroundColor Yellow
Write-Host "   1. Edita deploy-vps.sh y cambia REPO_URL por tu repositorio" -ForegroundColor White
Write-Host "   2. En el VPS, configura .env con tu AUTH_TOKEN real" -ForegroundColor White
Write-Host "   3. Asegurate de tener certificados SSL configurados" -ForegroundColor White
Write-Host ""

Write-Host "Para mas detalles, lee DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""

# Preguntar si quiere hacer git add/commit/push ahora
$response = Read-Host "Quieres hacer commit y push ahora? (y/n)"
if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "Subiendo cambios a GitHub..." -ForegroundColor Green
    git add .
    $message = Read-Host "Mensaje del commit (o presiona Enter para usar 'Update bot configuration')"
    if ([string]::IsNullOrWhiteSpace($message)) {
        $message = "Update bot configuration"
    }
    git commit -m $message
    git push origin main
    Write-Host "Cambios subidos a GitHub!" -ForegroundColor Green
} else {
    Write-Host "Recuerda hacer commit y push antes del deployment" -ForegroundColor Yellow
}
