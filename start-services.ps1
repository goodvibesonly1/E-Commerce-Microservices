# E-Commerce Microservices Startup Script (PowerShell)
# This script starts all microservices in the correct order with health checks

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " E-Commerce Microservices Startup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$BaseDir = Join-Path $PSScriptRoot "micro-services-app"

# Check if Java is available
Write-Host "[1/8] Checking Java installation..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java is installed. Proceeding..." -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Java 17 and try again" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Function to wait for service to be ready
function Wait-ForService {
    param(
        [string]$Url,
        [int]$MaxWaitSeconds = 60,
        [string]$ServiceName
    )
    
    Write-Host "Waiting for $ServiceName to be ready..." -ForegroundColor Yellow
    $counter = 0
    
    while ($counter -lt $MaxWaitSeconds) {
        try {
            $response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 400) {
                Write-Host "$ServiceName is ready! (after $counter seconds)" -ForegroundColor Green
                return $true
            }
        } catch {
            # Service not ready yet, continue waiting
        }
        
        Start-Sleep -Seconds 1
        $counter++
    }
    
    Write-Host "WARNING: $ServiceName did not respond after $MaxWaitSeconds seconds" -ForegroundColor Yellow
    Write-Host "Continuing anyway... Check the service terminal for errors." -ForegroundColor Yellow
    return $false
}

# Start Discovery Service (Eureka Server)
Write-Host "[2/8] Starting Discovery Service (Eureka) on port 8761..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "discovery-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8761" -MaxWaitSeconds 60 -ServiceName "Discovery Service"
Write-Host ""

# Start Config Service
Write-Host "[3/8] Starting Config Service on port 9999..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "config-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:9999/actuator/health" -MaxWaitSeconds 45 -ServiceName "Config Service"
Write-Host ""

# Start Customer Service
Write-Host "[4/8] Starting Customer Service on port 8081..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "customer-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8081/actuator/health" -MaxWaitSeconds 45 -ServiceName "Customer Service"
Write-Host ""

# Start Inventory Service
Write-Host "[5/8] Starting Inventory Service on port 8082..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "inventory-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8082/actuator/health" -MaxWaitSeconds 45 -ServiceName "Inventory Service"
Write-Host ""

# Start Billing Service
Write-Host "[6/8] Starting Billing Service on port 8083..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "billing-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8083/actuator/health" -MaxWaitSeconds 45 -ServiceName "Billing Service"
Write-Host ""

# Start Gateway Service
Write-Host "[7/8] Starting Gateway Service on port 8888..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "gateway-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8888/actuator/health" -MaxWaitSeconds 45 -ServiceName "Gateway Service"
Write-Host ""

# Start Chatbot Service
Write-Host "[8/8] Starting Chatbot Service on port 8088..." -ForegroundColor Cyan
Set-Location (Join-Path $BaseDir "chatbot-service")
Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\mvnw.cmd spring-boot:run" -WindowStyle Normal
Wait-ForService -Url "http://localhost:8088/actuator/health" -MaxWaitSeconds 45 -ServiceName "Chatbot Service"
Write-Host ""

Write-Host "============================================" -ForegroundColor Green
Write-Host " All services are running!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor Cyan
Write-Host "  - Eureka Dashboard:  http://localhost:8761"
Write-Host "  - Config Service:    http://localhost:9999"
Write-Host "  - Customer Service:  http://localhost:8081/api/customers"
Write-Host "  - Inventory Service: http://localhost:8082/api/products"
Write-Host "  - Billing Service:   http://localhost:8083/api/bills"
Write-Host "  - Gateway Service:   http://localhost:8888"
Write-Host "  - Chatbot Service:   http://localhost:8088"
Write-Host ""
Write-Host "Gateway Routes (recommended):" -ForegroundColor Cyan
Write-Host "  - Customers:  http://localhost:8888/customer-service/api/customers"
Write-Host "  - Inventory:  http://localhost:8888/inventory-service/api/products"
Write-Host "  - Billing:    http://localhost:8888/billing-service/api/bills"
Write-Host ""
Write-Host "All services registered in Eureka: http://localhost:8761" -ForegroundColor Yellow
Write-Host ""
Write-Host "To stop all services, run: .\stop-services.bat" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to close this window"
