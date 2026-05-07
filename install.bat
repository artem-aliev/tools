@echo off
setlocal enabledelayedexpansion

rem dbless installer — creates a self-contained install in %USERPROFILE%\.local\dbless
rem Independent of the source repo; repo can be deleted after install.

set "BIN_DIR=%USERPROFILE%\.local\bin"
set "APP_DIR=%USERPROFILE%\.local\dbless"
set "VENV_DIR=%APP_DIR%\.venv"
set "PROJECT_DIR=%~dp0"

echo == Checking prerequisites...
where python >nul 2>&1 || (echo ERROR: python is required but not found. & pause & exit /b 1)
for /f "tokens=*" %%v in ('python --version 2^>^&1') do echo     %%v

rem --- install app files ---
echo == Installing to %APP_DIR%...
if not exist "%APP_DIR%" mkdir "%APP_DIR%"
copy /y "%PROJECT_DIR%bin\dbless" "%APP_DIR%\dbless" >nul
if exist "%PROJECT_DIR%requirements.txt" (
    copy /y "%PROJECT_DIR%requirements.txt" "%APP_DIR%\requirements.txt" >nul
)
if not exist "%VENV_DIR%" (
    python -m venv "%VENV_DIR%"
)

echo == Installing Python dependencies...
if exist "%APP_DIR%\requirements.txt" (
    "%VENV_DIR%\Scripts\pip.exe" install -r "%APP_DIR%\requirements.txt"
) else (
    "%VENV_DIR%\Scripts\pip.exe" install duckdb pandas windows-curses
)

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

rem --- wrapper ---
> "%BIN_DIR%\dbless.bat" (
    echo @echo off
    echo "%VENV_DIR%\Scripts\python.exe" "%APP_DIR%\dbless" %%*
)
echo     wrapper -^> %BIN_DIR%\dbless.bat

rem --- PATH ---
set "KEY=HKCU\Environment"
reg query "%KEY%" /v PATH >nul 2>&1
if errorlevel 1 (
    reg add "%KEY%" /v PATH /t REG_EXPAND_SZ /d "%BIN_DIR%" /f >nul
    echo     Added to user PATH ^(log out/in to apply^)
) else (
    for /f "tokens=2*" %%a in ('reg query "%KEY%" /v PATH 2^>nul') do set "OLDPATH=%%b"
    echo !OLDPATH! | findstr /i /c:"%BIN_DIR%" >nul 2>&1
    if errorlevel 1 (
        reg add "%KEY%" /v PATH /t REG_EXPAND_SZ /d "!OLDPATH!;%BIN_DIR%" /f >nul
        echo     Added to user PATH ^(log out/in to apply^)
    ) else (
        echo     Already in PATH.
    )
)

echo == Verifying...
call "%BIN_DIR%\dbless.bat" --help >nul 2>&1 && echo     dbless OK || echo     WARNING: dbless --help failed

echo.
echo Done. App installed to %APP_DIR% ^(repo-independent^).
echo Restart your terminal and run 'dbless' to get started.
pause
