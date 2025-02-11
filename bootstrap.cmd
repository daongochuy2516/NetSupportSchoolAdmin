@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Requesting elevated rights...
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit /B
)
setlocal
set "mainFolder=%TEMP%\NetSupportBootstrap"
if not exist "%mainFolder%" mkdir "%mainFolder%"
set "launcherCmd=%mainFolder%\Launcher.cmd"
echo Loading Launcher...
curl -L -o "%launcherCmd%" "https://github.com/daongochuy2516/NetSupportSchoolAdmin/raw/refs/heads/main/Launcher.cmd"
if not exist "%launcherCmd%" (
    echo Error: Failed to load Launcher!
    pause
    exit /B
)
echo Running Launcher...
cd /d "%mainFolder%"
start "" "%launcherCmd%"
exit
