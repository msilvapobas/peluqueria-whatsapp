# Quick Start Script para Windows
# Uso: .\quick-deploy.ps1

Write-Host "🚀 Quick Deploy - Peluquería WhatsApp Bot" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan

# Verificar si estamos en el directorio correcto
if (!(Test-Path "app.js")) {
    Write-Host "❌ Error: Ejecuta este script desde el directorio del proyecto" -ForegroundColor Red
    exit 1
}

# Función para mostrar comandos
function Show-Command {
    param($description, $command)
    Write-Host ""
    Write-Host "📝 $description" -ForegroundColor Yellow
    Write-Host "   $command" -ForegroundColor White
}

Write-Host ""
Write-Host "📋 Pasos para hacer deployment:" -ForegroundColor Cyan

Show-Command "1. Subir código a GitHub:" "git add . && git commit -m 'Update bot' && git push origin main"

Show-Command "2. Conectar a tu VPS:" "ssh usuario@tu-vps-ip"

Show-Command "3. Primer deployment:" "wget https://raw.githubusercontent.com/TU_USUARIO/peluqueria-whatsapp/main/deploy-vps.sh && chmod +x deploy-vps.sh && ./deploy-vps.sh"

Show-Command "4. Actualizaciones futuras:" "./deploy-vps.sh"

Write-Host ""
Write-Host "⚙️  Comandos útiles en VPS:" -ForegroundColor Cyan

Show-Command "Ver estado:" "pm2 status"
Show-Command "Ver logs:" "pm2 logs app-sebaarevalo-wapp"
Show-Command "Reiniciar:" "pm2 restart app-sebaarevalo-wapp"
Show-Command "Parar:" "pm2 stop app-sebaarevalo-wapp"

Write-Host ""
Write-Host "🔧 Configuración importante:" -ForegroundColor Yellow
Write-Host "   1. Edita deploy-vps.sh y cambia REPO_URL por tu repositorio" -ForegroundColor White
Write-Host "   2. En el VPS, configura .env con tu AUTH_TOKEN real" -ForegroundColor White
Write-Host "   3. Asegúrate de tener certificados SSL configurados" -ForegroundColor White

Write-Host ""
Write-Host "📖 Para más detalles, lee DEPLOYMENT.md" -ForegroundColor Cyan

# Preguntar si quiere hacer git add/commit/push ahora
Write-Host ""
$response = Read-Host "¿Quieres hacer commit y push ahora? (y/n)"
if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "📤 Subiendo cambios a GitHub..." -ForegroundColor Green
    git add .
    $message = Read-Host "Mensaje del commit (o presiona Enter para usar 'Update bot configuration')"
    if ([string]::IsNullOrWhiteSpace($message)) {
        $message = "Update bot configuration"
    }
    git commit -m $message
    git push origin main
    Write-Host "✅ Cambios subidos a GitHub!" -ForegroundColor Green
} else {
    Write-Host "⏸️  Recuerda hacer commit y push antes del deployment" -ForegroundColor Yellow
}
