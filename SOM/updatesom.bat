@echo off
title Actualizador de Practicas - SOM
setlocal

:: --- CONFIGURACION ---
set "URL_ZIP=https://andrestsgh.github.io/webgithub/SOM/Ejercicios.zip"
set "ARCHIVO_ZIP=%~dp0Ejercicios.zip"
set "CARPETA_DESTINO=%~dp0Ejercicios"

echo ========================================================
echo   ACTUALIZANDO EJERCICIOS DE SISTEMAS OPERATIVOS (SOM)
echo ========================================================
echo.

:: 1. Eliminar la carpeta Ejercicios anterior si existe
if exist "%CARPETA_DESTINO%" (
    echo [1/4] Eliminando version anterior de la carpeta Ejercicios...
    rmdir /s /q "%CARPETA_DESTINO%"
) else (
    echo [1/4] No se encontro carpeta previa. Creando entorno limpio...
)

:: 2. Descargar el nuevo Ejercicios.zip usando curl (nativo en Windows 10)
echo [2/4] Descargando ultima version desde GitHub...
curl -L -s -f -o "%ARCHIVO_ZIP%" "%URL_ZIP%"

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] No se pudo descargar Ejercicios.zip.
    echo Comprueba tu conexion a Internet o que el archivo este subido a GitHub.
    pause
    exit /b 1
)

:: 3. Descomprimir el archivo ZIP en la ruta actual
echo [3/4] Descomprimiendo ejercicios...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ARCHIVO_ZIP%' -DestinationPath '%~dp0' -Force"

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Fallo al descomprimir el archivo ZIP.
    if exist "%ARCHIVO_ZIP%" del /f /q "%ARCHIVO_ZIP%"
    pause
    exit /b 1
)

:: 4. Eliminar el archivo ZIP descargado
echo [4/4] Limpiando archivos temporales...
if exist "%ARCHIVO_ZIP%" del /f /q "%ARCHIVO_ZIP%"

echo.
echo ========================================================
echo   ACTUALIZACION COMPLETADA CON EXITO
echo ========================================================
echo.
pause
