# Installation Guide for Fresh Clone

This guide is for users who have just cloned this repository from GitHub.

## Prerequisites

- **Docker Desktop** (Windows/Mac) or **Docker** (Linux)
- **Git** (to clone the repository)

**That's it!** No PHP, Composer, Node.js, or MySQL installation needed.

## Step-by-Step Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd customer-management
```

### 2. Run Setup Script

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

**Linux/Mac:**
```bash
chmod +x setup.sh
./setup.sh
```

### 3. Wait for Completion

The setup script will automatically:
- ✅ Start Docker containers (Laravel, MySQL, Node.js)
- ✅ Install PHP dependencies with Composer
- ✅ Install Node.js dependencies with NPM
- ✅ Create and configure `.env` file
- ✅ Generate application key
- ✅ Run database migrations
- ✅ Seed database with categories (Gold, Silver, Bronze)
- ✅ Build frontend assets with Vite

This takes 3-5 minutes on first run.

### 4. Access the Application

Open your browser:
**http://localhost:8000**

You should see the Customer Management application!

## Verification

To verify everything is working:

**Windows:**
```powershell
.\test.ps1
```

This will check:
- Docker containers are running
- Database is accessible
- Tables are created
- Data is seeded
- Frontend assets are built
- Application responds

## What Gets Installed

When you clone from GitHub, you get:
- ✅ Source code (app/, resources/, routes/, database/)
- ✅ Configuration files (Docker, Vite, Tailwind)
- ✅ Documentation
- ✅ Setup scripts

What's **NOT** in the repository (installed by setup):
- `vendor/` - PHP dependencies (installed via Composer)
- `node_modules/` - Node.js dependencies (installed via NPM)
- `public/build/` - Built frontend assets (built via Vite)
- `.env` - Environment file (created from .env.example)

## Common Issues

### Port Already in Use

If port 8000, 3306, or 5173 is already in use:

Edit `docker-compose.yml`:
```yaml
services:
  app:
    ports:
      - "8001:8000"  # Change 8001 to any free port
```

### Database Connection Error

Wait a bit longer - MySQL takes 10-15 seconds to start on first run.

Or restart:
```bash
docker-compose restart
```

### Permission Errors (Linux/Mac)

If you get permission errors:
```bash
sudo chmod -R 777 storage bootstrap/cache
```

### Docker Not Running

Make sure Docker Desktop is running:
- Windows/Mac: Open Docker Desktop application
- Linux: `sudo systemctl start docker`

## Daily Usage

### Start Application
```powershell
.\start.ps1    # Windows
./start.sh     # Linux/Mac
```

### Stop Application
```bash
docker-compose down
```

### View Logs
```bash
docker-compose logs -f
docker-compose logs -f app   # Laravel only
```

### Reset Database
```bash
docker-compose exec app php artisan migrate:fresh --seed
```

### Rebuild Frontend
```bash
docker-compose exec node npm run build
```

## Complete Reset

If something goes wrong and you want to start fresh:

```bash
# Stop and remove everything
docker-compose down -v

# Run setup again
.\setup.ps1    # Windows
./setup.sh     # Linux/Mac
```

## Development Mode

For hot reload while developing:

**Windows:**
```powershell
.\dev.ps1
```

**Linux/Mac:**
```bash
./dev.sh
```

Changes to Vue components will automatically reload in the browser!

## File Structure

```
customer-management/
├── app/                    # Laravel application code
│   ├── Http/Controllers/   # API controllers
│   ├── Models/            # Eloquent models
│   └── Providers/         # Service providers
├── database/
│   ├── migrations/        # Database schema
│   └── seeders/           # Data seeders
├── resources/
│   ├── js/
│   │   └── components/    # Vue.js components
│   ├── css/               # Tailwind CSS
│   └── views/             # Blade templates
├── routes/
│   ├── api.php           # API routes
│   └── web.php           # Web routes
├── docker-compose.yml     # Docker orchestration
├── Dockerfile            # Laravel container config
├── setup.ps1 / setup.sh  # Setup scripts
└── README.md             # Documentation
```

## Need Help?

1. Check logs: `docker-compose logs -f`
2. Verify containers: `docker-compose ps`
3. Run test: `.\test.ps1` (Windows)
4. Review README.md for detailed documentation
5. Check TESTING.md for feature testing guide

## Next Steps

- Read [TESTING.md](TESTING.md) for testing checklist
- Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for command reference
- Start creating customers and contacts!

---

**Everything runs in Docker - your Windows/Mac/Linux system stays clean!** 🎉
