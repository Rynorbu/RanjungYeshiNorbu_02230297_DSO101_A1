# Todo List Application - DSO101 Assignment
**Continuous Integration and Continuous Deployment (CI/CD)**

## 📋 Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Part A: Docker Hub Deployment](#part-a-docker-hub-deployment)
- [Part B: Automated CI/CD Deployment](#part-b-automated-cicd-deployment)
- [Project Structure](#project-structure)
- [Environment Variables](#environment-variables)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview
This is a full-stack Todo List application built as part of the DSO101 (CI/CD) assignment. The application demonstrates containerization, Docker Hub registry usage, and automated deployment to Render.com using GitOps principles.

**Live Demo:**
- Frontend: `https://fe-todo.onrender.com` (Replace with your actual URL)
- Backend: `https://be-todo.onrender.com` (Replace with your actual URL)

---

## 🛠 Tech Stack
- **Frontend:** React 18.x
- **Backend:** Node.js with Express.js
- **Database:** PostgreSQL 15
- **Containerization:** Docker & Docker Compose
- **Deployment:** Render.com
- **Registry:** Docker Hub

---

## ✨ Features
- ✅ Create, Read, Update, Delete (CRUD) todos
- ✅ Mark todos as complete/incomplete
- ✅ Persistent storage with PostgreSQL
- ✅ Responsive UI design
- ✅ Dockerized multi-service architecture
- ✅ Environment-based configuration
- ✅ Automated deployment pipeline

---

## 📦 Prerequisites

### Required Software
1. **Node.js** (v18 or higher)
   - Download: https://nodejs.org/
   - Verify: `node --version`

2. **Docker Desktop**
   - Download: https://www.docker.com/products/docker-desktop
   - Verify: `docker --version` and `docker-compose --version`

3. **Git**
   - Download: https://git-scm.com/
   - Verify: `git --version`

4. **Docker Hub Account**
   - Register: https://hub.docker.com/

5. **Render Account**
   - Register: https://render.com/

---

## 🚀 Local Development Setup

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/studentname_studentnumber_DSO101_A1.git
cd studentname_studentnumber_DSO101_A1
```

### Step 2: Setup Environment Variables

#### Backend Environment Setup
```bash
cd backend
copy .env.example .env
```

Edit `backend/.env` with your local configuration:
```env
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=todo_db
DB_PORT=5432
PORT=5000
NODE_ENV=development
```

#### Frontend Environment Setup
```bash
cd ../frontend
copy .env.example .env
```

Edit `frontend/.env`:
```env
REACT_APP_API_URL=http://localhost:5000
```

### Step 3: Install Dependencies

#### Backend Dependencies
```bash
cd backend
npm install
```

**Expected packages:**
- express: Web framework
- pg: PostgreSQL client
- cors: Enable cross-origin requests
- dotenv: Environment variable loader
- body-parser: Parse request bodies

#### Frontend Dependencies
```bash
cd ../frontend
npm install
```

**Expected packages:**
- react & react-dom: UI library
- react-scripts: Build tooling
- axios: HTTP client

### Step 4: Start with Docker Compose

From the root directory:

```bash
# Build and start all services
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build
```

This will start:
- PostgreSQL database on `localhost:5432`
- Backend API on `http://localhost:5000`
- Frontend UI on `http://localhost:3000`

### Step 5: Verify Local Installation

1. **Check Backend Health:**
```bash
curl http://localhost:5000/api/health
```
Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2026-03-12T...",
  "database": "connected"
}
```

2. **Access Frontend:**
   - Open browser: http://localhost:3000
   - You should see the Todo List UI

3. **Test CRUD Operations:**
   - Create a new todo
   - Edit an existing todo
   - Mark as complete
   - Delete a todo

### Step 6: Stop Services
```bash
docker-compose down

# To remove volumes as well (clears database)
docker-compose down -v
```

---

## 🐳 Part A: Docker Hub Deployment

### Step 1: Login to Docker Hub
```bash
docker login
```
Enter your Docker Hub username and password.

### Step 2: Build Docker Images

**IMPORTANT:** Replace `yourdockerhub` with your Docker Hub username and `02190108` with your student ID.

#### Build Backend Image
```bash
cd backend
docker build -t yourdockerhub/be-todo:02190108 .
```

#### Build Frontend Image
```bash
cd ../frontend
docker build -t yourdockerhub/fe-todo:02190108 .
```

### Step 3: Push Images to Docker Hub

```bash
# Push backend
docker push yourdockerhub/be-todo:02190108

# Push frontend
docker push yourdockerhub/fe-todo:02190108
```

### Step 4: Verify on Docker Hub
1. Go to https://hub.docker.com/
2. Navigate to your repositories
3. Confirm both `be-todo:02190108` and `fe-todo:02190108` are present

**Screenshot Required:** Take a screenshot showing your Docker Hub repositories

### Step 5: Deploy on Render.com

#### 5.1 Create PostgreSQL Database
1. Login to Render dashboard: https://dashboard.render.com/
2. Click **"New +"** → **"PostgreSQL"**
3. Configure:
   - Name: `todo-db`
   - Database: `todo_db`
   - User: `todo_user`
   - Region: Choose closest to you
   - Plan: Free
4. Click **"Create Database"**
5. **Save the connection details shown** (Internal/External Database URL)

**Screenshot Required:** Database creation confirmation page

#### 5.2 Deploy Backend Service
1. Click **"New +"** → **"Web Service"**
2. Select **"Deploy an existing image from a registry"**
3. Configure:
   - **Name:** `be-todo`
   - **Image URL:** `docker.io/yourdockerhub/be-todo:02190108`
   - **Region:** Same as database
   - **Plan:** Free
4. Add Environment Variables:
   ```
   DB_HOST=<your-render-db-internal-host>
   DB_USER=todo_user
   DB_PASSWORD=<your-db-password>
   DB_NAME=todo_db
   DB_PORT=5432
   PORT=5000
   NODE_ENV=production
   ```
   ℹ️ Get DB connection details from the PostgreSQL database you created
5. Under **"Advanced":**
   - Health Check Path: `/api/health`
6. Click **"Create Web Service"**

**Screenshot Required:** Backend service deployed successfully

#### 5.3 Deploy Frontend Service
1. Click **"New +"** → **"Web Service"**
2. Select **"Deploy an existing image from a registry"**
3. Configure:
   - **Name:** `fe-todo`
   - **Image URL:** `docker.io/yourdockerhub/fe-todo:02190108`
   - **Region:** Same as backend
   - **Plan:** Free
4. Add Environment Variable:
   ```
   REACT_APP_API_URL=https://be-todo.onrender.com
   ```
   ℹ️ Replace with your actual backend service URL from step 5.2
5. Click **"Create Web Service"**

**Screenshot Required:** Frontend service deployed successfully

#### 5.4 Test Deployed Application
1. Open your frontend URL: `https://fe-todo.onrender.com`
2. Verify the application loads
3. Test CRUD operations

**Screenshot Required:** Working application in production

---

## 🔄 Part B: Automated CI/CD Deployment

### Step 1: Prepare GitHub Repository

#### 1.1 Create Repository Structure
```
studentname_studentnumber_DSO101_A1/
├── frontend/
│   ├── src/
│   ├── public/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   └── .env.production
├── backend/
│   ├── server.js
│   ├── Dockerfile
│   ├── package.json
│   └── .env.production
├── render.yaml
├── docker-compose.yml
├── .gitignore
└── README.md
```

#### 1.2 Verify .gitignore
Ensure `.env` files are NOT committed:
```bash
cat .gitignore
```
Should contain:
```
.env
.env.local
node_modules/
```

#### 1.3 Create GitHub Repository
1. Go to https://github.com/
2. Click **"New repository"**
3. Repository name: `studentname_studentnumber_DSO101_A1`
4. Set to **Public** or **Private**
5. Do NOT initialize with README (we already have one)
6. Click **"Create repository"**

### Step 2: Push Code to GitHub

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Todo application with CI/CD"

# Add remote
git remote add origin https://github.com/yourusername/studentname_studentnumber_DSO101_A1.git

# Push to main branch
git push -u origin main
```

**Screenshot Required:** GitHub repository with all files

### Step 3: Configure render.yaml

The `render.yaml` file in the root directory defines our infrastructure as code.

**Key sections:**
```yaml
services:
  # Database service
  - type: pserv
    name: todo-db
    
  # Backend service
  - type: web
    name: be-todo
    dockerfilePath: ./backend/Dockerfile
    
  # Frontend service
  - type: web
    name: fe-todo
    dockerfilePath: ./frontend/Dockerfile
```

### Step 4: Deploy from GitHub to Render

#### 4.1 Create Blueprint
1. Go to Render Dashboard: https://dashboard.render.com/
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub repository
4. If first time, click **"Connect GitHub"** and authorize Render
5. Select your repository: `studentname_studentnumber_DSO101_A1`
6. Render will detect the `render.yaml` file

#### 4.2 Review Blueprint
1. Render will show all services defined in `render.yaml`:
   - `todo-db` (PostgreSQL)
   - `be-todo` (Backend)
   - `fe-todo` (Frontend)
2. Review the configuration
3. Click **"Apply"**

**Screenshot Required:** Blueprint review page

#### 4.3 Monitor Deployment
1. Watch the deployment logs for each service
2. Wait for all services to show **"Live"** status
3. Database should initialize first, then backend, then frontend

**Screenshot Required:** All services showing "Live" status

### Step 5: Test Automated Deployment

#### 5.1 Make a Code Change
Edit `frontend/src/App.js` to change the header:
```javascript
<h1>📝 Todo List Application v2.0</h1>
```

#### 5.2 Commit and Push
```bash
git add .
git commit -m "Update app version to 2.0"
git push origin main
```

#### 5.3 Watch Auto-Deployment
1. Go to Render Dashboard
2. Navigate to `fe-todo` service
3. You should see a new deployment triggered automatically
4. Wait for deployment to complete

**Screenshot Required:** Automatic deployment triggered

#### 5.4 Verify Changes
1. Open your frontend URL
2. Refresh the page (hard refresh: Ctrl+Shift+R)
3. Verify the header shows "v2.0"

**Screenshot Required:** Updated application in production

---

## 📁 Project Structure

```
studentname_studentnumber_DSO101_A1/
│
├── frontend/                          # React Frontend Application
│   ├── public/
│   │   └── index.html                # HTML template
│   ├── src/
│   │   ├── App.js                    # Main React component
│   │   ├── App.css                   # Component styles
│   │   ├── index.js                  # React entry point
│   │   └── index.css                 # Global styles
│   ├── Dockerfile                     # Frontend Docker configuration
│   ├── nginx.conf                     # Nginx server configuration
│   ├── package.json                   # Frontend dependencies
│   ├── .env.example                   # Example environment file
│   └── .env.production               # Production environment template
│
├── backend/                           # Express.js Backend API
│   ├── server.js                      # Main server file with API routes
│   ├── Dockerfile                     # Backend Docker configuration
│   ├── package.json                   # Backend dependencies
│   ├── .env.example                   # Example environment file
│   └── .env.production               # Production environment template
│
├── render.yaml                        # Render.com deployment blueprint
├── docker-compose.yml                 # Local development orchestration
├── .gitignore                         # Git ignore rules
└── README.md                          # This file
```

---

## 🔐 Environment Variables

### Backend Environment Variables

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `DB_HOST` | PostgreSQL host | `localhost` or Render internal host | Yes |
| `DB_USER` | Database username | `postgres` | Yes |
| `DB_PASSWORD` | Database password | `your_password` | Yes |
| `DB_NAME` | Database name | `todo_db` | Yes |
| `DB_PORT` | Database port | `5432` | Yes |
| `PORT` | Server port | `5000` | Yes |
| `NODE_ENV` | Environment | `development` or `production` | No |

### Frontend Environment Variables

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `REACT_APP_API_URL` | Backend API URL | `http://localhost:5000` or `https://be-todo.onrender.com` | Yes |

**⚠️ Important Notes:**
- Never commit `.env` files to Git
- Use `.env.example` as templates
- Set actual values in Render dashboard for production
- React environment variables MUST start with `REACT_APP_`

---

## 🧪 Testing

### Manual Testing Checklist

#### Local Testing
- [ ] `docker-compose up` starts all services without errors
- [ ] Backend health endpoint responds: `curl http://localhost:5000/api/health`
- [ ] Frontend loads on http://localhost:3000
- [ ] Can create a new todo
- [ ] Can edit a todo
- [ ] Can mark todo as complete
- [ ] Can delete a todo
- [ ] Data persists after page refresh

#### API Endpoints Testing

**1. Health Check**
```bash
curl http://localhost:5000/api/health
```

**2. Get All Todos**
```bash
curl http://localhost:5000/api/todos
```

**3. Create Todo**
```bash
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Todo","description":"This is a test"}'
```

**4. Update Todo**
```bash
curl -X PUT http://localhost:5000/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'
```

**5. Delete Todo**
```bash
curl -X DELETE http://localhost:5000/api/todos/1
```

### Production Testing
- [ ] Frontend loads on Render URL
- [ ] Backend API responds on Render URL
- [ ] All CRUD operations work in production
- [ ] Changes pushed to GitHub trigger auto-deployment
- [ ] New deployment reflects code changes

---

## 🐛 Troubleshooting

### Common Issues and Solutions

#### Issue 1: Docker Build Fails
**Error:** `Cannot find module 'express'`

**Solution:**
```bash
# Clear Docker cache and rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

#### Issue 2: Database Connection Error
**Error:** `ECONNREFUSED localhost:5432`

**Solution:**
1. Verify PostgreSQL is running: `docker ps`
2. Check `.env` file has correct DB credentials
3. Ensure database service started before backend:
```bash
docker-compose up db
# Wait for "database system is ready"
docker-compose up backend
```

#### Issue 3: Frontend Can't Connect to Backend
**Error:** `Network Error` in browser console

**Solution:**
1. Verify backend is running: `curl http://localhost:5000/api/health`
2. Check CORS is enabled in `backend/server.js`
3. Verify `REACT_APP_API_URL` in `frontend/.env`
4. Clear browser cache and hard refresh (Ctrl+Shift+R)

#### Issue 4: Render Deployment Fails
**Error:** `Build failed` or `Deploy failed`

**Solution:**
1. Check Render logs for specific error
2. Verify Dockerfile paths in `render.yaml`
3. Ensure environment variables are set in Render dashboard
4. Check if free tier limits are exceeded

#### Issue 5: Docker Push Fails
**Error:** `denied: requested access to the resource is denied`

**Solution:**
```bash
# Login again
docker logout
docker login

# Verify image name matches Docker Hub username
docker images
docker push yourdockerhub/be-todo:02190108
```

#### Issue 6: Port Already in Use
**Error:** `Port 5000 is already allocated`

**Solution:**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Or change port in .env and docker-compose.yml
PORT=5001
```

### Debugging Tips

1. **Check Docker Logs:**
```bash
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db
```

2. **Verify Environment Variables:**
```bash
docker-compose config
```

3. **Test Database Connection:**
```bash
docker exec -it todo-postgres psql -U postgres -d todo_db
\dt  # List tables
SELECT * FROM todos;  # Query todos
\q   # Quit
```

4. **Inspect Running Containers:**
```bash
docker ps
docker inspect <container_id>
```

---

## 📝 Assignment Submission Checklist

### Part A Checklist
- [ ] Backend Docker image built and pushed to Docker Hub
- [ ] Frontend Docker image built and pushed to Docker Hub
- [ ] Screenshot of Docker Hub repositories
- [ ] PostgreSQL database created on Render
- [ ] Backend deployed on Render from Docker image
- [ ] Frontend deployed on Render from Docker image
- [ ] Screenshots of each deployment step
- [ ] Live application URL tested and working

### Part B Checklist
- [ ] GitHub repository created with correct naming convention
- [ ] All code pushed to GitHub (excluding .env files)
- [ ] `render.yaml` file configured correctly
- [ ] Blueprint created on Render from GitHub
- [ ] All services deployed successfully
- [ ] Screenshots of blueprint and deployment
- [ ] Test commit made to trigger auto-deployment
- [ ] Screenshot of automated deployment
- [ ] README.md completed with all steps and screenshots

### Documentation Checklist
- [ ] All screenshots included in README.md or separate folder
- [ ] Each step clearly documented
- [ ] Environment variables documented
- [ ] Testing instructions provided
- [ ] Live URLs included

---

## 📚 Resources and Documentation

### Official Documentation
- **Docker:** https://docs.docker.com/
- **Render:** https://render.com/docs
- **React:** https://react.dev/
- **Express.js:** https://expressjs.com/
- **PostgreSQL:** https://www.postgresql.org/docs/
- **Node.js:** https://nodejs.org/docs/

### Helpful Links
- Docker Hub Publishing: https://docs.docker.com/get-started/introduction/build-and-push-first-image/
- Render Blueprint Spec: https://render.com/docs/blueprint-spec
- Render Environment Variables: https://render.com/docs/configure-environment-variables
- Deploying Docker Images on Render: https://render.com/docs/deploying-an-image
- Environment Variables Best Practices: https://12factor.net/config

### Tutorial Videos
- Docker Crash Course: https://www.youtube.com/watch?v=pg19Z8LL06w
- React Tutorial: https://react.dev/learn
- Express.js Tutorial: https://expressjs.com/en/starter/installing.html

---

## 👨‍💻 Author

**Name:** [Your Name]  
**Student ID:** [Your Student Number]  
**Course:** DSO101 - Continuous Integration and Continuous Deployment  
**Program:** Bachelor of Engineering in Software Engineering (SWE)

---

## 📄 License

This project is created for educational purposes as part of the DSO101 course assignment.

---

## 🙏 Acknowledgments

- Course instructors for the assignment guidelines
- Render.com for free hosting tier
- Docker Hub for container registry
- Open-source community for the tools and frameworks

---

**Date Submitted:** 12th March 2026

---

## 📸 Screenshots Section

### Part A Screenshots

#### 1. Docker Hub Repositories
*Insert screenshot showing both be-todo and fe-todo images in Docker Hub*

#### 2. Render Database Creation
*Insert screenshot of PostgreSQL database created on Render*

#### 3. Backend Service Deployment
*Insert screenshot of backend service deployed successfully*

#### 4. Frontend Service Deployment
*Insert screenshot of frontend service deployed successfully*

#### 5. Working Application
*Insert screenshot of the live application showing todo operations*

### Part B Screenshots

#### 6. GitHub Repository
*Insert screenshot of GitHub repository with all files*

#### 7. Render Blueprint Configuration
*Insert screenshot of Blueprint review page before applying*

#### 8. All Services Live
*Insert screenshot showing all three services (db, backend, frontend) with "Live" status*

#### 9. Automated Deployment
*Insert screenshot of automatic deployment triggered by git push*

#### 10. Updated Application
*Insert screenshot showing the updated application after auto-deployment*

---

## 🎓 Learning Outcomes

Through this assignment, the following concepts were learned and applied:

1. **Containerization:** Creating Dockerfiles and containerizing applications
2. **Docker Compose:** Orchestrating multi-container applications locally
3. **Container Registry:** Publishing and managing images on Docker Hub
4. **Environment Management:** Using .env files for configuration
5. **CI/CD Principles:** Automated build and deployment pipelines
6. **Infrastructure as Code:** Using render.yaml for deployment configuration
7. **GitOps:** Git-based deployment workflows
8. **REST API Development:** Building CRUD APIs with Express.js
9. **Frontend Development:** Creating interactive UIs with React
10. **Cloud Deployment:** Deploying applications to cloud platforms

---

*End of README*
