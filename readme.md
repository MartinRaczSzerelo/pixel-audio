<div style="display:flex;width:100%;justify-content:center">
  <img height="200" src="pixel-audio-logo.png"/>
</div>
<h1 align="center">Pixel Audio (VEDA)</h1>

Visual Encoding and Decoding for Audio (VEDA) is a framework to store audio in visual formats 
such as PNG, WebP or AV1. It enables audio data to be encoded into visual media and 
later decoded back into usable audio, leveraging modern image and video compression.

## Features
- Encode audio into lossy and lossless image formats (e.g., PNG, WebP)
- Encode audio into AV1 video frames (.webm)
- Decode Pixel Audio back into raw audio
- Custom <code>.pxa</code> file format for bundling image chunks/video into a ZIP container

A <code>.pxa</code> (Pixel Audio) file is a standard ZIP archive containing encoded image chunks/video ("00001.png", "00002.webp", "audio.webm", etc.)

## Getting Started
To encode audio, run <code>encode-main.bat</code> and you'll be prompted to encode in a mode. There are 4 modes at the moment:
- 8 and 16 bit PNG
- WebP
- AV1 video

All modes store audio as unsigned 8-bit mono at 48 kHz, except for 16-bit PNG.
- For lossless compression, use PNG.
- Use AV1 for smoother audio. (mostly recommended for long term use)
- Use WebM as an alternative.

Note: in AV1, the higher frequencies might get cut off in smaller regions of audio, if lower frequencies dominate more. (listen to example files)

To decode audio, run <code>decode-main.bat</code>. You'll be prompted to choose a decoding mode for the file. The file will be decoded into the appropriate sample format that the encoded audio uses.

## Dependencies
- FFmpeg
- SplitBin (custom compiled binary for splitting audio into chunks)

Licensed under LGPL v2.1

## Note
This project is in its early stages, so contributing would be a big help. At the moment, it only supports Windows 10 and above, since it includes a full build of FFmpeg from BtbN.

## Contact:
Developed by Martin Rácz
GitHub: https://github.com/MartinRaczSzerelo/pixel-audio
