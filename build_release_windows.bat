@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo [1/4] Memulai proses packaging NeighborHelpApp untuk Windows...
echo ===================================================

set "BASE_DIR=%CD%"
set "RELEASE_DIR=%BASE_DIR%\NeighborHelpApp_Windows"

:: 1. Bersihkan folder release lama jika ada
if exist "%RELEASE_DIR%" (
    echo Membersihkan folder release lama...
    rmdir /s /q "%RELEASE_DIR%"
)
mkdir "%RELEASE_DIR%\frontend"

echo.
echo ===================================================
echo [2/4] Melakukan build pada Backend (Go)...
echo ===================================================
cd "%BASE_DIR%\backend"
set GOOS=windows
set GOARCH=amd64
go build -o neighbor_help_backend.exe main.go
copy neighbor_help_backend.exe "%RELEASE_DIR%\" > nul

echo.
echo ===================================================
echo [3/4] Melakukan build pada Frontend (Flutter)...
echo ===================================================
cd "%BASE_DIR%\frontend\radius"
call flutter build windows --release

:: Menyalin seluruh folder hasil build ke folder frontend
echo Menyalin file Flutter bundle...
xcopy /E /I /Y "build\windows\x64\runner\Release\*" "%RELEASE_DIR%\frontend" > nul

echo.
echo ===================================================
echo [4/4] Membuat Script Peluncur (start.bat)...
echo ===================================================
cd "%RELEASE_DIR%"

(
echo @echo off
echo echo Memulai Backend API...
echo start /B neighbor_help_backend.exe
echo ping 127.0.0.1 -n 2 ^> nul
echo echo Memulai UI Frontend...
echo cd frontend
echo start /WAIT radius.exe
echo echo Mematikan Backend...
echo taskkill /F /IM neighbor_help_backend.exe ^> nul
echo exit
) > start.bat

echo.
echo ===================================================
echo DONE! Berhasil dikompilasi.
echo Folder aplikasi siap distribusi Anda berada di: 
echo %RELEASE_DIR%
echo.
echo Silakan bagikan folder "NeighborHelpApp_Windows" tersebut
echo sebagai aplikasi portable.
echo ===================================================
pause
