@echo off
setlocal EnableExtensions

rem --- Help ---
if "%~1"=="/?" (
    echo Usage: %~nx0 [disable^|enable]
    echo.
    echo Toggles the Windows Office/Copilot hotkey ^(Ctrl+Shift+Alt+Win^) that otherwise
    echo hijacks the "Hyper" key combination used by AutoHotkey scripts.
    echo.
    echo   disable   Redirects the ms-officeapp protocol handler to a harmless token
    echo             ^(rundll32^), so the four-modifier press no longer opens Office/Copilot.
    echo   enable    Removes the override, restoring the default Windows behavior.
    echo.
    echo If no action is given, you will be prompted to choose one.
    echo The change edits HKCU ^(per-user^) and takes effect immediately; no reboot needed.
    exit /b 0
)

set "KEY=HKCU\Software\Classes\ms-officeapp\Shell\Open\Command"

rem --- Determine action from argument or prompt ---
set "ACTION=%~1"
if /i "%ACTION%"=="disable" goto :disable
if /i "%ACTION%"=="enable" goto :enable
if not "%ACTION%"=="" (
    echo Error: Unknown action "%ACTION%".
    echo Run "%~nx0 /?" for usage information.
    pause
    exit /b 1
)

echo Office/Copilot hotkey ^(Ctrl+Shift+Alt+Win^) registry toggle.
echo.
echo   [D] Disable the Office hotkey ^(free the Hyper key for AutoHotkey^)
echo   [E] Enable  the Office hotkey ^(restore default Windows behavior^)
echo.
set "CHOICE="
set /p "CHOICE=Choose an action [D/E] "
if /i "%CHOICE%"=="d" goto :disable
if /i "%CHOICE%"=="e" goto :enable
echo Aborted.
pause
exit /b 1

:disable
reg add "%KEY%" /ve /t REG_SZ /d rundll32 /f
if errorlevel 1 (
    echo Error: Failed to write the registry key. Try running as administrator.
    pause
    exit /b 1
)
echo Done. The Office/Copilot hotkey is now disabled.
pause
exit /b 0

:enable
reg delete "%KEY%" /f
if errorlevel 1 (
    echo Note: The registry key was not present ^(hotkey already at default^) or could not be removed.
    pause
    exit /b 1
)
echo Done. The Office/Copilot hotkey has been restored to its default behavior.
pause
exit /b 0
