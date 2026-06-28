@echo off
REM yt-dlp Cleanup: Cleanup and remove yt-dlp and downloaded components.
title "yt-dlp Cleanup"
set "SCRIPTPATH=%~dp0"
cd /d "%SCRIPTPATH%"
setlocal
if defined PROCESSOR_ARCHITEW6432 (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPFILENAME=yt-dlp.exe"
    set "YTDLPALTFILENAME=yt-dlp_x86.exe"
    set "DENODIR=deno_dl"
    set "DENOFILENAME=deno.exe"
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ARCH=x64"
    set "ARCHBITS=64"
    set "YTDLPFILENAME=yt-dlp.exe"
    set "YTDLPALTFILENAME=yt-dlp_x86.exe"
    set "DENODIR=deno_dl"
    set "DENOFILENAME=deno.exe"
) else (
    set "ARCH=x86"
    set "ARCHBITS=32"
    set "YTDLPFILENAME=yt-dlp_x86.exe"
    set "YTDLPALTFILENAME=yt-dlp.exe"
)
set "DLCACHEDIR=%SCRIPTPATH%yt-dlp-setup_bin\dl_cache"
set "CADIR=%DLCACHEDIR%\ca_dl"
set "CABUNDLE=%CADIR%\ca-bundle.crt"
set "CAFETCH=%CADIR%\cacert.pem"
set "FFMPEGDIR=%DLCACHEDIR%\ffmpeg_dl"
set "FFMPEGZIP=%FFMPEGDIR%\ffmpeg-master-latest-win%ARCHBITS%-gpl.zip"
if defined DENODIR (
    set "DENOCACHEDIR=%DLCACHEDIR%\%DENODIR%"
    set "DENOZIP=%DLCACHEDIR%\%DENODIR%\deno-x86_64-pc-windows-msvc.zip"
)
set "CLEANUPFAILED=0"

timeout /t 1 /nobreak >nul
ECHO.
ECHO "Starting yt-dlp Cleanup..."
timeout /t 1 /nobreak >nul
ECHO "Done."
ECHO.

ECHO "Removing yt-dlp executables and updater remnants..."
call :DeleteFile "%SCRIPTPATH%%YTDLPFILENAME%" "%YTDLPFILENAME%"
call :DeleteFile "%SCRIPTPATH%%YTDLPFILENAME%.old" "%YTDLPFILENAME%.old"
call :DeleteFile "%SCRIPTPATH%%YTDLPFILENAME%.new" "%YTDLPFILENAME%.new"
call :DeleteFile "%SCRIPTPATH%%YTDLPALTFILENAME%" "%YTDLPALTFILENAME%"
call :DeleteFile "%SCRIPTPATH%%YTDLPALTFILENAME%.old" "%YTDLPALTFILENAME%.old"
call :DeleteFile "%SCRIPTPATH%%YTDLPALTFILENAME%.new" "%YTDLPALTFILENAME%.new"
ECHO "Finished checking yt-dlp files."
ECHO.
timeout /t 1 /nobreak >nul

ECHO "Removing extracted yt-dlp ffmpeg components..."
call :DeleteFile "%SCRIPTPATH%ffmpeg.exe" "ffmpeg.exe"
call :DeleteFile "%SCRIPTPATH%ffplay.exe" "ffplay.exe"
call :DeleteFile "%SCRIPTPATH%ffprobe.exe" "ffprobe.exe"
ECHO "Finished checking yt-dlp ffmpeg components."
ECHO.
timeout /t 1 /nobreak >nul

if defined DENOFILENAME (
    ECHO "Removing extracted yt-dlp Deno component..."
    call :DeleteFile "%SCRIPTPATH%%DENOFILENAME%" "%DENOFILENAME%"
    ECHO "Finished checking yt-dlp Deno component."
    ECHO.
    timeout /t 1 /nobreak >nul
)

ECHO "Removing downloaded certificate files and cache..."
call :DeleteFile "%CABUNDLE%" "CA certificate bundle"
call :DeleteFile "%CAFETCH%" "downloaded CA certificate"
call :DeleteDirectory "%CADIR%" "CA download cache"
ECHO "Finished checking the certificate cache."
ECHO.
timeout /t 1 /nobreak >nul

ECHO "Removing downloaded yt-dlp ffmpeg archive and cache..."
call :DeleteFile "%FFMPEGZIP%" "ffmpeg-master-latest-win%ARCHBITS%-gpl.zip"
call :DeleteDirectory "%FFMPEGDIR%" "yt-dlp ffmpeg download cache"
ECHO "Finished checking the yt-dlp ffmpeg cache."
ECHO.
timeout /t 1 /nobreak >nul

if defined DENOCACHEDIR (
    ECHO "Removing downloaded yt-dlp Deno archive and cache..."
    call :DeleteFile "%DENOZIP%" "deno-x86_64-pc-windows-msvc.zip"
    call :DeleteDirectory "%DENOCACHEDIR%" "yt-dlp Deno download cache"
    ECHO "Finished checking the yt-dlp Deno cache."
    ECHO.
    timeout /t 1 /nobreak >nul
)

call :RemoveEmptyDirectory "%DLCACHEDIR%" "yt-dlp download cache parent directory"

if "%CLEANUPFAILED%"=="0" (
    endlocal
    ECHO "yt-dlp Cleanup has completed successfully."
    exit /B 0
) else (
    endlocal
    ECHO "yt-dlp Cleanup completed, but one or more items could not be removed."
    ECHO "Close any running yt-dlp, ffmpeg, ffplay, ffprobe, or Deno processes and rerun this script."
    exit /B 1
)

:DeleteFile
if exist "%~1" (
    ECHO "Removing %~2..."
    attrib -r -h -s "%~1" >nul 2>&1
    del /f /q "%~1" >nul 2>&1
    if exist "%~1" (
        ECHO "ERROR: Failed to remove %~2."
        set "CLEANUPFAILED=1"
    ) else (
        ECHO "Done."
    )
) else (
    ECHO "%~2 is not present. Nothing to remove."
)
exit /B

:DeleteDirectory
if exist "%~1\" (
    ECHO "Removing %~2..."
    attrib -r -h -s "%~1\*" /s /d >nul 2>&1
    rd /s /q "%~1" >nul 2>&1
    if exist "%~1\" (
        ECHO "ERROR: Failed to remove %~2."
        set "CLEANUPFAILED=1"
    ) else (
        ECHO "Done."
    )
) else (
    ECHO "%~2 is not present. Nothing to remove."
)
exit /B

:RemoveEmptyDirectory
if exist "%~1\" (
    rd "%~1" >nul 2>&1
    if exist "%~1\" (
        ECHO "%~2 contains other files and was left in place."
    ) else (
        ECHO "Removed the empty %~2."
    )
)
exit /B