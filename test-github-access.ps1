# Test GitHub repository accessibility
Write-Host "Testing GitHub repository accessibility..." -ForegroundColor Green

# Test 1: Check if repository is accessible via API
$repoApiUrl = "https://api.github.com/repos/msilvapobas/peluqueria-whatsapp"
Write-Host "Testing repository API: $repoApiUrl" -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri $repoApiUrl -ErrorAction Stop
    Write-Host "Repository is accessible!" -ForegroundColor Green
    Write-Host "Visibility: $($response.visibility)" -ForegroundColor Yellow
    Write-Host "Default branch: $($response.default_branch)" -ForegroundColor Yellow
} catch {
    Write-Host "Repository API failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Check the contents API for deploy-vps.sh
$contentsUrl = "https://api.github.com/repos/msilvapobas/peluqueria-whatsapp/contents/deploy-vps.sh"
Write-Host "`nTesting file contents API: $contentsUrl" -ForegroundColor Cyan

try {
    $fileResponse = Invoke-RestMethod -Uri $contentsUrl -ErrorAction Stop
    Write-Host "File found in repository!" -ForegroundColor Green
    Write-Host "File size: $($fileResponse.size) bytes" -ForegroundColor Yellow
    Write-Host "Download URL: $($fileResponse.download_url)" -ForegroundColor Yellow
} catch {
    Write-Host "File API failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Try the raw URL directly
$rawUrl = "https://raw.githubusercontent.com/msilvapobas/peluqueria-whatsapp/main/deploy-vps.sh"
Write-Host "`nTesting raw URL: $rawUrl" -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri $rawUrl -Method Head -ErrorAction Stop
    Write-Host "Raw URL is accessible!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Yellow
} catch {
    Write-Host "Raw URL failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "HTTP Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}
