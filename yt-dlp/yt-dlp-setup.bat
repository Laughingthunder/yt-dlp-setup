@echo off
REM yt-dlp Setup: Download and update yt-dlp and components.
title "yt-dlp Setup"
set "SCRIPTPATH=%~dp0"
cd /d "%SCRIPTPATH%"
setlocal
if defined PROCESSOR_ARCHITEW6432 (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp.exe"
    set "YTDLPFILENAME=yt-dlp.exe"
    set "DENOURL=https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip"
    set "DENODIR=deno_dl"
    set "DENOFILENAME=deno.exe"
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp.exe"
    set "YTDLPFILENAME=yt-dlp.exe"
    set "DENOURL=https://github.com/denoland/deno/releases/latest/download/deno-x86_64-pc-windows-msvc.zip"
    set "DENODIR=deno_dl"
    set "DENOFILENAME=deno.exe"
) else (
    set "ARCH=x86"
    set "ARCHBITS=32"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp_%ARCH%.exe"
    set "YTDLPFILENAME=yt-dlp_%ARCH%.exe"
)
set "CADIR=%SCRIPTPATH%yt-dlp-setup_bin\dl_cache\ca_dl"
set "CABUNDLE=%CADIR%\ca-bundle.crt"
set "CAFETCH=%CADIR%\cacert.pem"
set "CAURL=https://curl.se/ca/cacert.pem"
"%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\wget.exe" -N --no-hsts -q -P "%CADIR%" "%CAURL%"
if not errorlevel 1 (
    copy /y "%CAFETCH%" "%CABUNDLE%" >nul
)
if errorlevel 1 (
    curl.exe -L -o "%CABUNDLE%" "%CAURL%"
)
set "SSL_CERT_FILE=%CABUNDLE%"
if not exist "%SCRIPTPATH%%YTDLPFILENAME%" (
    timeout /t 1 /nobreak >nul
    ECHO.
    ECHO "Starting yt-dlp Setup..."
    timeout /t 1 /nobreak >nul
    ECHO "Done."
    ECHO.
    timeout /t 1 /nobreak >nul
    ECHO ""%YTDLPFILENAME%" does not exist. Fetching "%YTDLPFILENAME%"..."
    "%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\wget.exe" --no-hsts -q --show-progress -P "%SCRIPTPATH%." "%YTDLPURL%"
    if exist "%SCRIPTPATH%%YTDLPFILENAME%" (
        ECHO "Done."
        ECHO.
    ) else (
        ECHO "ERROR: Failed to download %YTDLPFILENAME%. Please rerun this script to try again.
        exit /b 1
    )
) else (
    if exist "%SCRIPTPATH%%YTDLPFILENAME%" (
        timeout /t 1 /nobreak >nul
        ECHO.
        ECHO "Starting yt-dlp Setup..."
        timeout /t 1 /nobreak >nul
        ECHO "Done."
        ECHO.
        timeout /t 1 /nobreak >nul
    )
)
ECHO "Checking for available yt-dlp updates..."
ECHO "We'll only update if necessary."
"%SCRIPTPATH%%YTDLPFILENAME%" --update-to nightly@latest
ECHO "Done."
ECHO.
timeout /t 1 /nobreak >nul
ECHO "Checking for yt-dlp ffmpeg..."
ECHO "We'll only download it if necessary."
"%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\wget.exe" -N --no-hsts -q --show-progress --content-disposition -P "%SCRIPTPATH%yt-dlp-setup_bin\dl_cache\ffmpeg_dl" "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win%ARCHBITS%-gpl.zip"
ECHO "Done."
ECHO.
timeout /t 1 /nobreak >nul
ECHO "Extracting yt-dlp ffmpeg..."
"%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\7za.exe" e "%SCRIPTPATH%yt-dlp-setup_bin\dl_cache\ffmpeg_dl\ffmpeg-master-latest-win%ARCHBITS%-gpl.zip" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffmpeg.exe" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffplay.exe" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffprobe.exe" ^
    -o"%SCRIPTPATH%." -y >nul
ECHO "Done."
ECHO.
timeout /t 1 /nobreak >nul
set "IS64BIT="
if defined PROCESSOR_ARCHITEW6432 (
    set "IS64BIT=1"
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "IS64BIT=1"
)
if defined IS64BIT (
    ECHO "Checking for yt-dlp Deno..."
    ECHO "We'll only download it if necessary."
    "%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\wget.exe" -N --no-hsts -q --show-progress --content-disposition -P "%SCRIPTPATH%yt-dlp-setup_bin\dl_cache\%DENODIR%" "%DENOURL%"
    ECHO "Done."
    ECHO.
    timeout /t 1 /nobreak >nul
    ECHO "Extracting yt-dlp Deno..."
    "%SCRIPTPATH%yt-dlp-setup_bin\system\%ARCH%\7za.exe" e "%SCRIPTPATH%yt-dlp-setup_bin\dl_cache\%DENODIR%\deno-x86_64-pc-windows-msvc.zip" ^
        "%DENOFILENAME%" ^
        -o"%SCRIPTPATH%." -y >nul
    ECHO "Done."
    ECHO.
    timeout /t 1 /nobreak >nul
)
endlocal
ECHO "yt-dlp Setup has completed successfully."
exit /B