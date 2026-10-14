@echo off
title ISO Unidad 1 - Recuperación del sistema
color 0A

:: Verificar si se ejecuta como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Este script debe ejecutarse como Administrador.
    echo Por favor, haz clic derecho sobre el archivo y selecciona "Ejecutar como administrador".
    pause
    exit
)

:pedir_nombre
echo =======================================================
echo         REGISTRO DE ALUMNO Y CONFIGURACIÓN
echo =======================================================
echo.
set /p ALUMNO="Por favor, introduce tu Nombre y pulsa intro: "

:: Validar que el alumno no deje el campo vacío
if "%ALUMNO%"=="" (
    cls
    echo [ERROR] El nombre no puede estar vacio.
    goto pedir_nombre
)

:: Limpiar espacios o caracteres extraños del nombre para evitar errores de archivo
set ALUMNO=%ALUMNO: =_%

cls
echo =======================================================
echo    CONFIGURANDO ESCENARIO PARA: %ALUMNO%
echo =======================================================
echo.

:: 1. Asignar una letra temporal a la particion oculta del sistema (ESP/Boot)
echo [1/3] Localizando particion de arranque...
mountvol X: /S >nul 2>&1
echo hola
:: Si la particion es UEFI (GPT), existira en X:. Si es BIOS/MBR, el BCD estara en C:\Boot
if exist X:\EFI\Microsoft\Boot\BCD (
    echo [INFO] Detectado sistema UEFI (GPT).
    echo [2/3] Creando copia de respaldo personalizada para %ALUMNO%...
    copy X:\EFI\Microsoft\Boot\BCD X:\EFI\Microsoft\Boot\BCD_%ALUMNO%.bak >nul
    
    echo [3/3] Corrompiendo los datos de arranque (BCD)...
    del /f /q X:\EFI\Microsoft\Boot\BCD
) else (
    echo [INFO] Detectado sistema Legacy (MBR).
    echo [2/3] Creando copia de respaldo personalizada para %ALUMNO%...
    attrib -h -r -s C:\Boot\BCD >nul 2>&1
    copy C:\Boot\BCD C:\Boot\BCD_%ALUMNO%.bak >nul
    
    echo [3/3] Corrompiendo los datos de arranque (BCD)...
    del /f /q C:\Boot\BCD
)

echo.
echo =======================================================
echo  ESCENARIO CONFIGURADO EXITOSAMENTE.
echo  Debes reiniciar para continuar
echo =======================================================
echo.
set /p REBOOT="¿Deseas reiniciar la maquina virtual ahora mismo? (S/N): "
if /i "%REBOOT%"=="S" goto reiniciar_pc
exit

:reiniciar_pc
shutdown /r /t 0
exit

