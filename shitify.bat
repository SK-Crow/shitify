@echo off
setlocal

REM Set extreme parameters for maximum degradation
set "sample_rate=8000"       REM Supported sample rate for MP3 (libmp3lame)
set "bitrate=1k"             REM Extremely low bitrate for maximum compression artifacts
set "channels=1"             REM Mono channel for even worse quality
set "codec=libmp3lame"       REM MP3 codec for audible but degraded sound
set "lowpass_freq=1000"       REM Low-pass filter frequency to muffle sound
set "bit_depth=1"            REM Bit depth for rough audio (works well with WAV)

REM Create the output folder if it doesn't exist
set "output_folder=%cd%\shitified"
if not exist "%output_folder%" (
    mkdir "%output_folder%"
)

REM Loop through each audio file in the current folder
for %%f in (*.wav *.mp3 *.flac *.m4a *.aac) do (
    echo Processing: %%f
    
    REM Apply low-pass filter, extreme bitrate, mono, and 8k sample rate
    ffmpeg -i "%%f" -ar %sample_rate% -ac %channels% -b:a %bitrate% -codec:a %codec% -filter:a "lowpass=f=%lowpass_freq%" "%output_folder%\degraded_%%~nf.mp3"
    
    REM Apply bit depth reduction (optional, but adds more roughness)
    ffmpeg -i "%output_folder%\degraded_%%~nf.mp3" -acodec pcm_u8 "%output_folder%\degraded_%%~nf.wav"
    
    echo Finished: "%output_folder%\degraded_%%~nf.wav"
)

echo All files processed and moved to the \shitified\ folder.
pause
