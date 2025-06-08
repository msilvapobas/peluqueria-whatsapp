# Test deployment script download from GitHub
# This simulates what will happen on the VPS

Write-Host "Testing deployment script download from GitHub..." -ForegroundColor Green

$url = "https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh"
$outputFile = "deploy-vps-test.sh"

Write-Host "URL: $url" -ForegroundColor Cyan

try {
    Write-Host "Downloading..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $url -OutFile $outputFile -ErrorAction Stop
    
    Write-Host "Download successful!" -ForegroundColor Green
    
    # Check file size and content
    $fileInfo = Get-Item $outputFile
    Write-Host "File size: $($fileInfo.Length) bytes" -ForegroundColor White
    
    # Show first few lines
    Write-Host "First 10 lines of downloaded script:" -ForegroundColor Yellow
    Get-Content $outputFile -Head 10
    
    Write-Host ""
    Write-Host "Download test completed successfully!" -ForegroundColor Green
    Write-Host "You can now use this command on your VPS:" -ForegroundColor Cyan
    Write-Host "   curl -L -o deploy-vps.sh $url" -ForegroundColor White
    Write-Host "   chmod +x deploy-vps.sh" -ForegroundColor White
    Write-Host "   ./deploy-vps.sh" -ForegroundColor White
    
} catch {
    Write-Host "❌ Download failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try to get more info about the error
    if ($_.Exception.Response) {
        Write-Host "HTTP Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Clean up test file
if (Test-Path $outputFile) {
    Remove-Item $outputFile
    Write-Host "🧹 Test file cleaned up" -ForegroundColor Gray
}
