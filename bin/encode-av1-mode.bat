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

echo.
set "frame=80x60"
set /p "frame=Specify frame size (default is 80x60): "
if not defined frame set "frame=80x60"

:get_quality
echo.
set "quality=10"
set /p "quality=Specify quality (0-63, lower is better [10 is default]): "
if not defined quality set "quality=10"

echo [1/2] Converting audio to AV1 chunks...
"ffmpeg\ffmpeg.exe" -v error -i "%input_file%" -c:a pcm_u8 -ar 48k -ac 1 -f u8 - | "ffmpeg\ffmpeg.exe" -y -v error -f rawvideo -pix_fmt gray -s %frame% -i - -c:v libaom-av1 -cpu-used 8 -crf %quality% -pix_fmt gray audio.mkv
if errorlevel 1 (
    echo [X] Error: Could not convert audio
)

echo [2/2] Packaging chunks...
"7z/7za.exe" a -tzip audio-av1.pxa audio.mkv
echo Encoding complete!
del audio.mkv
move audio-av1.pxa ..
cd ..
