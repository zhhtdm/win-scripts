@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 设置输出后缀
set "suffix=_x264"

:: 设置 ffmpeg 命令（如果已加入系统环境变量就无需修改）
set "ffmpeg=ffmpeg"

echo === 开始转码 HEVC/x265 文件 ===

:: 只处理当前文件夹的视频文件（不含子文件夹）
for %%F in (*.mp4 *.mkv *.mov *.avi) do (
    echo.
    echo 检查文件：%%F

    :: 用 ffmpeg 检测是否包含 HEVC 视频流
    %ffmpeg% -hide_banner -i "%%F" 2>&1 | findstr /i /c:"Video: hevc" /c:"Video: h265" >nul
    if !errorlevel! == 0 (
        echo 发现 HEVC/x265，正在转码...

        set "filename=%%~nF"
        set "extension=%%~xF"
        set "outfile=!filename!!suffix!!extension!"

        :: 转码为兼容性高的 x264 格式
        %ffmpeg% -i "%%F" -c:v libx264 -preset veryslow -movflags +faststart -crf 23 -pix_fmt yuv420p -c:a aac -b:a 128k "!outfile!"

        echo 完成：!outfile!
    ) else (
        echo 跳过：不是 HEVC/x265 编码。
    )
)

echo.
echo === 所有文件处理完成 ===
pause
