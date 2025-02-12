@echo off
:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::--------------------------------------
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
