# Slipstream Laravel Setup Script for Windows

Write-Host "===================================" -ForegroundColor Green
Write-Host "Slipstream Laravel Setup" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# Check if composer is installed
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Composer is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Composer from https://getcomposer.org/" -ForegroundColor Yellow
    exit 1
}

# Install Laravel 11
Write-Host "`nInstalling Laravel 11..." -ForegroundColor Cyan
composer create-project laravel/laravel temp-laravel "11.*"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install Laravel" -ForegroundColor Red
    exit 1
}

# Move Laravel files to current directory
Write-Host "`nMoving Laravel files to current directory..." -ForegroundColor Cyan

# Get all items from temp-laravel
$items = Get-ChildItem -Path "temp-laravel" -Force

foreach ($item in $items) {
    $destination = Join-Path -Path (Get-Location) -ChildPath $item.Name
    
    # Skip if destination already exists and is one of our files
    if ((Test-Path $destination) -and ($item.Name -in @('docker-compose.yml', 'Dockerfile', 'README.md', '.gitignore', '.dockerignore'))) {
        Write-Host "Keeping existing $($item.Name)" -ForegroundColor Yellow
        continue
    }
    
    Move-Item -Path $item.FullName -Destination $destination -Force
}

# Remove temporary directory
Remove-Item -Path "temp-laravel" -Recurse -Force

Write-Host "`nLaravel 11 installed successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Review the README.md for setup instructions" -ForegroundColor White
Write-Host "2. Start Docker containers: docker-compose up -d" -ForegroundColor White
Write-Host "3. Setup environment and database (see README.md)" -ForegroundColor White
