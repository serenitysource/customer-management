# Git Setup and Submission Guide

## Step 1: Test Your Application

Before creating the repository, make sure everything works:

```powershell
# Run setup
.\setup.ps1

# Open browser to http://localhost:8000
# Test creating/editing/deleting customers and contacts
```

## Step 2: Initialize Git Repository

```powershell
# Initialize git
git init

# Check what will be committed
git status
```

## Step 3: First Commit - Fresh Laravel

Following the deliverable requirements, commit fresh Laravel first:

```powershell
# Stage only Laravel base files (this simulates fresh install)
git add artisan
git add bootstrap/
git add config/
git add public/
git add storage/
git add tests/
git add composer.json
git add composer.lock
git add .editorconfig
git add .env.example
git add phpunit.xml

# First commit
git commit -m "Install fresh copy of Laravel 11"
```

## Step 4: Second Commit - Your Changes

Now add all your customizations:

```powershell
# Add everything else
git add .

# Commit your changes
git commit -m "Add customer and contact management system

Features:
- Customer CRUD with search functionality
- Contact management within customer modal
- Category system (Gold, Silver, Bronze)
- RESTful API with Laravel controllers
- Vue.js 3 frontend with Tailwind CSS
- Dockerized setup for easy deployment
- Comprehensive documentation"
```

## Step 5: Create Remote Repository

### Option A: GitHub

1. Go to https://github.com/new
2. Create a new repository (public or private)
3. Copy the repository URL

### Option B: Bitbucket

1. Go to https://bitbucket.org/repo/create
2. Create a new repository (public or private)
3. Copy the repository URL

## Step 6: Push to Remote

```powershell
# Add remote (replace with your actual URL)
git remote add origin https://github.com/yourusername/customer-management.git

# Push commits
git push -u origin main

# If using 'master' instead of 'main':
# git branch -M main
# git push -u origin main
```

## Step 7: Add Collaborator (if private)

If your repository is private:

### GitHub:
1. Go to repository Settings → Collaborators
2. Click "Add people"
3. Enter: mlambley@gmail.com
4. Send invitation

### Bitbucket:
1. Go to repository Settings → User and group access
2. Add user: mlambley@gmail.com
3. Give "Read" or "Write" access

## Step 8: Verify Repository

Make sure your repository includes:
- ✅ README.md with installation instructions
- ✅ All source code
- ✅ Docker configuration
- ✅ Two commits (fresh Laravel + your changes)
- ✅ .gitignore properly excluding vendor, node_modules, etc.

## Step 9: Email Notification

Send email to the assessment contact with:

**Subject**: Customer Management System - Completed

**Body**:
```
Hi,

I have completed the customer management system.

Repository URL: [your-github/bitbucket-url]

The repository includes:
- Fresh Laravel 11 installation (first commit)
- Customer and contact management system (second commit)
- Complete Docker setup for easy local testing
- Comprehensive README with setup instructions

The application features:
✓ Customer CRUD operations
✓ Contact management within customer modals
✓ Search functionality
✓ Category system (Gold, Silver, Bronze)
✓ Vue.js 3 frontend with Tailwind CSS
✓ RESTful API architecture
✓ Fully Dockerized - no local dependencies required

To run the project:
1. Ensure Docker Desktop is running
2. Run: .\setup.ps1
3. Open: http://localhost:8000

Please let me know if you need any clarification.

Best regards,
[Your Name]
```

## Common Git Commands

```powershell
# Check status
git status

# View commit history
git log --oneline

# Create a new branch
git checkout -b feature-name

# Add specific files
git add path/to/file

# Amend last commit
git commit --amend

# View changes
git diff

# Discard changes
git checkout -- filename
```

## Troubleshooting

### Large files warning
If git warns about large files:
```powershell
# Check .gitignore includes:
# /node_modules
# /vendor
# *.pdf
```

### Wrong files committed
```powershell
# Remove from staging
git reset HEAD filename

# Or reset last commit (keeps changes)
git reset --soft HEAD~1
```

### Forgot to add something
```powershell
# Add the file
git add forgotten-file.txt

# Amend the commit
git commit --amend --no-edit
```

## Final Checklist

Before submitting:
- ✅ Tested application locally with Docker
- ✅ README.md is clear and complete
- ✅ Two commits: fresh Laravel + features
- ✅ Repository is accessible (public or collaborator added)
- ✅ .gitignore properly configured
- ✅ No sensitive data (passwords, keys) in commits
- ✅ All features from requirements implemented
- ✅ Email sent with repository link

Good luck! 🚀
