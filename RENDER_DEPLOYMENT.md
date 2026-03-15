# Render Deployment Guide

## 🚀 Complete Render.com Deployment Guide

### Table of Contents
1. [Prerequisites](#prerequisites)
2. [Part A: Manual Deployment from Docker Hub](#part-a-manual-deployment-from-docker-hub)
3. [Part B: Automated Deployment from GitHub](#part-b-automated-deployment-from-github)
4. [Environment Variables Reference](#environment-variables-reference)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites

- [ ] Render.com account created (https://render.com/)
- [ ] Docker Hub account with pushed images (Part A only)
- [ ] GitHub repository with your code (Part B only)
- [ ] Credit card for verification (no charges on free tier)

---

## Part A: Manual Deployment from Docker Hub

### Step 1: Create PostgreSQL Database

1. Login to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** button (top right)
3. Select **"PostgreSQL"**

**Configuration:**
```
Name: todo-db
Database: todo_db
User: todo_user
Region: Oregon (or closest to you)
PostgreSQL Version: 15
Datadog API Key: (leave blank)
Plan: Free
```

4. Click **"Create Database"**
5. Wait for database to provision (1-2 minutes)

**Important:** Save these values from the database info page:
- Internal Database URL
- External Database URL
- Host
- Port
- Database
- Username
- Password

**Screenshot Checklist:**
- [ ] Database creation form
- [ ] Database info page showing connection details

---

### Step 2: Deploy Backend Service

1. Click **"New +"** → **"Web Service"**
2. Select **"Deploy an existing image from a registry"**

**Configuration:**
```
Service Name: be-todo
Image URL: docker.io/yourdockerhub/be-todo:YOURSTUDENTID
Region: Oregon (same as database)
Branch: (leave blank)
Plan: Free

Advanced Settings:
├── Instance Type: Free
├── Health Check Path: /api/health
└── Auto-Deploy: No (for Part A)
```

**Environment Variables:**
Click **"Add Environment Variable"** for each:

```
Key: DB_HOST
Value: <your-internal-database-host>
(e.g., dpg-xxxxx-a.oregon-postgres.render.com)

Key: DB_USER
Value: todo_user

Key: DB_PASSWORD
Value: <your-database-password>

Key: DB_NAME
Value: todo_db

Key: DB_PORT
Value: 5432

Key: PORT
Value: 5000

Key: NODE_ENV
Value: production
```

3. Click **"Create Web Service"**
4. Wait for deployment (3-5 minutes)
5. Check logs for "Server running on port 5000"

**Test Backend:**
```bash
# Replace with your backend URL
curl https://be-todo-xxxx.onrender.com/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2026-03-12T...",
  "database": "connected"
}
```

**Screenshot Checklist:**
- [ ] Service configuration page
- [ ] Environment variables page
- [ ] Deployment successful page
- [ ] Health check response

---

### Step 3: Deploy Frontend Service

1. Click **"New +"** → **"Web Service"**
2. Select **"Deploy an existing image from a registry"**

**Configuration:**
```
Service Name: fe-todo
Image URL: docker.io/yourdockerhub/fe-todo:YOURSTUDENTID
Region: Oregon (same as backend)
Plan: Free
```

**Environment Variables:**
```
Key: REACT_APP_API_URL
Value: https://be-todo-xxxx.onrender.com
(Use your actual backend URL from Step 2)
```

3. Click **"Create Web Service"**
4. Wait for deployment (2-3 minutes)

**Test Frontend:**
Open your frontend URL: `https://fe-todo-xxxx.onrender.com`

**Screenshot Checklist:**
- [ ] Service configuration page
- [ ] Deployed application showing todo interface
- [ ] Creating a todo successfully
- [ ] Todo persisted after page refresh

---

## Part B: Automated Deployment from GitHub

### Step 1: Prepare GitHub Repository

**Repository Structure:**
```
your-repo/
├── frontend/
│   ├── Dockerfile
│   └── ...
├── backend/
│   ├── Dockerfile
│   └── ...
├── render.yaml
├── .gitignore
└── README.md
```

**Verify .gitignore:**
```
.env
.env.local
node_modules/
```

**Push to GitHub:**
```bash
git init
git add .
git commit -m "Initial commit: Todo app with CI/CD"
git remote add origin https://github.com/username/repo-name.git
git push -u origin main
```

**Screenshot Checklist:**
- [ ] GitHub repository showing all files
- [ ] render.yaml visible in root

---

### Step 2: Connect GitHub to Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Blueprint"**
3. Click **"Connect GitHub"** (if first time)
4. Authorize Render to access your repositories
5. Select your repository from the list

**Screenshot Checklist:**
- [ ] GitHub authorization page
- [ ] Repository selection page

---

### Step 3: Review and Apply Blueprint

Render will automatically detect `render.yaml` and parse it.

**You should see 3 services:**
1. `todo-db` (PostgreSQL)
2. `be-todo` (Backend Web Service)
3. `fe-todo` (Frontend Web Service)

**Review each service:**
- Database settings
- Dockerfile paths
- Environment variables
- Auto-deploy settings

**Click "Apply"**

**Screenshot Checklist:**
- [ ] Blueprint review page showing all 3 services
- [ ] Service configurations

---

### Step 4: Monitor Deployment

Watch the deployment in the Events tab:

**Expected sequence:**
1. Database provisioning (1-2 minutes)
2. Backend building and deploying (3-5 minutes)
3. Frontend building and deploying (2-3 minutes)

**Each service should show:**
- ⏳ "Build in progress"
- ⏳ "Deploying"
- ✅ "Live"

**Screenshot Checklist:**
- [ ] All services showing "Live" status
- [ ] Backend service logs showing "Server running"
- [ ] Frontend service accessible

---

### Step 5: Test Automated Deployment

**Make a code change:**
```bash
# Edit frontend/src/App.js
# Change: <h1>📝 Todo List Application</h1>
# To: <h1>📝 Todo List Application v2.0</h1>

git add .
git commit -m "Update: Add version to header"
git push origin main
```

**What happens automatically:**
1. Render detects the push
2. Triggers a new build for frontend service
3. Deploys the updated image

**Watch in Render Dashboard:**
- Navigate to `fe-todo` service
- Check "Events" tab
- See "Deploy triggered by push"

**Verify:**
- Open frontend URL
- Hard refresh (Ctrl+Shift+R)
- See "v2.0" in header

**Screenshot Checklist:**
- [ ] Git push confirmation
- [ ] Render showing "Deploy triggered"
- [ ] Updated application with v2.0

---

## Environment Variables Reference

### Backend Environment Variables

| Variable | Source | Example | Notes |
|----------|--------|---------|-------|
| `DB_HOST` | Render DB | `dpg-xxx.oregon-postgres.render.com` | Internal host |
| `DB_USER` | Render DB | `todo_user` | From DB creation |
| `DB_PASSWORD` | Render DB | Auto-generated | From DB info |
| `DB_NAME` | Render DB | `todo_db` | Set during creation |
| `DB_PORT` | Static | `5432` | PostgreSQL default |
| `PORT` | Static | `5000` | Express server port |
| `NODE_ENV` | Static | `production` | Node environment |

### Frontend Environment Variables

| Variable | Source | Example | Notes |
|----------|--------|---------|-------|
| `REACT_APP_API_URL` | Backend URL | `https://be-todo-xxx.onrender.com` | Must match backend |

### How to Set Environment Variables

**Method 1: Render Dashboard (Part A)**
1. Go to service
2. Click "Environment" tab
3. Click "Add Environment Variable"
4. Enter key and value
5. Save changes

**Method 2: render.yaml (Part B)**
```yaml
envVars:
  - key: PORT
    value: 5000
  - key: DB_HOST
    fromDatabase:
      name: todo-db
      property: host
```

---

## Troubleshooting

### Issue 1: Build Failed

**Symptoms:**
- "Build failed" in Events
- Red status indicator

**Solutions:**
1. Check build logs for specific error
2. Verify Dockerfile syntax
3. Ensure all required files are in repository
4. Check if correct Dockerfile path in render.yaml

**Common errors:**
```
Error: Cannot find module 'express'
→ Solution: Ensure package.json is copied before npm install

Error: COPY failed
→ Solution: Check file paths in Dockerfile
```

---

### Issue 2: Deploy Failed

**Symptoms:**
- Build succeeded but deploy failed
- Container keeps restarting

**Solutions:**
1. Check service logs
2. Verify environment variables are set
3. Check health check path
4. Ensure port matches PORT env variable

**Check logs:**
```
Events → View Logs → Real-time logs
```

---

### Issue 3: Database Connection Error

**Symptoms:**
- Backend logs show "ECONNREFUSED"
- Health check fails

**Solutions:**
1. Verify DB_HOST uses **internal** host, not external
2. Check database is "Available"
3. Verify all DB credentials match
4. Check if database allows connections from backend

**Verify credentials:**
Navigate to database → Info → Compare with backend env vars

---

### Issue 4: Frontend Can't Connect to Backend

**Symptoms:**
- Frontend loads but shows connection errors
- Network errors in browser console

**Solutions:**
1. Verify REACT_APP_API_URL is correct
2. Check backend service is "Live"
3. Test backend health endpoint directly
4. Rebuild frontend after changing env vars

**Important:** Environment variables are build-time for React!
After changing `REACT_APP_API_URL`, you must redeploy frontend.

---

### Issue 5: Auto-Deploy Not Triggering

**Symptoms:**
- Pushed to GitHub but no deployment
- No new events in Render

**Solutions:**
1. Check Blueprint settings
2. Verify branch name matches (main vs master)
3. Check if manual deploy is disabled
4. Disconnect and reconnect GitHub

**Enable auto-deploy:**
Service → Settings → Auto-Deploy → Yes

---

### Issue 6: Free Tier Limitations

**Symptoms:**
- Services spin down after 15 minutes of inactivity
- First request takes 30-60 seconds

**Understanding Free Tier:**
- Services sleep after 15 min of inactivity
- Wake up on first request (cold start)
- 750 hours/month free
- Database never sleeps

**Solutions:**
- Upgrade to paid plan ($7/month per service)
- Use external ping service (UptimeRobot)
- Accept cold starts as part of free tier

---

### Issue 7: Cannot Find Dockerfile

**Symptoms:**
- "Dockerfile not found" error
- Build fails immediately

**Solutions:**
1. Verify Dockerfile exists in correct location
2. Check dockerfilePath in render.yaml:
```yaml
dockerfilePath: ./backend/Dockerfile
```
3. Ensure case-sensitive paths
4. Check file is committed to git

---

## Useful Render Commands

### Check Service Status
```bash
# Via API (requires API key)
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://api.render.com/v1/services/YOUR_SERVICE_ID
```

### Manual Deploy
1. Go to service dashboard
2. Click "Manual Deploy"
3. Select "Clear build cache & deploy"

### View Logs
1. Service → Logs
2. Select time range
3. Filter by severity

### Shell Access
1. Service → Shell
2. Opens web-based terminal
3. Limited to 1 hour sessions

---

## Best Practices

### ✅ Do's
- Use internal database URLs for backend
- Set all environment variables before deploying
- Use health check endpoints
- Monitor logs after deployment
- Test locally with Docker Compose first
- Use .env.example files as templates
- Document all environment variables

### ❌ Don'ts
- Don't commit .env files
- Don't use external DB URLs for backend
- Don't forget to redeploy frontend after env changes
- Don't use hardcoded values
- Don't skip health checks
- Don't ignore build warnings

---

## Render Dashboard Overview

### Key Sections

**Dashboard Home:**
- All services at a glance
- Status indicators
- Quick actions

**Service Page:**
- Logs: Real-time and historical
- Events: Deployment history
- Environment: Env variables
- Settings: Service configuration
- Metrics: Usage stats (paid plans)
- Shell: Terminal access

**Database Page:**
- Info: Connection details
- Metrics: Usage stats
- Backups: Automated backups (paid plans)
- Settings: Database configuration

---

## Cost Breakdown

### Free Tier Includes:
- 750 hours/month web services
- 1 GB RAM per service
- Unlimited PostgreSQL storage (90 days retention)
- Automatic HTTPS
- Custom domains

### Paid Plans Start At:
- Web Service: $7/month (never sleeps)
- Database: $7/month (1 GB storage, continuous backups)

---

## Additional Resources

- Render Documentation: https://render.com/docs
- Blueprint Specification: https://render.com/docs/blueprint-spec
- Environment Variables: https://render.com/docs/configure-environment-variables
- Dockerfiles on Render: https://render.com/docs/docker
- Troubleshooting: https://render.com/docs/troubleshooting-deploys

---

## Support

If you encounter issues:
1. Check Render status page: https://status.render.com/
2. Search Render community: https://community.render.com/
3. Contact Render support: https://render.com/docs/support

---

**Last Updated:** March 12, 2026
