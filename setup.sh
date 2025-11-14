#!/bin/bash

# Docker-Based Setup Guide
# All commands run inside Docker containers - no local installations needed!

echo "==================================="
echo "Customer Management Docker Setup"
echo "==================================="
echo ""

# Check if running on Windows
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ -n "$WINDIR" ]]; then
    echo "⚠️  WINDOWS DETECTED"
    echo ""
    echo "For Windows, please use PowerShell instead of Git Bash:"
    echo "  1. Open PowerShell in this directory"
    echo "  2. Run: .\\setup.ps1"
    echo ""
    echo "Git Bash on Windows has path conversion issues with Docker."
    echo ""
    exit 1
fi

# Check if Docker is running
echo "Checking if Docker is running..."
if ! docker info > /dev/null 2>&1; then
    echo ""
    echo "ERROR: Docker is not running!"
    echo ""
    echo "Please start Docker and try again:"
    echo "  1. Open Docker Desktop application (or start Docker service)"
    echo "  2. Wait for it to fully start"
    echo "  3. Run this script again: ./setup.sh"
    echo ""
    exit 1
fi

echo "✓ Docker is running"
echo ""

# Step 0: Create .env file if it doesn't exist
echo "Checking .env file..."
if [ ! -f ".env" ]; then
    cp ".env.example" ".env"
    echo "[OK] Created .env file from .env.example"
else
    echo "[OK] .env file already exists"
fi

echo ""

# Step 1: Start Docker containers
echo "Step 1: Starting Docker containers..."
echo "(This may take a few minutes if images need to be built)"
docker-compose up -d --build

if [ $? -ne 0 ]; then
    echo "Error: Failed to start Docker containers"
    exit 1
fi

echo ""
echo "Waiting for containers to initialize..."
sleep 5

echo "Checking container health..."
retries=0
maxRetries=30
allReady=false

while [ $retries -lt $maxRetries ]; do
    appStatus=$(docker inspect -f '{{.State.Status}}' custmgmt_app 2>/dev/null)
    dbStatus=$(docker inspect -f '{{.State.Status}}' custmgmt_db 2>/dev/null)
    
    if [ "$appStatus" = "running" ] && [ "$dbStatus" = "running" ]; then
        echo "[OK] All containers are running"
        allReady=true
        break
    fi
    
    retries=$((retries + 1))
    if [ $retries -le $maxRetries ]; then
        echo "Waiting for containers to be ready... ($retries/$maxRetries)"
        sleep 5
    fi
done

if [ "$allReady" = false ]; then
    echo "Warning: Containers may still be starting up"
    echo "Check container status with: docker-compose ps"
    echo "Check logs with: docker-compose logs -f"
    exit 1
fi

# Additional wait to ensure services are fully ready
echo "Waiting for services to initialize..."
sleep 10

# Step 2: Install PHP dependencies
echo ""
echo "Step 2: Installing PHP dependencies (Composer)..."
docker-compose exec -T app composer install

if [ $? -ne 0 ]; then
    echo "Error: Failed to install Composer dependencies"
    exit 1
fi

# Step 3: Install Node dependencies
echo ""
echo "Step 3: Installing Node.js dependencies (NPM)..."
docker-compose exec -T node npm install

if [ $? -ne 0 ]; then
    echo "Error: Failed to install NPM dependencies"
    exit 1
fi

# Step 4: Generate application key
echo ""
echo "Step 4: Generating application key..."
docker-compose exec -T app php artisan key:generate --force

# Step 5: Setup database
echo ""
echo "Step 5: Setting up database..."
echo "Waiting for MySQL to be ready..."

# Wait for MySQL to be ready
dbRetries=0
dbMaxRetries=12
dbReady=false

while [ $dbRetries -lt $dbMaxRetries ]; do
    if docker-compose exec -T db mysql -ucustmgmt_user -pcustmgmt_password -e "SELECT 1" > /dev/null 2>&1; then
        echo "[OK] MySQL is ready"
        dbReady=true
        break
    fi
    dbRetries=$((dbRetries + 1))
    echo "Waiting for MySQL... ($dbRetries/$dbMaxRetries)"
    sleep 5
done

if [ "$dbReady" = false ]; then
    echo "Warning: MySQL may not be ready, attempting migration anyway..."
fi

docker-compose exec -T app php artisan migrate --force

if [ $? -ne 0 ]; then
    echo "Warning: Migration had issues, retrying..."
    sleep 5
    docker-compose exec -T app php artisan migrate --force
fi

docker-compose exec -T app php artisan db:seed --force

# Step 6: Build frontend assets
echo ""
echo "Step 6: Building frontend assets..."
docker-compose exec -T node npm run build

if [ $? -ne 0 ]; then
    echo "Error: Failed to build frontend assets"
    exit 1
fi

echo ""
echo "==================================="
echo "Setup Complete!"
echo "==================================="
echo ""
echo "Your application is ready!"
echo ""
echo "Access your application at: http://localhost:8000"
echo ""
echo "Useful commands:"
echo "  docker-compose logs -f app    # View Laravel logs"
echo "  docker-compose exec app bash  # Access Laravel container"
echo "  docker-compose exec node sh   # Access Node container"
echo "  docker-compose down           # Stop all containers"
echo ""
