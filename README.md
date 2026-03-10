# WSL/Windows 路径转换 Fish 插件

快速在 Windows 路径和 WSL 路径之间转换的 Fish shell 插件。

## 功能

- `to_wsl` - Windows 路径转 WSL 路径
- `to_windows` - WSL 路径转 Windows 路径
- `convert_path` - 自动检测并转换路径

## 安装

1. 创建 fish functions 目录（如果不存在）：

```bash
mkdir -p ~/.config/fish/functions
```

2. 复制函数文件：

```bash
cp to_wsl.fish ~/.config/fish/functions/
cp to_windows.fish ~/.config/fish/functions/
cp convert_path.fish ~/.config/fish/functions/
```

3. 重新加载 fish 配置或重启终端：

```bash
source ~/.config/fish/config.fish
```

## 使用方法

### to_wsl

将 Windows 路径转换为 WSL 路径：

```fish
to_wsl "C:\\Users\\test\\file.txt"
# 输出: /mnt/c/Users/test/file.txt

to_wsl "D:\\project\\code"
# 输出: /mnt/d/project/code
```

### to_windows

将 WSL 路径转换为 Windows 路径：

```fish
to_windows "/mnt/c/Users/test/file.txt"
# 输出: C:\Users\test\file.txt

to_windows "/mnt/d/project/code"
# 输出: D:\project\code
```

### convert_path

自动检测路径格式并转换：

```fish
convert_path "C:\\test"
# 输出: /mnt/c/test

convert_path "/mnt/c/test"
# 输出: C:\test
```

## 路径格式

**Windows 路径格式：**
- `C:\path\to\file`
- `D:\project\code`

**WSL 路径格式：**
- `/mnt/c/path/to/file`
- `/mnt/d/project/code`

## 注意事项

- 支持的驱动器盘符：A-Z
- 自动处理路径分隔符转换（`\` ↔ `/`）
- 如果输入路径格式无法识别，函数会返回错误信息