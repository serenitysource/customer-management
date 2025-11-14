# QUICK REFERENCE CARD

## 🚀 First Time Setup
```powershell
.\setup.ps1
```
Then open: http://localhost:8000

## ⚡ Daily Commands

### Start Application
```powershell
.\start.ps1
```

### Stop Application  
```powershell
docker-compose down
```

### Stop and Remove Volumes
```powershell
docker-compose down -v
```

### Complete Cleanup (Remove Everything)
```powershell
# Stop containers and remove volumes
docker-compose down -v

# Remove built images
docker rmi customer-management-app

# Clean up all unused Docker resources (optional)
docker system prune -a --volumes
```

### Development Mode (Hot Reload)
```powershell
.\dev.ps1
```

## 🐳 Docker Commands

### View Running Containers
```powershell
docker-compose ps
```

### View Logs
```powershell
docker-compose logs -f        # All logs
docker-compose logs -f app    # Laravel only
docker-compose logs -f db     # MySQL only
```

### Restart Services
```powershell
docker-compose restart
docker-compose restart app    # Restart only Laravel
```

### Access Container Shell
```powershell
docker-compose exec app bash  # Laravel container
docker-compose exec node sh   # Node container
docker-compose exec db bash   # MySQL container
```

## 🎨 Laravel Commands (in Docker)

### Artisan
```powershell
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan route:list
docker-compose exec app php artisan tinker
```

### Composer
```powershell
docker-compose exec app composer install
docker-compose exec app composer require vendor/package
docker-compose exec app composer update
```

## 📦 Node Commands (in Docker)

### NPM
```powershell
docker-compose exec node npm install
docker-compose exec node npm run build
docker-compose exec node npm run dev
docker-compose exec node npm install package-name
```

## 🗄️ Database Commands

### Access MySQL
```powershell
docker-compose exec db mysql -u custmgmt_user -pcustmgmt_password custmgmt
```

### Common SQL Queries
```sql
-- View all categories
SELECT * FROM customer_categories;

-- View all customers
SELECT * FROM customers;

-- View customers with categories
SELECT c.*, cat.name as category_name 
FROM customers c 
JOIN customer_categories cat ON c.category_id = cat.id;

-- View all contacts
SELECT * FROM contacts;

-- Count customers by category
SELECT cat.name, COUNT(c.id) as customer_count 
FROM customer_categories cat 
LEFT JOIN customers c ON cat.id = c.category_id 
GROUP BY cat.id;

-- Exit MySQL
exit;
```

### Database Backup
```powershell
docker-compose exec db mysqldump -u custmgmt_user -pcustmgmt_password custmgmt > backup.sql
```

### Database Restore
```powershell
docker-compose exec -T db mysql -u custmgmt_user -pcustmgmt_password custmgmt < backup.sql
```

## 🔧 Troubleshooting

### Containers Won't Start
```powershell
docker-compose down
docker-compose up -d
docker-compose logs -f
```

### Port Already in Use
Edit `docker-compose.yml`:
```yaml
ports:
  - "8001:8000"  # Change first number
```

### Database Connection Failed
```powershell
docker-compose restart db
# Wait 10 seconds
docker-compose restart app
```

### Vue Changes Not Showing
```powershell
docker-compose exec node npm run build
docker-compose restart app
```

### Complete Reset
```powershell
docker-compose down -v
.\setup.ps1
```

### Clear All Docker Data
```powershell
docker-compose down -v --rmi all
docker system prune -a --volumes
```

## 📁 Project Structure

```
customer-management/
├── app/
│   ├── Http/Controllers/    # API controllers
│   └── Models/              # Eloquent models
├── database/
│   ├── migrations/          # Database schema
│   └── seeders/             # Data seeders
├── resources/
│   ├── js/
│   │   └── components/      # Vue components
│   ├── css/                 # Styles
│   └── views/               # Blade templates
├── routes/
│   ├── api.php             # API routes
│   └── web.php             # Web routes
├── docker-compose.yml       # Docker services
├── Dockerfile              # Laravel container
└── README.md               # Documentation
```

## 🌐 URLs

- **Application**: http://localhost:8000
- **Vite Dev Server**: http://localhost:5173 (dev mode)
- **MySQL**: localhost:3306

## 🔑 Default Credentials

### Database
- **Host**: db (inside Docker) or localhost (from Windows)
- **Port**: 3306
- **Database**: custmgmt
- **Username**: custmgmt_user
- **Password**: custmgmt_password

## 📝 API Endpoints

### Categories
- `GET /api/categories` - List all categories

### Customers
- `GET /api/customers?search=query` - List/search customers
- `POST /api/customers` - Create customer
- `GET /api/customers/{id}` - Get customer
- `PUT /api/customers/{id}` - Update customer
- `DELETE /api/customers/{id}` - Delete customer

### Contacts
- `GET /api/customers/{customerId}/contacts` - List contacts
- `POST /api/customers/{customerId}/contacts` - Create contact
- `PUT /api/contacts/{id}` - Update contact
- `DELETE /api/contacts/{id}` - Delete contact

## 🎯 Git Commands

### Initialize
```powershell
git init
git add .
git commit -m "Initial commit"
```

### Push to Remote
```powershell
git remote add origin <url>
git push -u origin main
```

## 💡 Tips

- Always run commands from project root
- Keep Docker Desktop running
- Use `.\dev.ps1` for development
- Use `.\start.ps1` for production mode
- Check logs if something fails
- Database takes ~10s to be ready first time

## 📚 Documentation Files

- **README.md** - Comprehensive guide
- **SETUP.md** - Quick start guide  
- **GIT_GUIDE.md** - Git and submission instructions
- **TESTING.md** - Complete testing checklist
- **PROJECT_SUMMARY.md** - Project overview
- **QUICK_REFERENCE.md** - This file

## ✅ Health Check

```powershell
# Check if everything is running
docker-compose ps

# Should show:
# custmgmt_app  -> Up
# custmgmt_db   -> Up  
# custmgmt_node -> Exited (normal)
```

## 🆘 Getting Help

1. Check logs: `docker-compose logs -f`
2. Review README.md
3. Try restart: `docker-compose restart`
4. Try reset: `docker-compose down -v` then `.\setup.ps1`

---
**Remember**: Everything runs in Docker - you don't need PHP, Composer, Node, or MySQL installed on Windows! 🎉
