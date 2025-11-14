#!/bin/bash

# Docker-Based Setup Guide
# All commands run inside Docker containers - no local installations needed!

echo "==================================="
echo "Slipstream Docker Setup"
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

# Step 1: Start Docker containers
echo "Step 1: Starting Docker containers..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "Error: Failed to start Docker containers"
    exit 1
fi

echo ""
echo "Waiting for containers to be ready..."
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

# Step 4: Setup environment
echo ""
echo "Step 4: Setting up environment..."

if [ ! -f ".env" ]; then
    docker-compose exec -T app cp .env.example .env
    echo "✓ Created .env file"
else
    echo "✓ .env file already exists"
fi

docker-compose exec -T app php artisan key:generate --force

# Step 5: Setup database
echo ""
echo "Step 5: Setting up database..."
echo "Waiting for MySQL to be ready..."
sleep 5

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
