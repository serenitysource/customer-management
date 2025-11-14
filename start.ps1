# Quick Start Scripts - Run everything in Docker

# Start all services
Write-Host "Starting all services..." -ForegroundColor Cyan
docker-compose up -d

Write-Host ""
Write-Host "Services started!" -ForegroundColor Green
Write-Host "Application: http://localhost:8000" -ForegroundColor White
Write-Host ""
Write-Host "To view logs: docker-compose logs -f" -ForegroundColor Yellow
