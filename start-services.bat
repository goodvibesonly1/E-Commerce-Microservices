@echo off
REM E-Commerce Microservices Startup Script
REM This script starts all microservices in the correct order with health checks

echo ============================================
echo  E-Commerce Microservices Startup
echo ============================================
echo.

REM Set the base directory
set BASE_DIR=%~dp0micro-services-app

REM Check if Java is available
echo [1/8] Checking Java installation...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install Java 17 and try again
    pause
    exit /b 1
)
echo Java is installed. Proceeding...
echo.

REM Start Discovery Service (Eureka Server)
echo [2/8] Starting Discovery Service (Eureka) on port 8761...
cd /d "%BASE_DIR%\discovery-service"
start "Discovery Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Eureka to be ready...
call :wait_for_service "http://localhost:8761" 60
echo.

REM Start Config Service
echo [3/8] Starting Config Service on port 9999...
cd /d "%BASE_DIR%\config-service"
start "Config Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Config Service to be ready...
call :wait_for_service "http://localhost:9999/actuator/health" 45
echo.

REM Start Customer Service
echo [4/8] Starting Customer Service on port 8081...
cd /d "%BASE_DIR%\customer-service"
start "Customer Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Customer Service to be ready...
call :wait_for_service "http://localhost:8081/actuator/health" 45
echo.

REM Start Inventory Service
echo [5/8] Starting Inventory Service on port 8082...
cd /d "%BASE_DIR%\inventory-service"
start "Inventory Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Inventory Service to be ready...
call :wait_for_service "http://localhost:8082/actuator/health" 45
echo.

REM Start Billing Service
echo [6/8] Starting Billing Service on port 8083...
cd /d "%BASE_DIR%\billing-service"
start "Billing Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Billing Service to be ready...
call :wait_for_service "http://localhost:8083/actuator/health" 45
echo.

REM Start Gateway Service
echo [7/8] Starting Gateway Service on port 8888...
cd /d "%BASE_DIR%\gateway-service"
start "Gateway Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Gateway Service to be ready...
call :wait_for_service "http://localhost:8888/actuator/health" 45
echo.

REM Start Chatbot Service
echo [8/8] Starting Chatbot Service on port 8088...
cd /d "%BASE_DIR%\chatbot-service"
start "Chatbot Service" cmd /k "mvnw.cmd spring-boot:run"
echo Waiting for Chatbot Service to be ready...
call :wait_for_service "http://localhost:8088/actuator/health" 45
echo.

echo ============================================
echo  All services are running!
echo ============================================
echo.
echo Service URLs:
echo   - Eureka Dashboard:  http://localhost:8761
echo   - Config Service:    http://localhost:9999
echo   - Customer Service:  http://localhost:8081/api/customers
echo   - Inventory Service: http://localhost:8082/api/products
echo   - Billing Service:   http://localhost:8083/api/bills
echo   - Gateway Service:   http://localhost:8888
echo   - Chatbot Service:   http://localhost:8088
echo.
echo Gateway Routes (recommended):
echo   - Customers:  http://localhost:8888/customer-service/api/customers
echo   - Inventory:  http://localhost:8888/inventory-service/api/products
echo   - Billing:    http://localhost:8888/billing-service/api/bills
echo.
echo All services registered in Eureka: http://localhost:8761
echo.
echo To stop all services, run: stop-services.bat
echo.
pause
exit /b 0

REM Function to wait for a service to be ready
:wait_for_service
setlocal
set URL=%~1
set MAX_WAIT=%~2
set COUNTER=0

:wait_loop
set /a COUNTER+=1
if %COUNTER% gtr %MAX_WAIT% (
    echo WARNING: Service did not respond after %MAX_WAIT% seconds
    echo Continuing anyway... Check the service terminal for errors.
    endlocal
    exit /b 1
)

REM Try to connect to the service
curl -s -o nul -w "%%{http_code}" %URL% 2>nul | findstr /r "^[2-3][0-9][0-9]$" >nul 2>&1
if %errorlevel% equ 0 (
    echo Service is ready! (after %COUNTER% seconds^)
    endlocal
    exit /b 0
)

REM Wait 1 second before trying again
ping 127.0.0.1 -n 2 >nul
goto wait_loop
