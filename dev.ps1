# Development mode with hot reload
Write-Host "Starting development mode with hot reload..." -ForegroundColor Cyan
Write-Host ""

# Start database and app
docker-compose up -d db app

Write-Host "Starting Vite dev server for hot reload..." -ForegroundColor Yellow
docker-compose run --rm --service-ports node npm run dev
