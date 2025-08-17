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

"7z/7za.exe" x %in% -o.

echo Reading and decoding PNG chunks...

"ffmpeg\ffmpeg.exe" -v quiet -i audio.mkv -f rawvideo -pix_fmt gray16le - | "ffmpeg\ffmpeg.exe" -y -v quiet -f s16le -ar 48k -ac 1 -i - -c:a copy out-png16.wav
del audio.mkv
move out-png16.wav ..

echo Decoding complete
