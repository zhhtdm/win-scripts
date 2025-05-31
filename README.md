# Win Scripts
Windows 脚本 工具 计划任务

- [Win Scripts](#win-scripts)
    - [重启 QuickLook](#重启-quicklook)
    - [调亮 xshd 中的颜色](#调亮-xshd-中的颜色)
    - [替换 Gif 为 Mp4](#替换-gif-为-mp4)
    - [清理桌面快捷方式](#清理桌面快捷方式)
    - [转换视频 x265 到 x264](#转换视频-x265-到-x264)
    - [向 Mac 广播 SMB 服务](#向-mac-广播-smb-服务)

### 重启 QuickLook
变相解决`QuickLook`意外退出的问题
- Mac 的空格预览很好用，Windows 上有复刻版[`QuickLook`](https://github.com/QL-Win/QuickLook)也很好用，但他会在不知道什么时候就意外退出，导致要用的时候一按空格没反应，另人恼火，此脚本检测`QuickLook`是否在运行，如果没有就重启他。
- 因为`QuickLook`是需要图形界面的程序，所以如果用计划任务定时调用这个脚本，就得选「只在用户登录时运行」，但这又导致会闪现`cmd`的黑色窗口，解决方法是用计划任务调用[`nircmd.exe`](https://www.nirsoft.net/utils/nircmd.html#:~:text=Full%20Help%20File-,Download%20NirCmd,-Download%20NirCmd%2064)，然后在`添加参数`框内填入
    ```shell
    exec hide ".bat脚本地址"
    ```

### 调亮 xshd 中的颜色
使`QuickLook`能用尽量使用暗色模式来查看文本文档
- `QuickLook`查看大多数文档时都是亮色模式，而且配色一般。在`QuickLook.Plugin.TextViewer\Syntax`文件夹下有`Dark`和`Light`两个文件夹，`Light`下有大量`.xshd`文件，`Dark`中很少。于是有两种解决方法，要么找现成的`Drak Mode`的`.xshd`文件，但我没找到。要么把`Light`的适配到到`Dark`
- 这个脚本会把所在目录(不含子目录)下所有`.xshd`文件中的颜色替换为适合暗色模式下使用的颜色，运行前先做好备份，安装依赖:`pip install webcolors`，运行后把替换过的文件(或者使用我[转换好的`Dark.zip`](https://github.com/zhhtdm/win-scripts/raw/refs/heads/main/%E8%B0%83%E4%BA%AE.xshd%E4%B8%AD%E7%9A%84%E9%A2%9C%E8%89%B2/Dark.zip))放到`Dark`文件夹下，重启`QuickLook`
- 脚本先把`webcolors`颜色名转换为`#RRGGBB`格式，再把所有`#RRGGBB`颜色维持色相，饱和度设为`0.6`，亮度设为`0.8`

### 替换 Gif 为 Mp4
`Gif`太大了，这个脚本会把设定目录(***包含***子目录)下的`Gif`文件转换并替换为`Mp4`文件，并记录`log`到设定目录下。可以用计划任务调用脚本来定期替换。
- 修改脚本中`folder`变量为设定目录，示例: `set folder=D:\Syncthing\Pictures`
- 如果需要处理多个目录，可以多复制几个脚本，每个设置不同目录
- 依赖[`FFmpeg`](https://ffmpeg.org/)

### 清理桌面快捷方式
首先我的桌面不需要应用的快捷方式，常用的放在任务栏，次常用的放在开始屏幕，桌面只放临时文件和常驻文件(极少)，但是`TeamViewer`总是时不时地创建快捷方式到桌面。计划任务调用此脚本定时清理。运行脚本需要管理员权限

### 转换视频 x265 到 x264
拍完实验视频，用[`LosslessCut`](https://github.com/mifi/lossless-cut?tab=readme-ov-file#download)剪完，插入`PPT`时才发现还不支持`x265`视频。这个脚本会使用[`FFmpeg`](https://ffmpeg.org/)将脚本所在目录下（不包含子目录）编码为`HEVC`、`x265`的视频文件用尽可能兼容的参数转码为`x264`编码的版本，输出为新文件，不覆盖原文件

### 向 Mac 广播 SMB 服务
稳定地向 Mac 广播 Windows 的 SMB 服务，能做到「即插即显」
- Windows 安装 [Bonjour Print Services for Windows](https://support.apple.com/en-us/106380)
- 运行脚本: `dns-sd -R "share name" _smb._tcp local 445`
