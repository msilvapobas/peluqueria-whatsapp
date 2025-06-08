# Scripts para gestionar entornos
# Ejecutar desde PowerShell

# Para desarrollo
function Set-DevEnv {
    Copy-Item ".env.development" ".env" -Force
    Write-Host "✅ Configurado para DESARROLLO" -ForegroundColor Green
    Write-Host "Puerto: 3000, Token: dev-token-local-123" -ForegroundColor Yellow
}

# Para producción (solo como referencia)
function Set-ProdEnv {
    Copy-Item ".env.production" ".env" -Force
    Write-Host "⚠️  Configurado para PRODUCCIÓN" -ForegroundColor Red
    Write-Host "🔧 RECUERDA: Editar .env y cambiar AUTH_TOKEN por un valor real" -ForegroundColor Yellow
}

# Uso:
# . .\env-scripts.ps1
# Set-DevEnv
# Set-ProdEnv
