# SETUP INSTRUCTIONS - EVERYTHING IN DOCKER

## What You Need
- Docker Desktop for Windows (download from https://www.docker.com/products/docker-desktop/)
- That's it! No PHP, Node.js, Composer, or MySQL needed on your PC!

## Quick Start (3 Steps)

### Step 1: Run Setup Script

**Windows (PowerShell - RECOMMENDED):**
```powershell
.\setup.ps1
```

> ⚠️ **Windows Users:** Use PowerShell, not Git Bash. Git Bash has Docker path issues on Windows.

**Linux/Mac (Bash):**
```bash
chmod +x setup.sh  # First time only
./setup.sh
```

This will:
- Download and install Laravel 11 (inside Docker)
- Install all PHP dependencies (inside Docker)
- Install all Node.js dependencies (inside Docker)
- Setup database with migrations and seeds
- Build frontend assets

### Step 2: Wait for Completion
The script will take a few minutes. You'll see progress messages.

### Step 3: Open Your Browser
Go to: http://localhost:8000

That's it! The application is running entirely in Docker containers.

## Daily Usage

### Start the Application

**Windows:**
```powershell
.\start.ps1
```

**Linux/Mac:**
```bash
./start.sh
```

Then open: http://localhost:8000

### Stop the Application

**Windows:**
```powershell
docker-compose down
```

**Linux/Mac:**
```bash
./stop.sh
# or
docker-compose down
```

### Development Mode (with hot reload)

**Windows:**
```powershell
.\dev.ps1
```

**Linux/Mac:**
```bash
./dev.sh
```

## Troubleshooting

### "Port already in use" error
If you see this error, another application is using ports 8000, 3306, or 5173.

Solution: Stop other applications or edit docker-compose.yml to change ports:
```yaml
ports:
  - "8001:8000"  # Change 8001 to any free port
```

### Database connection error
Wait a bit longer - MySQL takes ~10-15 seconds to start first time.

Or restart:
```powershell
docker-compose restart
```

### Changes not showing
If you're in development mode and changes aren't appearing:
```powershell
docker-compose exec node npm run build
docker-compose restart app
```

### View what's happening
```powershell
docker-compose logs -f
```

### Complete reset
```powershell
docker-compose down -v
.\setup.ps1
```

## Understanding the Architecture

All three services run in Docker:

1. **slipstream_app** - Laravel (PHP 8.2) on port 8000
2. **slipstream_db** - MySQL 8.0 on port 3306  
3. **slipstream_node** - Node.js 18 for building Vue.js

Everything is isolated in containers. Your Windows PC only needs Docker!

## Common Tasks

### Add a new PHP package
```powershell
docker-compose exec app composer require vendor/package
```

### Add a new npm package
```powershell
docker-compose exec node npm install package-name
```

### Create a new migration
```powershell
docker-compose exec app php artisan make:migration create_table_name
```

### Run migrations
```powershell
docker-compose exec app php artisan migrate
```

### Access database directly
```powershell
docker-compose exec db mysql -u slipstream_user -pslipstream_password slipstream
```

## For Git Repository

After testing, create a git repository:

```powershell
git init
git add .
git commit -m "Initial commit: Fresh Laravel 11 installation"
git add .
git commit -m "Add customer and contact management features"
git remote add origin <your-repo-url>
git push -u origin main
```

Remember to add mlambley@gmail.com to your private repository if needed.

## Support

If you encounter issues:
1. Check Docker Desktop is running
2. Check logs: `docker-compose logs -f`
3. Try restarting: `docker-compose restart`
4. Try complete reset: `docker-compose down -v` then `.\setup.ps1`
