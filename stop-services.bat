@echo off
REM E-Commerce Microservices Stop Script
REM This script stops all running Spring Boot microservices

echo ============================================
echo  E-Commerce Microservices Stop Script
echo ============================================
echo.
echo This script will stop all Spring Boot services running on the configured ports.
echo.

REM Function to kill process on a specific port
echo Stopping services...
echo.

REM Stop Gateway Service (8888)
echo [1/6] Stopping Gateway Service (port 8888)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8888 ^| findstr LISTENING') do (
    echo Found process %%a on port 8888
    taskkill /F /PID %%a >nul 2>&1
)

REM Stop Billing Service (8083)
echo [2/6] Stopping Billing Service (port 8083)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8083 ^| findstr LISTENING') do (
    echo Found process %%a on port 8083
    taskkill /F /PID %%a >nul 2>&1
)

REM Stop Inventory Service (8082)
echo [3/6] Stopping Inventory Service (port 8082)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8082 ^| findstr LISTENING') do (
    echo Found process %%a on port 8082
    taskkill /F /PID %%a >nul 2>&1
)

REM Stop Customer Service (8081)
echo [4/6] Stopping Customer Service (port 8081)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8081 ^| findstr LISTENING') do (
    echo Found process %%a on port 8081
    taskkill /F /PID %%a >nul 2>&1
)

REM Stop Config Service (9999)
echo [5/6] Stopping Config Service (port 9999)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9999 ^| findstr LISTENING') do (
    echo Found process %%a on port 9999
    taskkill /F /PID %%a >nul 2>&1
)

REM Stop Discovery Service (8761)
echo [6/6] Stopping Discovery Service (port 8761)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8761 ^| findstr LISTENING') do (
    echo Found process %%a on port 8761
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ============================================
echo  All services have been stopped!
echo ============================================
echo.
pause
