# API Testing Guide

## 🧪 Complete API Testing Documentation

### Base URLs
- **Local Development:** `http://localhost:5000`
- **Production (Render):** `https://be-todo-xxxx.onrender.com` (replace with your URL)

---

## API Endpoints Overview

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/` | API information | No |
| GET | `/api/health` | Health check | No |
| GET | `/api/todos` | Get all todos | No |
| GET | `/api/todos/:id` | Get single todo | No |
| POST | `/api/todos` | Create new todo | No |
| PUT | `/api/todos/:id` | Update todo | No |
| DELETE | `/api/todos/:id` | Delete todo | No |

---

## Testing Methods

### 1. Using cURL (Linux/Mac/Git Bash)

#### Health Check
```bash
curl http://localhost:5000/api/health
```

#### Get All Todos
```bash
curl http://localhost:5000/api/todos
```

#### Create Todo
```bash
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, bread"
  }'
```

#### Update Todo
```bash
curl -X PUT http://localhost:5000/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries (Updated)",
    "completed": true
  }'
```

#### Delete Todo
```bash
curl -X DELETE http://localhost:5000/api/todos/1
```

---

### 2. Using PowerShell (Windows)

#### Health Check
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method Get
```

#### Get All Todos
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/todos" -Method Get
```

#### Create Todo
```powershell
$body = @{
    title = "Buy groceries"
    description = "Milk, eggs, bread"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/todos" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

#### Update Todo
```powershell
$body = @{
    title = "Buy groceries (Updated)"
    completed = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/todos/1" `
  -Method Put `
  -ContentType "application/json" `
  -Body $body
```

#### Delete Todo
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/todos/1" -Method Delete
```

---

### 3. Using Postman

#### Setup
1. Download Postman: https://www.postman.com/downloads/
2. Create new collection: "Todo API Tests"
3. Set base URL variable: `{{baseUrl}}` = `http://localhost:5000`

#### Test Sequence

**1. Health Check**
```
GET {{baseUrl}}/api/health
```

**2. Get All Todos (Empty)**
```
GET {{baseUrl}}/api/todos
```

**3. Create First Todo**
```
POST {{baseUrl}}/api/todos
Body (JSON):
{
  "title": "Complete DSO101 Assignment",
  "description": "Deploy todo app to Render"
}
```

**4. Create Second Todo**
```
POST {{baseUrl}}/api/todos
Body (JSON):
{
  "title": "Test API Endpoints",
  "description": "Verify all CRUD operations"
}
```

**5. Get All Todos (Should have 2)**
```
GET {{baseUrl}}/api/todos
```

**6. Get Single Todo**
```
GET {{baseUrl}}/api/todos/1
```

**7. Update Todo**
```
PUT {{baseUrl}}/api/todos/1
Body (JSON):
{
  "title": "Complete DSO101 Assignment (Updated)",
  "completed": true
}
```

**8. Delete Todo**
```
DELETE {{baseUrl}}/api/todos/2
```

---

### 4. Using Browser/JavaScript Console

Open browser console (F12) and paste:

```javascript
// Base URL
const API_URL = 'http://localhost:5000';

// Helper function
async function apiCall(endpoint, method = 'GET', data = null) {
  const options = {
    method,
    headers: { 'Content-Type': 'application/json' }
  };
  if (data) options.body = JSON.stringify(data);
  
  const response = await fetch(`${API_URL}${endpoint}`, options);
  return await response.json();
}

// Test endpoints
await apiCall('/api/health');
await apiCall('/api/todos');
await apiCall('/api/todos', 'POST', { 
  title: 'Test Todo', 
  description: 'From browser console' 
});
```

---

## Detailed API Documentation

### 1. Root Endpoint

**GET `/`**

Returns API information and available endpoints.

**Request:**
```bash
GET http://localhost:5000/
```

**Response:**
```json
{
  "message": "🚀 Todo API is running",
  "version": "1.0.0",
  "endpoints": {
    "health": "/api/health",
    "todos": "/api/todos",
    "singleTodo": "/api/todos/:id"
  }
}
```

---

### 2. Health Check

**GET `/api/health`**

Check if API and database are running.

**Request:**
```bash
GET http://localhost:5000/api/health
```

**Success Response (200):**
```json
{
  "status": "healthy",
  "timestamp": "2026-03-12T10:30:00.000Z",
  "database": "connected"
}
```

---

### 3. Get All Todos

**GET `/api/todos`**

Retrieve all todos from the database.

**Request:**
```bash
GET http://localhost:5000/api/todos
```

**Success Response (200):**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "id": 1,
      "title": "Buy groceries",
      "description": "Milk, eggs, bread",
      "completed": false,
      "created_at": "2026-03-12T10:00:00.000Z",
      "updated_at": "2026-03-12T10:00:00.000Z"
    },
    {
      "id": 2,
      "title": "Complete assignment",
      "description": "DSO101 project",
      "completed": true,
      "created_at": "2026-03-12T11:00:00.000Z",
      "updated_at": "2026-03-12T11:30:00.000Z"
    }
  ]
}
```

**Empty Response (200):**
```json
{
  "success": true,
  "count": 0,
  "data": []
}
```

---

### 4. Get Single Todo

**GET `/api/todos/:id`**

Retrieve a specific todo by ID.

**Request:**
```bash
GET http://localhost:5000/api/todos/1
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "completed": false,
    "created_at": "2026-03-12T10:00:00.000Z",
    "updated_at": "2026-03-12T10:00:00.000Z"
  }
}
```

**Not Found Response (404):**
```json
{
  "success": false,
  "error": "Todo not found"
}
```

---

### 5. Create Todo

**POST `/api/todos`**

Create a new todo item.

**Request:**
```bash
POST http://localhost:5000/api/todos
Content-Type: application/json

{
  "title": "Buy groceries",
  "description": "Milk, eggs, bread"
}
```

**Request Body Schema:**
```json
{
  "title": "string (required, max 255 chars)",
  "description": "string (optional)"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Todo created successfully",
  "data": {
    "id": 3,
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "completed": false,
    "created_at": "2026-03-12T12:00:00.000Z",
    "updated_at": "2026-03-12T12:00:00.000Z"
  }
}
```

**Validation Error (400):**
```json
{
  "success": false,
  "error": "Title is required"
}
```

---

### 6. Update Todo

**PUT `/api/todos/:id`**

Update an existing todo. All fields are optional.

**Request:**
```bash
PUT http://localhost:5000/api/todos/1
Content-Type: application/json

{
  "title": "Buy groceries (Updated)",
  "description": "Milk, eggs, bread, coffee",
  "completed": true
}
```

**Request Body Schema:**
```json
{
  "title": "string (optional)",
  "description": "string (optional)",
  "completed": "boolean (optional)"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Todo updated successfully",
  "data": {
    "id": 1,
    "title": "Buy groceries (Updated)",
    "description": "Milk, eggs, bread, coffee",
    "completed": true,
    "created_at": "2026-03-12T10:00:00.000Z",
    "updated_at": "2026-03-12T12:30:00.000Z"
  }
}
```

**Not Found Response (404):**
```json
{
  "success": false,
  "error": "Todo not found"
}
```

---

### 7. Delete Todo

**DELETE `/api/todos/:id`**

Delete a todo permanently.

**Request:**
```bash
DELETE http://localhost:5000/api/todos/1
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Todo deleted successfully",
  "data": {
    "id": 1,
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "completed": false,
    "created_at": "2026-03-12T10:00:00.000Z",
    "updated_at": "2026-03-12T10:00:00.000Z"
  }
}
```

**Not Found Response (404):**
```json
{
  "success": false,
  "error": "Todo not found"
}
```

---

## Error Responses

### 400 Bad Request
Validation error or missing required fields.

```json
{
  "success": false,
  "error": "Title is required"
}
```

### 404 Not Found
Resource doesn't exist or endpoint not found.

```json
{
  "success": false,
  "error": "Todo not found"
}
```

### 500 Internal Server Error
Server or database error.

```json
{
  "success": false,
  "error": "Failed to create todo"
}
```

---

## Testing Scenarios

### Scenario 1: Complete CRUD Flow

```bash
# 1. Verify API is running
curl http://localhost:5000/api/health

# 2. Create todos
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Task 1","description":"First task"}'

curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Task 2","description":"Second task"}'

# 3. Get all todos
curl http://localhost:5000/api/todos

# 4. Update first todo
curl -X PUT http://localhost:5000/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# 5. Get single todo
curl http://localhost:5000/api/todos/1

# 6. Delete second todo
curl -X DELETE http://localhost:5000/api/todos/2

# 7. Verify deletion
curl http://localhost:5000/api/todos
```

---

### Scenario 2: Error Handling

```bash
# Test empty title
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"","description":"Empty title test"}'
# Expected: 400 error

# Test non-existent todo
curl http://localhost:5000/api/todos/9999
# Expected: 404 error

# Test invalid endpoint
curl http://localhost:5000/api/invalid
# Expected: 404 error
```

---

### Scenario 3: Production Testing

```bash
# Replace with your Render URL
PROD_URL="https://be-todo-xxxx.onrender.com"

# Health check
curl $PROD_URL/api/health

# Create todo in production
curl -X POST $PROD_URL/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"Production Test","description":"Testing live API"}'

# Get all todos
curl $PROD_URL/api/todos
```

---

## Automated Testing Script

Save as `test-api.ps1` (Windows PowerShell):

```powershell
# API Testing Script
$baseUrl = "http://localhost:5000"

Write-Host "Starting API Tests..." -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "`n[Test 1] Health Check" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/health"
    Write-Host "✓ Passed: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test 2: Get All Todos
Write-Host "`n[Test 2] Get All Todos" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/todos"
    Write-Host "✓ Passed: Found $($response.count) todos" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test 3: Create Todo
Write-Host "`n[Test 3] Create Todo" -ForegroundColor Yellow
try {
    $body = @{ title = "Test Todo"; description = "Automated test" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$baseUrl/api/todos" -Method Post -ContentType "application/json" -Body $body
    Write-Host "✓ Passed: Created todo with ID $($response.data.id)" -ForegroundColor Green
    $todoId = $response.data.id
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test 4: Get Single Todo
Write-Host "`n[Test 4] Get Single Todo" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/todos/$todoId"
    Write-Host "✓ Passed: Retrieved todo '$($response.data.title)'" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test 5: Update Todo
Write-Host "`n[Test 5] Update Todo" -ForegroundColor Yellow
try {
    $body = @{ completed = $true } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$baseUrl/api/todos/$todoId" -Method Put -ContentType "application/json" -Body $body
    Write-Host "✓ Passed: Updated todo to completed=$($response.data.completed)" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test 6: Delete Todo
Write-Host "`n[Test 6] Delete Todo" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/todos/$todoId" -Method Delete
    Write-Host "✓ Passed: Deleted todo ID $todoId" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

Write-Host "`nAll tests completed!" -ForegroundColor Cyan
```

Run with: `.\test-api.ps1`

---

## Performance Testing

### Using Apache Bench (ab)

```bash
# Install ab (comes with Apache)
# Windows: Download Apache or use WSL

# Test health endpoint (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost:5000/api/health

# Test GET todos
ab -n 100 -c 10 http://localhost:5000/api/todos

# Test POST todos
ab -n 50 -c 5 -p todo.json -T application/json http://localhost:5000/api/todos
```

**todo.json:**
```json
{"title":"Load Test Todo","description":"Performance testing"}
```

---

## Best Practices

1. **Always test health endpoint first** to verify connectivity
2. **Use meaningful test data** that reflects real usage
3. **Test error cases** not just success paths
4. **Clean up test data** after testing
5. **Document expected responses** for team reference
6. **Use environment variables** for different environments
7. **Automate repetitive tests** with scripts
8. **Monitor API performance** under load

---

**Last Updated:** March 12, 2026
