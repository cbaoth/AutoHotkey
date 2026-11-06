@echo off
setlocal EnableExtensions

rem --- Help ---
if "%~1"=="/?" (
    echo Usage: %~nx0 [disable^|enable]
    echo.
    echo Toggles the per-user Windows logo key shortcuts policy.
    echo.
    echo   disable   Disables Windows logo key shortcuts by setting NoWinKeys.
    echo   enable    Removes the NoWinKeys override, restoring the default behavior.
    echo.
    echo If no action is given, you will be prompted to choose one.
    echo The change edits HKCU ^(per-user^); sign out and back in for it to take effect.
    echo Depending on registry permissions, you may need to run from an elevated prompt.
    echo A managed policy may reapply its setting during policy refresh.
    exit /b 0
)

set "KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set "VALUE=NoWinKeys"

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

echo Windows logo key shortcuts registry toggle.
echo.
echo   [D] Disable Windows logo key shortcuts
echo   [E] Enable  Windows logo key shortcuts ^(remove the override^)
echo.
set "CHOICE="
set /p "CHOICE=Choose an action [D/E] "
if /i "%CHOICE%"=="d" goto :disable
if /i "%CHOICE%"=="e" goto :enable
echo Aborted.
pause
exit /b 1

:disable
reg add "%KEY%" /v "%VALUE%" /t REG_DWORD /d 1 /f
if errorlevel 1 (
    echo Error: Failed to write the current user's registry value.
    echo Try running from an elevated command prompt if permitted.
    pause
    exit /b 1
)
echo Done. Windows logo key shortcuts are disabled by the per-user policy.
echo Sign out and back in for the change to take effect.
pause
exit /b 0

:enable
reg delete "%KEY%" /v "%VALUE%" /f
if errorlevel 1 (
    echo Note: The value was not present ^(already at default^) or could not be removed.
    pause
    exit /b 1
)
echo Done. The NoWinKeys override has been removed.
echo Sign out and back in for the change to take effect.
pause
exit /b 0
