@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem --- Help ---
if "%~1"=="/?" (
    echo Usage: %~nx0 [editor_path]
    echo.
    echo Sets the default editor for AutoHotkey ^(.ahk^) script files in the Windows registry.
    echo.
    echo   [editor_path]  Optional: Full path to any editor executable to use instead of VS Code.
    echo                  If omitted, the script auto-detects VS Code by checking PATH first,
    echo                  then falling back to common installation locations.
    echo                  A confirmation prompt is shown if the detected path is non-standard.
    echo.
    echo Examples:
    echo   %~nx0
    echo   %~nx0 "C:\My Apps\Custom Editor\editor.exe"
    exit /b 0
)

rem --- Use provided path if given ---
if not "%~1"=="" (
    if not exist "%~1" (
        echo Error: The specified editor was not found at:
        echo   %~1
        pause
        exit /b 1
    )
    set "EDITOR_EXE=%~1"
    goto :apply
)

rem --- Auto-detect VS Code: try PATH first ---
set "EDITOR_EXE="
for /f "delims=" %%i in ('where code.exe 2^>nul') do (
    if not defined EDITOR_EXE set "EDITOR_EXE=%%i"
)

rem --- Fall back to common installation paths ---
if not defined EDITOR_EXE if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" set "EDITOR_EXE=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
if not defined EDITOR_EXE if exist "%ProgramFiles%\Microsoft VS Code\Code.exe" set "EDITOR_EXE=%ProgramFiles%\Microsoft VS Code\Code.exe"
if not defined EDITOR_EXE if exist "%ProgramFiles%\Visual Studio Code\Code.exe" set "EDITOR_EXE=%ProgramFiles%\Visual Studio Code\Code.exe"

if not defined EDITOR_EXE (
    echo Error: VS Code not found in PATH or in common installation locations:
    echo   %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe
    echo   %ProgramFiles%\Microsoft VS Code\Code.exe
    echo   %ProgramFiles%\Visual Studio Code\Code.exe
    echo Please install VS Code, add it to PATH, or pass the editor path as an argument.
    echo Run "%~nx0 /?" for usage information.
    pause
    exit /b 1
)

rem --- Warn if path does not match a known installation pattern ---
rem     Uses string substitution: if replacing the known suffix changes the string, it was present.
set "KNOWN_PATH=0"
if not "%EDITOR_EXE:Microsoft VS Code\Code.exe=%"=="%EDITOR_EXE%" set "KNOWN_PATH=1"
if not "%EDITOR_EXE:Visual Studio Code\Code.exe=%"=="%EDITOR_EXE%" set "KNOWN_PATH=1"
if "%KNOWN_PATH%"=="0" (
    echo Warning: VS Code was found at an unexpected location:
    echo   %EDITOR_EXE%
    set "CONFIRM=n"
    set /p "CONFIRM=This does not look like a standard installation path. Continue anyway? [y/N] "
    if /i not "!CONFIRM!"=="y" (
        echo Aborted.
        pause
        exit /b 1
    )
)

:apply
echo Using editor: %EDITOR_EXE%
reg add "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command" ^
    /ve /t REG_SZ ^
    /d "\"%EDITOR_EXE%\" \"%%1\"" ^
    /f
echo Done. AHK files will now open with the specified editor by default.
pause
