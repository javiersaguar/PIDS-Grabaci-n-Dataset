@echo off
REM ===========================================================================
REM  Grabador del dataset de gestos - PIDS 26/27, Project 1
REM  Doble clic para lanzar. Antes, edita PARTICIPANT en
REM  HAR_mediapipe\src\record_dataset.py con tu identificador (p1, p2, p3...).
REM ===========================================================================
setlocal
set PYTHONUTF8=1
set GLOG_minloglevel=2

set "PY="
if exist "%~dp0.venv\Scripts\python.exe" set "PY=%~dp0.venv\Scripts\python.exe"
if not defined PY if exist "%~dp0..\.venv\Scripts\python.exe" set "PY=%~dp0..\.venv\Scripts\python.exe"

if not defined PY (
    echo.
    echo [ERROR] No encuentro el entorno virtual .venv
    echo.
    echo Creralo una sola vez, desde esta misma carpeta:
    echo     py -3.12 -m venv .venv
    echo     .venv\Scripts\python.exe -m pip install --upgrade pip
    echo     .venv\Scripts\python.exe -m pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo Usando: %PY%
echo.
"%PY%" "%~dp0HAR_mediapipe\src\record_dataset.py"

echo.
echo [Grabacion terminada] Pulsa una tecla para cerrar.
pause >nul
endlocal
