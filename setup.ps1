# Docker-Based Setup Guide
# All commands run inside Docker containers - no local installations needed!

Write-Host "===================================" -ForegroundColor Green
Write-Host "Slipstream Docker Setup" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""

# Check if Docker is running
Write-Host "Checking if Docker is running..." -ForegroundColor Cyan
try {
    docker info | Out-Null 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not running"
    }
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop and try again:" -ForegroundColor Yellow
    Write-Host "  1. Open Docker Desktop application" -ForegroundColor White
    Write-Host "  2. Wait for it to fully start (whale icon in system tray)" -ForegroundColor White
    Write-Host "  3. Run this script again: .\setup.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""

# Step 1: Start Docker containers
Write-Host "Step 1: Starting Docker containers..." -ForegroundColor Cyan
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to start Docker containers" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Waiting for containers to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Step 2: Install PHP dependencies
Write-Host "Step 2: Starting Docker containers..." -ForegroundColor Cyan
docker-compose up -d

Write-Host ""
Write-Host "Waiting for containers to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Step 2: Install PHP dependencies
Write-Host ""
Write-Host "Step 2: Installing PHP dependencies (Composer)..." -ForegroundColor Cyan
docker-compose exec -T app composer install

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install Composer dependencies" -ForegroundColor Red
    exit 1
}

# Step 3: Install Node dependencies
Write-Host ""
Write-Host "Step 3: Installing Node.js dependencies (NPM)..." -ForegroundColor Cyan
docker-compose exec -T node npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install NPM dependencies" -ForegroundColor Red
    exit 1
}

# Step 4: Setup environment
Write-Host ""
Write-Host "Step 4: Setting up environment..." -ForegroundColor Cyan

if (-not (Test-Path ".env")) {
    docker-compose exec -T app cp .env.example .env
    Write-Host "✓ Created .env file" -ForegroundColor Green
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Yellow
}

docker-compose exec -T app php artisan key:generate --force

# Step 5: Setup database
Write-Host ""
Write-Host "Step 5: Setting up database..." -ForegroundColor Cyan
Write-Host "Waiting for MySQL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

docker-compose exec -T app php artisan migrate --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Migration had issues, retrying..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    docker-compose exec -T app php artisan migrate --force
}

docker-compose exec -T app php artisan db:seed --force

# Step 6: Build frontend assets
Write-Host ""
Write-Host "Step 6: Building frontend assets..." -ForegroundColor Cyan
docker-compose exec -T node npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to build frontend assets" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your application is ready!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access your application at: http://localhost:8000" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  docker-compose logs -f app    # View Laravel logs" -ForegroundColor White
Write-Host "  docker-compose exec app bash  # Access Laravel container" -ForegroundColor White
Write-Host "  docker-compose exec node sh   # Access Node container" -ForegroundColor White
Write-Host "  docker-compose down           # Stop all containers" -ForegroundColor White
Write-Host ""
