@echo off

REM Pixel Audio Framework - Batch Script
REM Copyright (C) 2025 Martin Rácz
REM
REM This script is part of the Pixel Audio Framework.
REM It is licensed under the GNU Lesser General Public License v2.1.
REM See the LICENSE.txt file for more information.
REM
REM This library is free software; you can redistribute it and/or
REM modify it under the terms of the GNU Lesser General Public
REM License as published by the Free Software Foundation; either
REM version 2.1 of the License, or (at your option) any later version.

setlocal enabledelayedexpansion

if not exist "ffmpeg\ffmpeg.exe" (
    echo [X] Error: ffmpeg.exe not found in \ffmpeg folder
    echo     Download from: https://ffmpeg.org
    pause
    exit /b
)

if not exist "splitbin.exe" (
    echo [X] Error: splitbin.exe not found
    pause
    exit /b
)

:get_input
echo.
set "input_file="
set /p "input_file=Drag audio file here or type path: "

set "input_file=%input_file:"=%"

if not exist "%input_file%" (
    echo [X] Error: File not found
    echo     Example valid path: C:\Music\song.mp3
    goto get_input
)

:get_quality
echo.
set "quality=90"
set /p "quality=Specify quality (1-100, higher is better [default=90]): "
if not defined quality set "quality=90"

if exist audio-webp.mra del audio-webp.mra

echo.
echo Starting conversion...
echo ----------------------

echo [1/3] Converting to raw audio...
"ffmpeg\ffmpeg.exe" -v error -i "%input_file%" -c:a pcm_u8 -ar 48k -ac 1 -f u8 "tmp.pcm"
if errorlevel 1 (
    echo [X] Error: Could not convert audio
    goto cleanup
)

echo [2/3] Splitting audio...
splitbin.exe "tmp.pcm" 131072
if errorlevel 1 (
    echo [X] Error: Chunking failed
    goto cleanup
)

echo [3/3] Converting to WebP chunks...
set chunk_count=0
for %%f in (*.pcm) do (
    "ffmpeg\ffmpeg.exe" -v error -f rawvideo -pix_fmt gray -s 512x256 -i "%%f" -q:v %quality% "%%~nf.webp"
    if !errorlevel! equ 0 (
        del "%%f"
        set /a chunk_count+=1
        <nul set /p="."
    )
)

:cleanup
if exist "tmp.pcm" del "tmp.pcm"
if exist "tmp.webp" del "tmp.webp"

echo ----------------------
if %chunk_count% gtr 0 (
    echo Success! Created %chunk_count% WebP chunks:
    dir /b *.webp
) else (
    echo [X] Conversion failed - no chunks created
    echo Possible reasons:
    echo 1. Corrupt input file
    echo 2. Unsupported audio format
    echo 3. Output folder not writable
)

echo Packaging chunks...
"7z/7za.exe" a -tzip audio-webp.pxa *.webp
del *.webp
del *.pcm
echo Encoding complete!

