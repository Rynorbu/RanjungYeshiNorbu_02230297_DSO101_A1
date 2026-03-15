# Docker Commands Cheatsheet

## 🐳 Basic Docker Commands

### Build and Run
```bash
# Build an image
docker build -t image-name:tag .

# Run a container
docker run -p 8080:80 image-name:tag

# Run in detached mode
docker run -d -p 8080:80 image-name:tag

# Run with environment variables
docker run -e DB_HOST=localhost -p 8080:80 image-name:tag
```

### Container Management
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop container-id

# Remove a container
docker rm container-id

# Remove all stopped containers
docker container prune
```

### Image Management
```bash
# List images
docker images

# Remove an image
docker rmi image-id

# Remove unused images
docker image prune

# Tag an image
docker tag source-image:tag target-image:tag
```

### Docker Hub
```bash
# Login to Docker Hub
docker login

# Push image to Docker Hub
docker push username/image-name:tag

# Pull image from Docker Hub
docker pull username/image-name:tag

# Logout
docker logout
```

## 🔧 Docker Compose Commands

### Basic Operations
```bash
# Start services
docker-compose up

# Start in detached mode
docker-compose up -d

# Start and rebuild
docker-compose up --build

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Service Management
```bash
# View running services
docker-compose ps

# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# Logs for specific service
docker-compose logs backend

# Restart a service
docker-compose restart backend

# Stop a specific service
docker-compose stop frontend
```

### Building and Cleaning
```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build backend

# Build without cache
docker-compose build --no-cache

# Remove stopped containers
docker-compose rm
```

## 📦 This Project's Commands

### Development
```bash
# Start all services (database, backend, frontend)
docker-compose up --build

# Start in background
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Clean restart (removes data)
docker-compose down -v
docker-compose up --build
```

### Building Images for Docker Hub
```bash
# Backend (replace with your Docker Hub username and student ID)
cd backend
docker build -t yourdockerhub/be-todo:02190108 .
docker push yourdockerhub/be-todo:02190108

# Frontend
cd ../frontend
docker build -t yourdockerhub/fe-todo:02190108 .
docker push yourdockerhub/fe-todo:02190108
```

### Debugging
```bash
# Execute command in running container
docker exec -it container-name /bin/sh

# Access database
docker exec -it todo-postgres psql -U postgres -d todo_db

# View container logs
docker logs container-id

# Inspect container
docker inspect container-id

# Check container processes
docker top container-id
```

### Cleanup
```bash
# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune -a

# Remove all unused volumes
docker volume prune

# Remove everything unused
docker system prune -a --volumes
```

## 🔍 Inspection and Monitoring

### Container Information
```bash
# Container stats (CPU, memory, etc.)
docker stats

# Inspect container details
docker inspect container-id

# View port mappings
docker port container-id

# View container processes
docker top container-id
```

### Network
```bash
# List networks
docker network ls

# Inspect network
docker network inspect network-name

# Create network
docker network create network-name
```

### Volume
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect volume-name

# Remove volume
docker volume rm volume-name
```

## 💡 Useful Tips

### View Resource Usage
```bash
# Show disk usage
docker system df

# Show detailed disk usage
docker system df -v
```

### Health Checks
```bash
# Test backend health
curl http://localhost:5000/api/health

# Test from another container
docker exec frontend curl http://backend:5000/api/health
```

### Shell Access
```bash
# Access backend container shell
docker exec -it todo-backend /bin/sh

# Access frontend container shell
docker exec -it todo-frontend /bin/sh

# Access database
docker exec -it todo-postgres psql -U postgres
```

### Copy Files
```bash
# Copy from container to host
docker cp container-id:/path/in/container /path/on/host

# Copy from host to container
docker cp /path/on/host container-id:/path/in/container
```

## 🚨 Troubleshooting Commands

### Port already in use
```bash
# Windows: Find process using port
netstat -ano | findstr :5000

# Kill process (replace PID)
taskkill /PID <PID> /F
```

### Cannot connect to Docker daemon
```bash
# Check Docker service status (Windows)
# Open Docker Desktop

# Restart Docker service
# Right-click Docker Desktop icon → Restart
```

### Build cache issues
```bash
# Build without cache
docker-compose build --no-cache

# Remove all images and rebuild
docker-compose down --rmi all
docker-compose up --build
```

### Database connection issues
```bash
# Check if database is running
docker ps | grep postgres

# View database logs
docker-compose logs db

# Restart database
docker-compose restart db
```

## 📚 References

- Docker Documentation: https://docs.docker.com/
- Docker Compose Documentation: https://docs.docker.com/compose/
- Docker Hub Registry: https://hub.docker.com/
