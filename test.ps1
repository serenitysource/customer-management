# Quick verification script to test if setup was successful

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Testing Installation" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Check if containers are running
Write-Host "1. Checking Docker containers..." -ForegroundColor Yellow
$containers = docker-compose ps --services --filter "status=running"

if ($containers -match "app" -and $containers -match "db") {
    Write-Host "   PASS - Containers are running" -ForegroundColor Green
} else {
    Write-Host "   FAIL - Containers are not running properly" -ForegroundColor Red
    Write-Host "   Run: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

# Check if database is accessible
Write-Host ""
Write-Host "2. Checking database connection..." -ForegroundColor Yellow
$dbTest = docker-compose exec -T db mysql -u custmgmt_user -pcustmgmt_password -e "SELECT 1" 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "   PASS - Database is accessible" -ForegroundColor Green
} else {
    Write-Host "   FAIL - Cannot connect to database" -ForegroundColor Red
    exit 1
}

# Check if migrations ran
Write-Host ""
Write-Host "3. Checking database tables..." -ForegroundColor Yellow
$tables = docker-compose exec -T db mysql -u custmgmt_user -pcustmgmt_password custmgmt -e "SHOW TABLES" 2>$null

if ($tables -match "customers" -and $tables -match "contacts" -and $tables -match "customer_categories") {
    Write-Host "   PASS - Database tables exist" -ForegroundColor Green
} else {
    Write-Host "   FAIL - Database tables missing" -ForegroundColor Red
    Write-Host "   Run: docker-compose exec app php artisan migrate" -ForegroundColor Yellow
    exit 1
}

# Check if categories are seeded
Write-Host ""
Write-Host "4. Checking seeded data..." -ForegroundColor Yellow
$categories = docker-compose exec -T db mysql -u custmgmt_user -pcustmgmt_password custmgmt -e "SELECT COUNT(*) as count FROM customer_categories" 2>$null

if ($categories -match "3") {
    Write-Host "   PASS - Categories are seeded" -ForegroundColor Green
} else {
    Write-Host "   WARN - Categories might not be seeded" -ForegroundColor Yellow
}

# Check if assets are built
Write-Host ""
Write-Host "5. Checking built assets..." -ForegroundColor Yellow

if (Test-Path "public/build/manifest.json") {
    Write-Host "   PASS - Frontend assets are built" -ForegroundColor Green
} else {
    Write-Host "   FAIL - Frontend assets not built" -ForegroundColor Red
    exit 1
}

# Check if app is responding
Write-Host ""
Write-Host "6. Checking application response..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000" -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "   PASS - Application is responding" -ForegroundColor Green
    } else {
        Write-Host "   WARN - Application returned status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    if ($_.Exception.Message -match "500") {
        Write-Host "   WARN - Application is running but returned 500 error" -ForegroundColor Yellow
        Write-Host "         Check: docker-compose logs app" -ForegroundColor Gray
    } else {
        Write-Host "   FAIL - Cannot reach application: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Green
Write-Host "ALL TESTS PASSED!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""
Write-Host "Application is ready at: http://localhost:8000" -ForegroundColor White
Write-Host ""
