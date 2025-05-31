@echo off
setlocal enabledelayedexpansion

set folder=D:\Syncthing\Pictures
set log_file=%folder%\gif_to_mp4_log.txt

:: 创建日志文件，如果不存在则创建
if not exist "%log_file%" (
    echo Conversion log created on %date% at %time% > "%log_file%"
    echo. >> "%log_file%"
)

:: 循环处理指定文件夹及子文件夹中的 .gif 文件
for /r "%folder%" %%f in (*.gif) do (
    set gif_file=%%f
    set mp4_file=%%~dpnf.mp4

    :: 将转换过程追加到日志中
    :: echo Processing: !gif_file! >> "%log_file%"

    :: 检查是否已经存在同名的 mp4 文件
    if exist "!mp4_file!" (
        echo [%date% %time:~0,8%] [Skipping] conversion for : !mp4_file! [already exists]. >> "%log_file%"
    ) else (
        :: 执行ffmpeg命令，将gif转换为mp4
       ffmpeg -loglevel error -n -i "!gif_file!" -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2" -movflags +faststart -preset veryslow -pix_fmt yuv420p -crf 23 "!mp4_file!" 2>> "%log_file%"

        :: 检查是否成功创建了mp4文件
        if exist "!mp4_file!" (
            echo [%date% %time:~0,8%] ------------ Successfully converted: !gif_file! >> "%log_file%"

            :: 将原始gif文件删除到回收站
            powershell.exe -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('!gif_file!', 'OnlyErrorDialogs', 'SendToRecycleBin')"
        ) else (
            echo [%date% %time:~0,8%] [Failed] to convert: !gif_file! >> "%log_file%"
        )
    )
)

:: echo Conversion process completed on %date% at %time% >> "%log_file%"
echo [%date% %time:~00,8%] ----------------------------------------------------------------- >> "%log_file%"
