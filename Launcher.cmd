@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges. Requesting elevated rights...
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit /B
)
cd /d "%~dp0"
set "resourcesDir=%~dp0Resources"
if not exist "%resourcesDir%" (
    echo Resources folder not found. Creating...
    mkdir "%resourcesDir%"
)
set "techZip=%resourcesDir%\NetSupport School Tech Console.zip"
set "tutorZip=%resourcesDir%\NetSupport School Tutor.zip"
if not exist "%techZip%" (
    echo Downloading NetSupport School Tech Console...
    curl -L -o "%techZip%" "https://github.com/daongochuy2516/NetSupportSchoolAdmin/releases/download/Resources/NetSupport.School.Tech.Console.zip"
)
if not exist "%tutorZip%" (
    echo Downloading NetSupport School Tutor...
    curl -L -o "%tutorZip%" "https://github.com/daongochuy2516/NetSupportSchoolAdmin/releases/download/Resources2/NetSupport.School.Tutor.zip"
)

:MENU
cls
echo ==========================================
echo      NetSupport School Admin Launcher
echo ==========================================
echo.
echo 1. NetSupport School Tutor
echo 2. NetSupport School Tech Console
echo 3. Kill Client
echo 4. Run Client
echo 5. Exit
echo.
set /p option=Choose an option (1-5): 

if "%option%"=="1" goto TUTOR
if "%option%"=="2" goto TECH
if "%option%"=="3" goto KILL
if "%option%"=="4" goto RUN
if "%option%"=="5" goto EXIT

echo Invalid choice. Please try again.
pause
goto MENU

:TUTOR
echo.
echo --- NetSupport School Tutor ---
taskkill /f /im client32.exe >nul 2>&1
taskkill /f /im pcinssui.exe >nul 2>&1
set "tutorDir=%TEMP%\NetSupportSchoolTutor"
if exist "%tutorDir%" (
    rmdir /s /q "%tutorDir%"
)

powershell -NoProfile -Command "Expand-Archive -Path \"%tutorZip%\" -DestinationPath \"%tutorDir%\" -Force"
set "tutorSubDir=%tutorDir%\NetSupport School Tutor"
if exist "%tutorSubDir%\pcinssui.exe" (
    echo Running pcinssui.exe...
    start "" "%tutorSubDir%\pcinssui.exe"
) else (
    echo Error: pcinssui.exe not found in "%tutorSubDir%".
)
pause
goto MENU

:TECH
echo.
echo --- NetSupport School Tech Console ---
taskkill /f /im client32.exe >nul 2>&1
taskkill /f /im nssadmui.exe >nul 2>&1
set "techDir=%TEMP%\NetSupportSchoolTechConsole"
if exist "%techDir%" (
    rmdir /s /q "%techDir%"
)

powershell -NoProfile -Command "Expand-Archive -Path \"%techZip%\" -DestinationPath \"%techDir%\" -Force"
set "techSubDir=%techDir%\NetSupport School Tech Console"
if exist "%techSubDir%\nssadmui.exe" (
    echo Running nssadmui.exe...
    start "" "%techSubDir%\nssadmui.exe"
) else (
    echo Error: nssadmui.exe not found in "%techSubDir%".
)
pause
goto MENU

:KILL
echo.
echo --- Kill Client ---
taskkill /f /im client32.exe >nul 2>&1
pause
goto MENU

:RUN
echo.
echo --- Run Client ---
start "" "C:\Program Files (x86)\NetSupport\NetSupport School\client32.exe"
pause
goto MENU

:EXIT
echo Goodbye!
exit
