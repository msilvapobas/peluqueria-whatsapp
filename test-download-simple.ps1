# Test deployment script download from GitHub
Write-Host "Testing deployment script download from GitHub..." -ForegroundColor Green

$url = "https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh"
$outputFile = "deploy-vps-test.sh"

Write-Host "URL: $url" -ForegroundColor Cyan

try {
    Write-Host "Downloading..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $url -OutFile $outputFile -ErrorAction Stop
    
    Write-Host "Download successful!" -ForegroundColor Green
    
    $fileInfo = Get-Item $outputFile
    Write-Host "File size: $($fileInfo.Length) bytes" -ForegroundColor White
    
    Write-Host "First 5 lines of downloaded script:" -ForegroundColor Yellow
    Get-Content $outputFile -Head 5
    
    Write-Host ""
    Write-Host "SUCCESS! You can now deploy to VPS using:" -ForegroundColor Green
    Write-Host "curl -L -o deploy-vps.sh $url" -ForegroundColor Cyan
    Write-Host "chmod +x deploy-vps.sh" -ForegroundColor Cyan
    Write-Host "./deploy-vps.sh" -ForegroundColor Cyan
    
} catch {
    Write-Host "Download failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

if (Test-Path $outputFile) {
    Remove-Item $outputFile
    Write-Host "Test file cleaned up" -ForegroundColor Gray
}
