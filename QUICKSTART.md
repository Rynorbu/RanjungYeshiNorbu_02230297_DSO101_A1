# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Docker Desktop installed and running
- Git installed

### Steps

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd studentname_studentnumber_DSO101_A1
```

2. **Setup environment files:**
```bash
# Backend
cd backend
copy .env.example .env
cd ..

# Frontend
cd frontend
copy .env.example .env
cd ..
```

3. **Start the application:**
```bash
docker-compose up --build
```

4. **Access the application:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- API Health: http://localhost:5000/api/health

### Quick Commands

```bash
# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild specific service
docker-compose up --build backend

# Remove all data (including database)
docker-compose down -v
```

### Test API Endpoints

```bash
# Windows PowerShell
# Get all todos
Invoke-RestMethod -Uri "http://localhost:5000/api/todos" -Method Get

# Create a todo
Invoke-RestMethod -Uri "http://localhost:5000/api/todos" -Method Post -ContentType "application/json" -Body '{"title":"My First Todo","description":"Testing the API"}'

# Health check
Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method Get
```

### Troubleshooting

**Port already in use?**
```bash
# Stop all containers
docker-compose down

# Or change ports in docker-compose.yml
```

**Database connection error?**
```bash
# Restart with clean state
docker-compose down -v
docker-compose up --build
```

**Can't see changes?**
```bash
# Clear browser cache and hard refresh
# Windows: Ctrl + Shift + R
# Mac: Cmd + Shift + R
```

For detailed instructions, see [README.md](README.md)
