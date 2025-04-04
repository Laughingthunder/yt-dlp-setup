@echo off
REM yt-dlp Setup: Download and update yt-dlp.
title "yt-dlp Setup"
setlocal
if defined PROCESSOR_ARCHITEW6432 (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    set "YTDLPFILENAME=yt-dlp.exe"
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    set "YTDLPFILENAME=yt-dlp.exe"
) else (
    set "ARCH=x86"
    set "ARCHBITS=32"
    set "YTDLPURL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_%ARCH%.exe"
    set "YTDLPFILENAME=yt-dlp_%ARCH%.exe"
)
if not exist "%~dp0%YTDLPFILENAME%" (
    timeout /t 2 /nobreak >nul
    ECHO.
    ECHO "Starting yt-dlp Setup..."
    timeout /t 2 /nobreak >nul
    ECHO "Done."
    ECHO.
    ECHO ""%YTDLPFILENAME%" does not exist. Fetching "%YTDLPFILENAME%"..."
    "%~dp0bin\\%ARCH%\\wget.exe" --no-hsts -q --show-progress -P "%~dp0." "%YTDLPURL%"
    if exist "%~dp0%YTDLPFILENAME%" (
        ECHO "Done."
        ECHO.
    ) else (
        ECHO "ERROR: Failed to download %YTDLPFILENAME%. Press any key to exit."
        pause >nul
        exit /b 1
    )
) else (
    if exist "%~dp0%YTDLPFILENAME%" (
        timeout /t 2 /nobreak >nul
        ECHO.
        ECHO "Starting yt-dlp Setup..."
        timeout /t 2 /nobreak >nul
        ECHO "Done."
        ECHO.
    )
)
ECHO "Checking for available yt-dlp updates..."
ECHO "We'll only update if necessary."
"%~dp0%YTDLPFILENAME%" -U
ECHO "Done."
ECHO.
ECHO "Checking for yt-dlp ffmpeg..."
ECHO "We'll only download it if necessary."
"%~dp0bin\\%ARCH%\\wget.exe" -N --no-hsts -q --show-progress --content-disposition -P "%~dp0bin\\ffmpeg_dl" "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win%ARCHBITS%-gpl.zip"
ECHO "Done."
ECHO.
ECHO "Extracting yt-dlp ffmpeg..."
"%~dp0bin\\%ARCH%\\7za.exe" e "%~dp0bin\\ffmpeg_dl\ffmpeg-master-latest-win%ARCHBITS%-gpl.zip" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffmpeg.exe" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffplay.exe" ^
    "ffmpeg-master-latest-win%ARCHBITS%-gpl\bin\ffprobe.exe" ^
    -o"%~dp0." -y >nul
ECHO "Done."
ECHO.
endlocal
ECHO "yt-dlp Setup has completed successfully. Press any key to exit."
pause >nul
exit