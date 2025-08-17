@echo off

REM Pixel Audio Framework - Batch Script
REM Copyright (C) 2025 [Your Name]
REM
REM This script is part of the Pixel Audio Framework.
REM It is licensed under the GNU Lesser General Public License v2.1.
REM See the LICENSE.txt file for more information.
REM
REM This library is free software; you can redistribute it and/or
REM modify it under the terms of the GNU Lesser General Public
REM License as published by the Free Software Foundation; either
REM version 2.1 of the License, or (at your option) any later version.

echo 1=png16 (lossless, 16-bit)
echo 2=png8 (lossless, 8-bit)
echo 3=av1 (lossy, 8-bit)

set /p mode="Choose encoding mode: "

if "%mode%"=="1" (
  pushd bin
  call encode-png16-mode.bat
  popd
)
if "%mode%"=="2" (
  pushd bin
  call encode-png8-mode.bat
  popd
)
if "%mode%"=="3" (
  pushd bin
  call encode-av1-mode.bat
  popd
)

pause
