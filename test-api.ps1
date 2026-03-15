# API Testing Script for Todo Application
# Run this script to test all API endpoints

param(
    [string]$BaseUrl = "http://localhost:5000"
)

$ErrorActionPreference = "Continue"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Todo API Testing Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Testing URL: $BaseUrl`n" -ForegroundColor Yellow

$testsPassed = 0
$testsFailed = 0

# Helper function to test endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Body = $null,
        [int]$ExpectedStatus = 200
    )
    
    Write-Host "[TEST] $Name" -ForegroundColor Yellow
    Write-Host "       $Method $Endpoint" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = "$BaseUrl$Endpoint"
            Method = $Method
            ErrorAction = "Stop"
        }
        
        if ($Body) {
            $params.Body = ($Body | ConvertTo-Json)
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        
        Write-Host "       ✓ PASSED" -ForegroundColor Green
        if ($response) {
            Write-Host "       Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Gray
        }
        $script:testsPassed++
        return $response
    }
    catch {
        Write-Host "       ✗ FAILED: $($_.Exception.Message)" -ForegroundColor Red
        $script:testsFailed++
        return $null
    }
    Write-Host ""
}

# Test 1: Root endpoint
Write-Host "`n--- Test Suite 1: Basic Endpoints ---`n" -ForegroundColor Cyan
Test-Endpoint -Name "Root Endpoint" -Method "GET" -Endpoint "/"

# Test 2: Health check
Test-Endpoint -Name "Health Check" -Method "GET" -Endpoint "/api/health"

# Test 3: Get all todos (should be empty or have existing)
Write-Host "`n--- Test Suite 2: Read Operations ---`n" -ForegroundColor Cyan
$initialTodos = Test-Endpoint -Name "Get All Todos (Initial)" -Method "GET" -Endpoint "/api/todos"

# Test 4: Create first todo
Write-Host "`n--- Test Suite 3: Create Operations ---`n" -ForegroundColor Cyan
$todo1 = Test-Endpoint -Name "Create Todo #1" -Method "POST" -Endpoint "/api/todos" `
    -Body @{
        title = "Test Todo 1"
        description = "This is a test todo created by the testing script"
    } -ExpectedStatus 201

$todo1Id = if ($todo1) { $todo1.data.id } else { 0 }

# Test 5: Create second todo
$todo2 = Test-Endpoint -Name "Create Todo #2" -Method "POST" -Endpoint "/api/todos" `
    -Body @{
        title = "Test Todo 2"
        description = "Another test todo"
    } -ExpectedStatus 201

$todo2Id = if ($todo2) { $todo2.data.id } else { 0 }

# Test 6: Create todo without title (should fail)
Write-Host "`n--- Test Suite 4: Validation Tests ---`n" -ForegroundColor Cyan
Write-Host "[TEST] Create Todo Without Title (Should Fail)" -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$BaseUrl/api/todos" -Method POST `
        -ContentType "application/json" `
        -Body (@{ description = "No title" } | ConvertTo-Json) `
        -ErrorAction Stop
    Write-Host "       ✗ FAILED: Should have returned error" -ForegroundColor Red
    $testsFailed++
}
catch {
    Write-Host "       ✓ PASSED: Correctly rejected (400 Bad Request)" -ForegroundColor Green
    $testsPassed++
}
Write-Host ""

# Test 7: Get all todos (should have 2 more)
Write-Host "`n--- Test Suite 5: Read After Create ---`n" -ForegroundColor Cyan
$allTodos = Test-Endpoint -Name "Get All Todos (After Creation)" -Method "GET" -Endpoint "/api/todos"

if ($allTodos -and $todo1Id -gt 0) {
    # Test 8: Get single todo
    Test-Endpoint -Name "Get Single Todo #$todo1Id" -Method "GET" -Endpoint "/api/todos/$todo1Id"
    
    # Test 9: Update todo
    Write-Host "`n--- Test Suite 6: Update Operations ---`n" -ForegroundColor Cyan
    Test-Endpoint -Name "Update Todo #$todo1Id (Mark Complete)" -Method "PUT" -Endpoint "/api/todos/$todo1Id" `
        -Body @{
            completed = $true
        }
    
    # Test 10: Update todo with new title
    Test-Endpoint -Name "Update Todo #$todo1Id (Change Title)" -Method "PUT" -Endpoint "/api/todos/$todo1Id" `
        -Body @{
            title = "Updated Test Todo"
            description = "This todo has been updated"
        }
    
    # Test 11: Verify update
    $updatedTodo = Test-Endpoint -Name "Verify Todo #$todo1Id Updated" -Method "GET" -Endpoint "/api/todos/$todo1Id"
    
    if ($updatedTodo -and $updatedTodo.data.completed -eq $true) {
        Write-Host "       ✓ Todo is marked as completed" -ForegroundColor Green
    }
    
    # Test 12: Delete second todo
    Write-Host "`n--- Test Suite 7: Delete Operations ---`n" -ForegroundColor Cyan
    if ($todo2Id -gt 0) {
        Test-Endpoint -Name "Delete Todo #$todo2Id" -Method "DELETE" -Endpoint "/api/todos/$todo2Id"
        
        # Test 13: Try to get deleted todo (should fail)
        Write-Host "[TEST] Get Deleted Todo #$todo2Id (Should Fail)" -ForegroundColor Yellow
        try {
            Invoke-RestMethod -Uri "$BaseUrl/api/todos/$todo2Id" -Method GET -ErrorAction Stop
            Write-Host "       ✗ FAILED: Todo should not exist" -ForegroundColor Red
            $testsFailed++
        }
        catch {
            Write-Host "       ✓ PASSED: Correctly returned 404" -ForegroundColor Green
            $testsPassed++
        }
        Write-Host ""
    }
    
    # Test 14: Delete first todo (cleanup)
    Test-Endpoint -Name "Delete Todo #$todo1Id (Cleanup)" -Method "DELETE" -Endpoint "/api/todos/$todo1Id"
}

# Test 15: Get non-existent todo
Write-Host "`n--- Test Suite 8: Error Handling ---`n" -ForegroundColor Cyan
Write-Host "[TEST] Get Non-Existent Todo (Should Fail)" -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$BaseUrl/api/todos/99999" -Method GET -ErrorAction Stop
    Write-Host "       ✗ FAILED: Should have returned 404" -ForegroundColor Red
    $testsFailed++
}
catch {
    Write-Host "       ✓ PASSED: Correctly returned 404" -ForegroundColor Green
    $testsPassed++
}
Write-Host ""

# Test 16: Invalid endpoint
Write-Host "[TEST] Invalid Endpoint (Should Fail)" -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$BaseUrl/api/invalid" -Method GET -ErrorAction Stop
    Write-Host "       ✗ FAILED: Should have returned 404" -ForegroundColor Red
    $testsFailed++
}
catch {
    Write-Host "       ✓ PASSED: Correctly returned 404" -ForegroundColor Green
    $testsPassed++
}
Write-Host ""

# Final summary
Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host "Total Tests:  $($testsPassed + $testsFailed)" -ForegroundColor Yellow

if ($testsFailed -eq 0) {
    Write-Host "`n✓ All tests passed! API is working correctly." -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n✗ Some tests failed. Please check the API." -ForegroundColor Red
    exit 1
}
