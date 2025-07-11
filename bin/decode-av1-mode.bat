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

set /p in="Provide path to file: "

"7z/7za.exe" x %in% -oaudio

echo Reading and decoding AV1 frames...
"ffmpeg\ffmpeg.exe" -v quiet -i "audio\audio.webm" -f rawvideo -pix_fmt gray "tmp.pcm"

if exist out-av1.wav del out-av1.wav
"ffmpeg\ffmpeg.exe" -v quiet -f u8 -ar 48k -ac 1 -i tmp.pcm -c:a pcm_u8 out-av1.wav
rmdir /s /q "audio"
del tmp.pcm

echo Decoding complete!
