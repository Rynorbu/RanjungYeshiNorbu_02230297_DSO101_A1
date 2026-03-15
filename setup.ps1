# Installation Script for Windows PowerShell
# Run this script to setup the project automatically

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Todo List Application - Automated Setup" -ForegroundColor Cyan
Write-Host "DSO101 Assignment" -ForegroundColor Cyan
Write-Host "===============================================`n" -ForegroundColor Cyan

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    Write-Host "✓ Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not installed or not running" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop" -ForegroundColor Red
    exit 1
}

# Check if Docker daemon is running
try {
    docker ps | Out-Null
    Write-Host "✓ Docker daemon is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker daemon is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop" -ForegroundColor Red
    exit 1
}

# Check Node.js
Write-Host "`nChecking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js is installed: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠ Node.js is not installed (optional for Docker setup)" -ForegroundColor Yellow
}

# Setup backend environment
Write-Host "`nSetting up backend environment..." -ForegroundColor Yellow
if (Test-Path "backend\.env") {
    Write-Host "✓ Backend .env already exists" -ForegroundColor Green
} else {
    if (Test-Path "backend\.env.example") {
        Copy-Item "backend\.env.example" "backend\.env"
        Write-Host "✓ Created backend/.env from example" -ForegroundColor Green
    } else {
        Write-Host "✗ backend/.env.example not found" -ForegroundColor Red
        exit 1
    }
}

# Setup frontend environment
Write-Host "Setting up frontend environment..." -ForegroundColor Yellow
if (Test-Path "frontend\.env") {
    Write-Host "✓ Frontend .env already exists" -ForegroundColor Green
} else {
    if (Test-Path "frontend\.env.example") {
        Copy-Item "frontend\.env.example" "frontend\.env"
        Write-Host "✓ Created frontend/.env from example" -ForegroundColor Green
    } else {
        Write-Host "✗ frontend/.env.example not found" -ForegroundColor Red
        exit 1
    }
}

# Ask if user wants to install npm dependencies locally
Write-Host "`n" -ForegroundColor Yellow
$installNpm = Read-Host "Do you want to install npm dependencies locally? (y/n)"
if ($installNpm -eq 'y' -or $installNpm -eq 'Y') {
    Write-Host "`nInstalling backend dependencies..." -ForegroundColor Yellow
    Push-Location backend
    npm install
    Pop-Location
    Write-Host "✓ Backend dependencies installed" -ForegroundColor Green
    
    Write-Host "`nInstalling frontend dependencies..." -ForegroundColor Yellow
    Push-Location frontend
    npm install
    Pop-Location
    Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
}

# Ask if user wants to start Docker Compose
Write-Host "`n" -ForegroundColor Yellow
$startDocker = Read-Host "Do you want to start the application with Docker Compose? (y/n)"
if ($startDocker -eq 'y' -or $startDocker -eq 'Y') {
    Write-Host "`nStarting Docker Compose..." -ForegroundColor Yellow
    Write-Host "This may take a few minutes on first run..." -ForegroundColor Cyan
    
    docker-compose up --build -d
    
    Write-Host "`nWaiting for services to be ready..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    Write-Host "`n===============================================" -ForegroundColor Green
    Write-Host "Application is starting!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "`nAccess the application at:" -ForegroundColor Cyan
    Write-Host "  • Frontend: http://localhost:3000" -ForegroundColor White
    Write-Host "  • Backend:  http://localhost:5000" -ForegroundColor White
    Write-Host "  • API Health: http://localhost:5000/api/health" -ForegroundColor White
    Write-Host "`nView logs with:" -ForegroundColor Cyan
    Write-Host "  docker-compose logs -f" -ForegroundColor White
    Write-Host "`nStop services with:" -ForegroundColor Cyan
    Write-Host "  docker-compose down" -ForegroundColor White
    Write-Host "`n===============================================`n" -ForegroundColor Green
} else {
    Write-Host "`n===============================================" -ForegroundColor Green
    Write-Host "Setup complete!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "`nTo start the application, run:" -ForegroundColor Cyan
    Write-Host "  docker-compose up --build" -ForegroundColor White
    Write-Host "`n===============================================`n" -ForegroundColor Green
}
