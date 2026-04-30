# DSO101 Assignment - Step by Step Instructions

## STEP 0: LOCAL DEVELOPMENT & TESTING

### 0.1 Verify Project Structure
```
DSO_101/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   └── .env (NEVER COMMIT TO GIT!)
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── public/
│   ├── src/
│   └── .env (NEVER COMMIT TO GIT!)
├── docker-compose.yml
└── .gitignore (must include *.env)
```

### 0.2 Create .env Files

**backend/.env:**
```
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=todo_db
DB_PORT=5432
PORT=5000
NODE_ENV=development
```

**frontend/.env:**
```
REACT_APP_API_URL=http://localhost:5000
```

### 0.3 Ensure .env Files Are in .gitignore
Check .gitignore contains:
```
.env
.env.local
.env.*.local
```

### 0.4 Install Dependencies Locally

**Backend:**
```powershell
cd backend
npm install
cd ..
```

**Frontend:**
```powershell
cd frontend
npm install
cd ..
```

### 0.5 Test Backend Locally (Optional)

**In backend directory:**
```powershell
npm start
```

### 0.6 Test Frontend Locally (Optional)

**In frontend directory:**
```powershell
npm start
```

---

## STEP 1: RUN APPLICATION LOCALLY WITH DOCKER-COMPOSE

### 1.1 Build and Run Containers
```powershell
cd C:\Users\HP\OneDrive\Desktop\DSO_101

# Build and start all services
docker-compose up --build

# Expected output:
# - Database: PostgreSQL running on localhost:5432
# - Backend: Express running on localhost:5000
# - Frontend: Nginx running on localhost:3000
```

### 1.2 Test the Application
- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:5000/api/todos
- **Health Check:** http://localhost:5000/api/health

### 1.3 Stop Containers
```powershell
docker-compose down
```

---

## PART A: DOCKER HUB DEPLOYMENT

### A.1 Create Docker Hub Account
1. Go to https://hub.docker.com
2. Sign up with your account (e.g., rynorbu11)
3. Create username and password

### A.2 Login to Docker Hub Locally
```powershell
docker login
# Enter username: rynorbu11
# Enter password: (your Docker Hub password)
```

### A.3 Build Backend Docker Image
```powershell
# Navigate to project root
cd C:\Users\HP\OneDrive\Desktop\DSO_101

# Build backend image with correct tag
docker build -f backend/Dockerfile -t rynorbu11/be-todo:02230297 backend/

# Expected output: "Successfully tagged rynorbu11/be-todo:02230297"
```

### A.4 Push Backend to Docker Hub
```powershell
docker push rynorbu11/be-todo:02230297

# Expected output: "Pushed successfully"
# Now available at: docker.io/rynorbu11/be-todo:02230297
```

### A.5 Build Frontend Docker Image
```powershell
# Build with backend URL for production
docker build --build-arg REACT_APP_API_URL=https://be-todo-[your-service-id].onrender.com -f frontend/Dockerfile -t rynorbu11/fe-todo:02230297 frontend/

# For now, use local URL:
docker build -f frontend/Dockerfile -t rynorbu11/fe-todo:02230297 frontend/
```

### A.6 Push Frontend to Docker Hub
```powershell
docker push rynorbu11/fe-todo:02230297

# Expected output: "Pushed successfully"
# Now available at: docker.io/rynorbu11/fe-todo:02230297
```

### A.7 Verify Images on Docker Hub
1. Go to https://hub.docker.com/r/rynorbu11
2. You should see:
   - be-todo:02230297
   - fe-todo:02230297

---

## PART B: DEPLOYMENT ON RENDER.COM

### B.1 Create Render Account & Login
1. Go to https://render.com
2. Sign up/Login with GitHub account
3. Go to Dashboard

### B.2 Create PostgreSQL Database

**Steps:**
1. Click "New +" → "PostgreSQL"
2. Configure:
   - Name: `todo-db`
   - Database: `todo_db`
   - User: `todo_user`
   - Region: Singapore (or closest to you)
   - Plan: Free
3. Click "Create Database"
4. **Note the connection details:**
   - Internal Hostname: (for services within Render)
   - External Hostname: (for external connections)
   - Database: todo_db
   - User: todo_user
   - Password: (auto-generated)
   - Port: 5432

### B.3 Deploy Backend Service

**Steps:**
1. Click "New +" → "Web Service"
2. Configuration:
   - Name: `be-todo`
   - Docker Image URL: `rynorbu11/be-todo:02230297`
   - Region: Oregon (or closest to you)
   - Plan: Free
3. Set Environment Variables:
   ```
   DB_HOST=<External Hostname from PostgreSQL>
   DB_USER=todo_user
   DB_PASSWORD=<Password from PostgreSQL>
   DB_NAME=todo_db
   DB_PORT=5432
   PORT=5000
   NODE_ENV=production
   ```
4. Click "Create Web Service"
5. Wait for deployment (~5-10 minutes)
6. **Note the Backend URL:** `https://be-todo-[xxx].onrender.com`

### B.4 Deploy Frontend Service

**Steps:**
1. Click "New +" → "Web Service"
2. Configuration:
   - Name: `fe-todo`
   - Docker Image URL: `rynorbu11/fe-todo:02230297`
   - Region: Oregon
   - Plan: Free
3. Set Environment Variables:
   ```
   REACT_APP_API_URL=https://be-todo-[xxx].onrender.com
   ```
4. Click "Create Web Service"
5. Wait for deployment (~5-10 minutes)
6. **Note the Frontend URL:** `https://fe-todo-[xxx].onrender.com`

### B.5 Test Deployed Application
- Frontend: `https://fe-todo-[xxx].onrender.com`
- Backend API: `https://be-todo-[xxx].onrender.com/api/todos`
- Health Check: `https://be-todo-[xxx].onrender.com/api/health`

---

## PART C: AUTOMATED CI/CD WITH GITHUB & RENDER BLUEPRINT

### C.1 Create GitHub Repository
```powershell
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Todo app with Docker setup"

# Create GitHub repo: RanjungYeshiNorbu_02230297_DSO101_A1

# Add remote
git remote add origin https://github.com/Rynorbu/RanjungYeshiNorbu_02230297_DSO101_A1

# Push
git push -u origin main
```

### C.2 Create render.yaml Blueprint

**File: render.yaml (in project root)**
```yaml
services:
  - type: web
    name: be-todo
    env: docker
    dockerfilePath: backend/Dockerfile
    region: oregon
    plan: free
    healthCheckPath: /api/health
    envVars:
      - key: DB_HOST
        value: <External DB Hostname>
      - key: DB_USER
        value: todo_user
      - key: DB_PASSWORD
        value: <DB Password>
      - key: DB_NAME
        value: todo_db
      - key: DB_PORT
        value: 5432
      - key: PORT
        value: 5000
      - key: NODE_ENV
        value: production

  - type: web
    name: fe-todo
    env: docker
    dockerfilePath: frontend/Dockerfile
    region: oregon
    plan: free
    envVars:
      - key: REACT_APP_API_URL
        value: https://be-todo-[service-id].onrender.com
```

### C.3 Connect GitHub to Render Blueprint

**Steps:**
1. Go to Render Dashboard
2. Click "New +" → "Blueprint"
3. Click "Connect repository"
4. Select your GitHub repo: `RanjungYeshiNorbu_02230297_DSO101_A1`
5. Authorize Render to access GitHub
6. Select the repo and click "Deploy"
7. Render will read render.yaml and deploy both services automatically

### C.4 Verify Automated Deployment
- Check Render Dashboard
- Both services should show "Live"
- Frontend and Backend URLs should be accessible

### C.5 Test CI/CD Pipeline

**Make a code change:**
```powershell
# Edit backend/server.js or frontend/App.js

# Commit and push
git add .
git commit -m "Update: Add new feature"
git push origin main

# Watch Render Dashboard - deployment should start automatically!
```

---

## SUBMISSION CHECKLIST

- [ ] Step 0: Application works locally with docker-compose
- [ ] Part A: Both images pushed to Docker Hub
- [ ] Part A: Backend deployed on Render with database
- [ ] Part A: Frontend deployed on Render
- [ ] Part B: render.yaml created and committed to GitHub
- [ ] Part C: GitHub connected to Render Blueprint
- [ ] Part C: Automated CI/CD working (push triggers deployment)
- [ ] All services (DB, Backend, Frontend) are live and accessible
- [ ] API endpoints tested and working
- [ ] README.md with all URLs and instructions
- [ ] Repository submitted: `studentname_studentnumber_DSO101_A1`

---

## TROUBLESHOOTING

### Docker-compose issues:
```powershell
# Clean up and rebuild
docker-compose down
docker system prune -a
docker-compose up --build
```

### Can't connect to database:
- Use internal hostname for docker-compose (DB_HOST=db)
- Use external hostname for Render (DB_HOST=dpg-xxx.render.com)

### Frontend can't reach backend:
- REACT_APP_API_URL must be set at build time
- Check REACT_APP_API_URL in environment variables

### GitHub push issues:
```powershell
# Check remote
git remote -v

# Update remote if needed
git remote set-url origin https://github.com/Rynorbu/RanjungYeshiNorbu_02230297_DSO101_A1

# Push again
git push -u origin main
```

---

## USEFUL COMMANDS

```powershell
# Docker
docker login
docker build -t tag:version .
docker push tag:version
docker-compose up --build
docker-compose down
docker ps
docker logs container-name

# Git
git status
git add .
git commit -m "message"
git push origin main
git log

# Check services
curl http://localhost:5000/api/health
curl http://localhost:3000
```
