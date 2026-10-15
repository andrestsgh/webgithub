@echo off
title Unidad 1: Ejercicio de recuperación del sistema
color 0A

:: Verificar si se ejecuta como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Este script debe ejecutarse como Administrador.
    pause
    exit
)

:pedir_nombre
cls
echo =======================================================
echo         REGISTRO DE ALUMNO Y CONFIGURACIÓN
echo =======================================================
echo.
set "ALUMNO="
set /p ALUMNO="Por favor, introduce tu nombre: "

if "%ALUMNO%"=="" goto pedir_nombre
set ALUMNO=%ALUMNO: =_%
set "RUTA_RESPALDO=%USERPROFILE%\Backup_BCD.bcd"

cls
echo =======================================================
echo    CONFIGURANDO ESCENARIO PARA: %ALUMNO%
echo =======================================================
echo.

echo [1/3] Localizando particion de arranque...
mountvol X: /S >nul 2>&1

:: Verificar si es UEFI
if exist X:\EFI\Microsoft\Boot\BCD goto uefi
goto legacy

:uefi
echo [INFO] Detectado sistema UEFI (GPT).
echo [2/3] Liberando el BCD del Registro del sistema...
reg unload HKLM\BCD00000000 >nul 2>&1

echo [2/3] Creando copia de respaldo personalizada...
copy "X:\EFI\Microsoft\Boot\BCD" "%USERPROFILE%\BCD_%ALUMNO%.bak" >nul

echo [3/3] Corrompiendo los datos de arranque (BCD)...
del /f /q "X:\EFI\Microsoft\Boot\BCD"
goto final


:legacy
echo [INFO] Detectado sistema Legacy con particion oculta.
echo [2/3] Montando particion Reservada para el Sistema...

:: Crear un script temporal para Diskpart que busque la partición activa y le asigne la letra Y:
echo select disk 0 > %temp%\dp.txt
echo select partition 1 >> %temp%\dp.txt
echo assign letter=Y >> %temp%\dp.txt
diskpart /s %temp%\dp.txt >nul 2>&1
del /f /q %temp%\dp.txt >nul

:: Asegurar montaje
mountvol Y: /L >nul 2>&1

:: Quitar atributos ocultos y del sistema del archivo BCD
attrib -h -r -s "Y:\Boot\BCD" >nul 2>&1

echo [2/3] Liberando el BCD del Registro del sistema...
:: Este comando obliga a Windows a cerrar su acceso exclusivo al archivo BCD
reg unload HKLM\BCD00000000 >nul 2>&1

echo [2/3] Creando copia de respaldo personalizada en Y:...
copy "Y:\Boot\BCD" "%USERPROFILE%\BCD_%ALUMNO%.bak" >nul
:: Eliminar los identificadores de arranque principales en el BCD actual
bcdedit /delete {current} /f

echo [3/3] Corrompiendo los datos de arranque (BCD)...
del /f /q "Y:\Boot\BCD"

:: Desmontar la letra para dejar el sistema listo para el fallo
mountvol Y: /D >nul 2>&1
goto final


:final
echo.
echo =======================================================
echo  ESCENARIO CONFIGURADO EXITOSAMENTE.
echo  A continuación la máquina se reiniciará y deberás recuperar el sistema
echo =======================================================
echo.
::set /p REBOOT="¿Deseas reiniciar la maquina virtual ahora mismo? (S/N): "

::if /i "%REBOOT%"=="S" goto reiniciar_pc
::exit

:reiniciar_pc
shutdown /r /t 0
exit
