# 🚀 Complete Installation & Setup Instructions

## DSO101 - Todo List Application with CI/CD

---

## 📋 Table of Contents
1. [Quick Overview](#quick-overview)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Project Setup (Step by Step)](#project-setup-step-by-step)
4. [Local Development](#local-development)
5. [Docker Hub Deployment (Part A)](#docker-hub-deployment-part-a)
6. [Automated CI/CD (Part B)](#automated-cicd-part-b)
7. [Verification Checklist](#verification-checklist)

---

## 🎯 Quick Overview

This project is a full-stack Todo application with:
- **Frontend:** React (port 3000)
- **Backend:** Express.js (port 5000)
- **Database:** PostgreSQL (port 5432)
- **Deployment:** Docker + Render.com

**Total setup time:** ~30-45 minutes (first time)

---

## 📦 Prerequisites Installation

### 1. Install Node.js (Required)

**Windows:**
1. Download from: https://nodejs.org/
2. Choose "LTS" version (18.x or higher)
3. Run installer with default settings
4. Verify installation:
```powershell
node --version
# Should show: v18.x.x or higher

npm --version
# Should show: 9.x.x or higher
```

---

### 2. Install Docker Desktop (Required)

**Windows:**
1. Download from: https://www.docker.com/products/docker-desktop
2. Install Docker Desktop
3. Start Docker Desktop (wait for it to fully start)
4. Verify installation:
```powershell
docker --version
# Should show: Docker version 24.x.x or higher

docker-compose --version
# Should show: Docker Compose version 2.x.x or higher
```

**Important:** 
- Docker Desktop must be running for all Docker commands
- First start may take 2-3 minutes
- You may need to enable WSL 2 (Docker will prompt you)

---

### 3. Install Git (Required)

**Windows:**
1. Download from: https://git-scm.com/download/win
2. Run installer with default settings
3. Verify installation:
```powershell
git --version
# Should show: git version 2.x.x or higher
```

---

### 4. Create Accounts (Required for Deployment)

**Docker Hub Account:**
1. Go to: https://hub.docker.com/
2. Click "Sign Up"
3. Create free account
4. Verify email
5. Remember your username (needed for image tagging)

**Render Account:**
1. Go to: https://render.com/
2. Click "Get Started"
3. Sign up with GitHub (recommended) or email
4. Verify email
5. May require credit card for verification (no charges on free tier)

**GitHub Account:**
1. Go to: https://github.com/
2. If you don't have an account, create one
3. Verify email

---

## 🛠 Project Setup (Step by Step)

### Step 1: Get the Project Files

**Option A: If you received a ZIP file**
```powershell
# Extract ZIP to Desktop
cd $HOME\Desktop
# Extract the ZIP file manually
cd DSO_101
```

**Option B: If you cloned from GitHub**
```powershell
cd $HOME\Desktop
git clone <repository-url>
cd DSO_101
```

**Option C: Starting from scratch (using these instructions)**
```powershell
# All files are already created in: 
cd $HOME\Desktop\DSO_101
```

---

### Step 2: Verify Project Structure

Run this command to see the project structure:
```powershell
tree /F
```

You should see:
```
DSO_101/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   ├── .env.example
│   └── .env.production
├── frontend/
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── App.js
│   │   ├── App.css
│   │   ├── index.js
│   │   └── index.css
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   ├── .env.example
│   └── .env.production
├── .gitignore
├── docker-compose.yml
├── render.yaml
├── README.md
└── setup.ps1
```

---

### Step 3: Create Environment Files

**Automated Setup (Recommended):**
```powershell
# Run the setup script
.\setup.ps1
```

**Manual Setup:**
```powershell
# Backend environment
cd backend
copy .env.example .env
cd ..

# Frontend environment
cd frontend
copy .env.example .env
cd ..
```

---

### Step 4: Verify Environment Files

**Check backend/.env:**
```powershell
cat backend\.env
```

Should contain:
```
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=todo_db
DB_PORT=5432
PORT=5000
NODE_ENV=development
```

**Check frontend/.env:**
```powershell
cat frontend\.env
```

Should contain:
```
REACT_APP_API_URL=http://localhost:5000
```

---

## 💻 Local Development

### Method 1: Using Docker Compose (Recommended)

This is the easiest way - everything runs in containers!

**Step 1: Start all services**
```powershell
# From project root (DSO_101 folder)
docker-compose up --build
```

**What this does:**
- Starts PostgreSQL database
- Starts Express.js backend
- Starts React frontend
- Connects them all together

**Wait for these messages:**
```
todo-postgres  | database system is ready to accept connections
todo-backend   | ✅ Database connected successfully
todo-backend   | ✅ Todos table ready
todo-backend   | 🚀 Server running on port 5000
```

**Step 2: Access the application**

Open your browser:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000/api/health

**Step 3: Test the application**
1. Create a new todo
2. Mark it as complete
3. Edit the todo
4. Delete the todo

**Step 4: Stop services**
```powershell
# Press Ctrl+C in the terminal where docker-compose is running
# Or in a new terminal:
docker-compose down
```

**Clean restart (removes all data):**
```powershell
docker-compose down -v
docker-compose up --build
```

---

### Method 2: Running Locally Without Docker

**Only if you want to develop without containers**

**Terminal 1 - Database:**
```powershell
# Install PostgreSQL locally or use Docker:
docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:15-alpine
```

**Terminal 2 - Backend:**
```powershell
cd backend
npm install
npm start
```

**Terminal 3 - Frontend:**
```powershell
cd frontend
npm install
npm start
```

---

## 🐳 Docker Hub Deployment (Part A)

### Prerequisites
- Docker Desktop running
- Docker Hub account created
- Application tested locally

---

### Step 1: Login to Docker Hub

```powershell
docker login
```

Enter:
- Username: (your Docker Hub username)
- Password: (your Docker Hub password)

Look for: `Login Succeeded`

---

### Step 2: Build Backend Image

**IMPORTANT:** Replace:
- `yourdockerhub` with your actual Docker Hub username
- `02190108` with your actual student ID

```powershell
cd backend

docker build -t yourdockerhub/be-todo:02190108 .
```

**This will take 2-3 minutes first time.**

**Verify the image:**
```powershell
docker images | findstr be-todo
```

You should see: `yourdockerhub/be-todo   02190108`

---

### Step 3: Build Frontend Image

```powershell
cd ..\frontend

docker build -t yourdockerhub/fe-todo:02190108 .
```

**This will take 3-5 minutes first time.**

**Verify the image:**
```powershell
docker images | findstr fe-todo
```

---

### Step 4: Push Images to Docker Hub

```powershell
# Push backend
docker push yourdockerhub/be-todo:02190108

# Push frontend
docker push yourdockerhub/fe-todo:02190108
```

**Each push takes 1-2 minutes depending on your internet speed.**

---

### Step 5: Verify on Docker Hub

1. Go to: https://hub.docker.com/
2. Login
3. Click "Repositories"
4. You should see:
   - `be-todo` with tag `02190108`
   - `fe-todo` with tag `02190108`

**📸 SCREENSHOT REQUIRED:** Take screenshot of your repositories

---

### Step 6: Deploy to Render.com

**Full detailed instructions in:** [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)

**Quick steps:**

1. **Create Database**
   - New+ → PostgreSQL
   - Name: `todo-db`
   - Database: `todo_db`
   - Create Database

2. **Deploy Backend**
   - New+ → Web Service
   - Deploy an existing image
   - Image: `docker.io/yourdockerhub/be-todo:02190108`
   - Add environment variables (from database)
   - Create Web Service

3. **Deploy Frontend**
   - New+ → Web Service
   - Deploy an existing image
   - Image: `docker.io/yourdockerhub/fe-todo:02190108`
   - Set REACT_APP_API_URL to backend URL
   - Create Web Service

**📸 SCREENSHOTS REQUIRED:**
- Database created
- Backend deployed
- Frontend deployed
- Working application

---

## 🔄 Automated CI/CD (Part B)

### Step 1: Create GitHub Repository

```powershell
cd $HOME\Desktop\DSO_101

# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Todo app with CI/CD pipeline"
```

**On GitHub:**
1. Go to: https://github.com/new
2. Repository name: `studentname_studentnumber_DSO101_A1`
   - Example: `john_doe_02190108_DSO101_A1`
3. Set to Public or Private
4. Do NOT initialize with README
5. Create repository

**Push to GitHub:**
```powershell
git remote add origin https://github.com/yourusername/your-repo-name.git
git branch -M main
git push -u origin main
```

**📸 SCREENSHOT REQUIRED:** GitHub repository with all files

---

### Step 2: Deploy from GitHub (Blueprint)

**On Render:**
1. Dashboard → New+ → Blueprint
2. Connect GitHub (if first time, authorize Render)
3. Select your repository
4. Render detects `render.yaml`
5. Review services:
   - `todo-db` (PostgreSQL)
   - `be-todo` (Backend)
   - `fe-todo` (Frontend)
6. Click "Apply"

**Wait for deployment (5-10 minutes first time)**

All services should show: ✅ Live

**📸 SCREENSHOT REQUIRED:**
- Blueprint configuration
- All services live

---

### Step 3: Test Automated Deployment

**Make a change:**
```powershell
# Edit frontend/src/App.js
# Find line: <h1>📝 Todo List Application</h1>
# Change to: <h1>📝 Todo List Application v2.0</h1>

# Save file
```

**Commit and push:**
```powershell
git add .
git commit -m "Update: Add version number"
git push origin main
```

**Watch Render:**
- Go to Render Dashboard
- Navigate to `fe-todo` service
- See new deployment starting automatically
- Wait for completion

**Verify:**
- Open frontend URL
- Hard refresh: Ctrl+Shift+R
- See "v2.0" in header

**📸 SCREENSHOT REQUIRED:**
- Automatic deployment triggered
- Updated application

---

## ✅ Verification Checklist

### Local Development
- [ ] Docker Desktop installed and running
- [ ] Node.js installed (v18+)
- [ ] Git installed
- [ ] Project files in correct structure
- [ ] Backend .env created
- [ ] Frontend .env created
- [ ] `docker-compose up` works without errors
- [ ] Frontend loads at http://localhost:3000
- [ ] Backend responds at http://localhost:5000/api/health
- [ ] Can create, edit, and delete todos
- [ ] Data persists after page refresh

### Docker Hub (Part A)
- [ ] Docker Hub account created
- [ ] Logged in with `docker login`
- [ ] Backend image built successfully
- [ ] Frontend image built successfully
- [ ] Backend image pushed to Docker Hub
- [ ] Frontend image pushed to Docker Hub
- [ ] Images visible on Docker Hub website
- [ ] Screenshot of Docker Hub repositories taken

### Render Deployment (Part A)
- [ ] Render account created
- [ ] PostgreSQL database created on Render
- [ ] Backend deployed from Docker Hub image
- [ ] Frontend deployed from Docker Hub image
- [ ] Environment variables configured
- [ ] All services show "Live" status
- [ ] Frontend URL works in browser
- [ ] Backend /api/health responds
- [ ] Can perform CRUD operations in production
- [ ] Screenshots of each deployment step taken

### GitHub & CI/CD (Part B)
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] render.yaml file in root
- [ ] .gitignore prevents .env from being committed
- [ ] Blueprint created on Render
- [ ] All services deployed from GitHub
- [ ] Auto-deploy enabled
- [ ] Test commit triggers new deployment
- [ ] Updated code visible after auto-deployment
- [ ] Screenshots of GitHub and auto-deployment taken

### Documentation
- [ ] README.md completed with all steps
- [ ] All screenshots included or referenced
- [ ] Environment variables documented
- [ ] Live URLs included
- [ ] Repository follows naming convention

---

## 🎓 Commands Reference

### Essential Docker Commands
```powershell
# Start application
docker-compose up --build

# Stop application
docker-compose down

# View logs
docker-compose logs -f

# Clean restart
docker-compose down -v
docker-compose up --build

# Build image
docker build -t name:tag .

# Push to Docker Hub
docker push name:tag

# Login to Docker Hub
docker login
```

### Essential Git Commands
```powershell
# Initialize repository
git init

# Add files
git add .

# Commit changes
git commit -m "message"

# Add remote
git remote add origin <url>

# Push to GitHub
git push origin main

# Check status
git status
```

### Test API Commands
```powershell
# Health check
Invoke-RestMethod -Uri "http://localhost:5000/api/health"

# Get all todos
Invoke-RestMethod -Uri "http://localhost:5000/api/todos"

# Create todo
$body = @{ title = "Test"; description = "Test todo" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:5000/api/todos" -Method Post -ContentType "application/json" -Body $body
```

---

## 🆘 Common Issues & Solutions

### "Docker daemon is not running"
**Solution:** Open Docker Desktop and wait for it to start

### "Port 5000 is already allocated"
**Solution:**
```powershell
# Find process using port
netstat -ano | findstr :5000

# Kill process (replace <PID>)
taskkill /PID <PID> /F
```

### "Cannot connect to database"
**Solution:**
```powershell
# Clean restart
docker-compose down -v
docker-compose up --build
```

### "npm install fails"
**Solution:**
```powershell
# Clear npm cache
npm cache clean --force
npm install
```

### "Git push rejected"
**Solution:**
```powershell
# Pull first
git pull origin main --rebase
git push origin main
```

---

## 📚 Additional Resources

- **Full README:** [README.md](README.md)
- **Quick Start:** [QUICKSTART.md](QUICKSTART.md)
- **Render Deployment:** [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)
- **Docker Commands:** [DOCKER_COMMANDS.md](DOCKER_COMMANDS.md)
- **API Testing:** [API_TESTING.md](API_TESTING.md)

### External Documentation
- Docker: https://docs.docker.com/
- Render: https://render.com/docs
- React: https://react.dev/
- Express: https://expressjs.com/
- PostgreSQL: https://www.postgresql.org/docs/

---

## 📞 Getting Help

If you get stuck:

1. **Check logs:** `docker-compose logs -f`
2. **Review error messages** carefully
3. **Search documentation** for specific errors
4. **Check Render logs** if deployment fails
5. **Verify environment variables** are set correctly
6. **Make sure Docker Desktop is running**
7. **Try clean restart:** `docker-compose down -v && docker-compose up --build`

---

## ⏰ Time Estimates

- **Prerequisites installation:** 15-20 minutes
- **Project setup:** 5-10 minutes
- **Local testing:** 10-15 minutes
- **Docker Hub deployment (Part A):** 30-45 minutes
- **GitHub & CI/CD (Part B):** 20-30 minutes
- **Documentation & screenshots:** 30-45 minutes

**Total:** 2-3 hours (including breaks)

---

## 🎯 Success Criteria

You've successfully completed the assignment when:
✅ Application works locally with Docker Compose
✅ Images pushed to Docker Hub with student ID tag
✅ Application deployed on Render from Docker images
✅ Application deployed on Render from GitHub with auto-deploy
✅ Test git push triggers automatic redeployment
✅ All screenshots captured and documented
✅ README.md completed with all steps
✅ Repository named correctly and pushed to GitHub

---

**Good luck with your assignment! 🚀**

**Date:** March 12, 2026  
**Course:** DSO101 - Continuous Integration and Continuous Deployment  
**Program:** Bachelor of Engineering in Software Engineering
