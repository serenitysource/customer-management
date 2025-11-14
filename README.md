# Customer Management System

A Laravel 11 + Vue.js application for managing customers and their contacts.

> **Quick Start**: Run `.\setup.ps1` in PowerShell, then open http://localhost:8000

## Features

- **Customer Management**: Create, read, update, and delete customers
- **Contact Management**: Manage contacts associated with each customer
- **Search Functionality**: Plain text search for customers
- **Category System**: Pre-seeded customer categories (Gold, Silver, Bronze)
- **Modal-based UI**: Clean, modern interface with modal forms
- **Dockerized**: Easy setup and deployment with Docker

## Tech Stack

- **Backend**: Laravel 11
- **Frontend**: Vue.js 3 with Composition API
- **Database**: MySQL 8.0
- **Styling**: Tailwind CSS
- **Containerization**: Docker & Docker Compose

## Prerequisites

**IMPORTANT: Everything runs in Docker - NO local installations required!**

- Docker Desktop (for Windows) - [Download here](https://www.docker.com/products/docker-desktop/)
- Git (optional, for version control)

That's it! No need to install PHP, Composer, Node.js, MySQL, or anything else on your Windows PC.

## Quick Start (Automated Setup)

### Option 1: Automated Setup (Recommended)

Run the automated setup script that handles everything:

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

**Linux/Mac (Bash):**
```bash
chmod +x setup.sh  # First time only
./setup.sh
```

This single command will:
1. Install Laravel 11 using Docker
2. Start all Docker containers
3. Install PHP and Node dependencies
4. Setup environment and generate app key
5. Run database migrations and seeders
6. Build frontend assets

**That's it!** Your application will be running at http://localhost:8000

### Option 2: Manual Setup (Step by Step)

If you prefer to run commands manually:

#### 1. Install Laravel (using Docker - no local Composer needed!)

```powershell
docker run --rm -v ${PWD}:/app -w /app composer:latest create-project laravel/laravel temp-laravel "11.*"
# Then move files from temp-laravel to current directory and delete temp-laravel
```

#### 2. Create Environment File

**IMPORTANT:** Before starting Docker, you must create the `.env` file:

```powershell
# Copy the example environment file
cp .env.example .env
```

This file contains essential configuration for the application to run.

#### 3. Start Docker Containers

```powershell
docker-compose up -d
```

This will start three containers:
- `custmgmt_app`: Laravel application (PHP 8.2)
- `custmgmt_db`: MySQL 8.0 database
- `custmgmt_node`: Node.js for Vite dev server

#### 4. Install Dependencies (all inside Docker)

```powershell
# Install PHP dependencies inside Docker
docker-compose exec app composer install

# Install Node dependencies inside Docker
docker-compose exec node npm install
```

#### 5. Setup Environment

```powershell
# Generate application key
docker-compose exec app php artisan key:generate
```

#### 6. Setup Database

```powershell
# Run migrations
docker-compose exec app php artisan migrate

# Seed the database (adds Gold, Silver, Bronze categories)
docker-compose exec app php artisan db:seed
```

#### 7. Build Frontend Assets

```powershell
# Build Vite assets inside Docker
docker-compose exec node npm run build
```

## Running the Application

### Production Mode (Quick Start)

**Windows:**
```powershell
.\start.ps1
```

**Linux/Mac:**
```bash
./start.sh
```

Or manually:
```bash
docker-compose up -d
```

Access your application at: **http://localhost:8000**

### Development Mode (with Hot Reload)

For development with Vite hot module replacement:

**Windows:**
```powershell
.\dev.ps1
```

**Linux/Mac:**
```bash
./dev.sh
```

Or manually:
```bash
# Start database and Laravel
docker-compose up -d db app

# Start Vite dev server with hot reload
docker-compose run --rm --service-ports node npm run dev
```

Access your application at: **http://localhost:8000**
The Vite dev server runs on port 5173 inside Docker.

## Stopping the Application

### Stop Containers (Keep Data)
```bash
docker-compose down
```

### Stop and Remove Volumes (Delete Database Data)
```bash
docker-compose down -v
```

### Complete Cleanup (Remove Everything)
To stop all containers, remove volumes, and delete built images:
```bash
# Stop containers and remove volumes
docker-compose down -v

# Remove the built images
docker rmi customer-management-app

# Optional: Clean up all unused Docker resources
docker system prune -a --volumes
```

**Warning:** The complete cleanup will delete all data and require rebuilding images on next setup.

## Database Schema

### Customers Table
- `id`: Primary key
- `name`: Customer name (required)
- `reference`: Customer reference code (required, unique)
- `category_id`: Foreign key to customer_categories
- `start_date`: Customer start date
- `description`: Text description

### Customer Categories Table
- `id`: Primary key
- `name`: Category name (Gold, Silver, Bronze)

### Contacts Table
- `id`: Primary key
- `customer_id`: Foreign key to customers
- `first_name`: Contact first name (required)
- `last_name`: Contact last name (required)

## API Endpoints

### Customers
- `GET /api/customers` - List all customers (with search)
- `POST /api/customers` - Create new customer
- `GET /api/customers/{id}` - Get customer details
- `PUT /api/customers/{id}` - Update customer
- `DELETE /api/customers/{id}` - Delete customer

### Contacts
- `GET /api/customers/{customerId}/contacts` - List customer contacts
- `POST /api/customers/{customerId}/contacts` - Create contact
- `PUT /api/contacts/{id}` - Update contact
- `DELETE /api/contacts/{id}` - Delete contact

### Categories
- `GET /api/categories` - List all customer categories

## Development Commands (All run inside Docker!)

```powershell
# Run tests
docker-compose exec app php artisan test

# Access Laravel container shell
docker-compose exec app bash

# Access Node container shell  
docker-compose exec node sh

# Run artisan commands
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:model MyModel

# Run npm commands
docker-compose exec node npm install <package>
docker-compose exec node npm run build

# View logs
docker-compose logs -f app      # Laravel logs
docker-compose logs -f node     # Node logs
docker-compose logs -f db       # MySQL logs

# Clear caches
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan view:clear

# Database commands
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec db mysql -u custmgmt_user -pcustmgmt_password custmgmt
```

## Project Structure

```
customer-management/
├── app/
│   ├── Http/Controllers/
│   │   ├── CustomerController.php
│   │   └── ContactController.php
│   └── Models/
│       ├── Customer.php
│       ├── CustomerCategory.php
│       └── Contact.php
├── database/
│   ├── migrations/
│   └── seeders/
├── resources/
│   ├── js/
│   │   ├── components/
│   │   │   ├── CustomerList.vue
│   │   │   ├── CustomerModal.vue
│   │   │   ├── ContactModal.vue
│   │   │   └── DeleteConfirmModal.vue
│   │   └── app.js
│   └── views/
├── routes/
│   ├── api.php
│   └── web.php
├── docker-compose.yml
├── Dockerfile
└── README.md
```

## Troubleshooting

### Port already in use
If ports 8000, 3306, or 5173 are already in use, modify the port mappings in `docker-compose.yml`.

### Permission issues
```bash
docker-compose exec app chown -R www-data:www-data /var/www/storage
docker-compose exec app chmod -R 775 /var/www/storage
```

### Database connection issues
Ensure the database container is running and healthy:
```bash
docker-compose ps
docker-compose logs db
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

## License

This project is for assessment purposes.
