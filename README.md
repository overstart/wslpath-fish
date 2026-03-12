# WSL/Windows 路径转换 Fish 插件

快速在 Windows 路径和 WSL 路径之间转换的 Fish shell 插件。

## 功能

- `to_wsl` - Windows 路径转 WSL 路径
- `to_windows` - WSL 路径转 Windows 路径
- `convert_path` - 自动检测并转换路径

## 安装

### 使用 Fisher（推荐）

如果你已经安装了 [Fisher](https://github.com/jorgebucaran/fisher)：

```bash
fisher install overstart/wslpath-fish
```

### 手动安装

1. 创建 fish functions 目录（如果不存在）：

```bash
mkdir -p ~/.config/fish/functions
```

2. 复制函数文件：

```bash
cp functions/to_wsl.fish ~/.config/fish/functions/
cp functions/to_windows.fish ~/.config/fish/functions/
cp functions/convert_path.fish ~/.config/fish/functions/
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
# 转换 /mnt/ 驱动器路径
to_windows "/mnt/c/Users/test/file.txt"
# 输出: C:\Users\test\file.txt

to_windows "/mnt/d/project/code"
# 输出: D:\project\code

# 转换 WSL 内部路径为 WSL 网络路径
to_windows "/etc/config/"
# 输出: \\wsl.localhost\archlinux\etc\config\

to_windows "/home/user/documents"
# 输出: \\wsl.localhost\archlinux\home\user\documents
```

### convert_path

自动检测路径格式并转换：

```fish
convert_path "C:\\test"
# 输出: /mnt/c/test

convert_path "/mnt/c/test"
# 输出: C:\test

convert_path "/etc/config/"
# 输出: \\wsl.localhost\archlinux\etc\config\
```

## 路径格式

**Windows 路径格式：**
- `C:\path\to\file`
- `D:\project\code`

**WSL 路径格式：**
- `/mnt/c/path/to/file` - Windows 驱动器映射路径
- `/mnt/d/project/code`
- `/etc/config/` - WSL 内部路径

**WSL 网络路径格式：**
- `\\wsl.localhost\<发行版名称>\path\to\file`
- 用于从 Windows 访问 WSL 文件系统

## WSL 网络路径格式说明

`to_windows` 函数支持将 WSL 内部路径（如 `/etc/config/`）转换为 Windows WSL 网络路径格式。

**格式**：`\\wsl.localhost\<发行版名称>\<路径>`

**示例**：
```fish
to_windows "/etc/config/"
# 输出: \\wsl.localhost\archlinux\etc\config\

to_windows "/home/user/documents"
# 输出: \\wsl.localhost\archlinux\home\user\documents
```

**发行版名称获取**：
- 函数从 `WSL_DISTRO_NAME` 环境变量获取当前 WSL 发行版名称
- 如果环境变量未设置，函数会返回错误信息
- 常见发行版名称：`Ubuntu`、`Debian`、`ArchLinux`、`archlinux` 等

**使用场景**：
- 在 Windows 资源管理器中访问 WSL 文件系统
- 在 Windows 应用程序中访问 WSL 文件
- 在 Windows 命令提示符或 PowerShell 中访问 WSL 文件

## 注意事项

- 支持的驱动器盘符：A-Z
- 自动处理路径分隔符转换（`\` ↔ `/`）
- 如果输入路径格式无法识别，函数会返回错误信息
- `to_windows` 函数需要 `WSL_DISTRO_NAME` 环境变量来转换 WSL 内部路径
- 不支持 Windows 网络路径（如 `\\server\share`）

## CLI 技能集成

本项目提供了通用的 CLI 技能支持，可在多个支持技能系统的 CLI 工具中使用，包括：
- [iFlow CLI](https://github.com/iflow-ai/iflow-cli)
- Codex
- Claude CLI
- Gemini CLI

### 安装技能

使用 npx 快速安装技能：

```bash
npx skills install @overstart/to-wsl-skill
```

安装完成后，技能会自动集成到支持的 CLI 工具中。

### 在 CLI 中使用

安装后，你可以在 CLI 对话中直接请求使用此技能：

```
请使用 wslpath-fish 技能将 "C:\Users\username\Documents\file.txt" 转换为 WSL 路径
```

CLI 工具会自动调用技能并执行路径转换，无需手动运行转换命令。

### 技能特性

- **自动识别**：CLI 工具会根据任务描述自动识别何时需要使用此技能
- **路径转换**：支持 A-Z 驱动器盘符的完整转换
- **格式处理**：自动转换路径分隔符和驱动器大小写
- **错误处理**：无效路径会返回清晰的错误信息