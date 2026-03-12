---
name: wslpath-fish
description: wslpath-fish 是一个 Fish shell 插件，用于在 Windows 路径和 WSL 路径之间快速转换。提供 to_wsl、to_windows 和 convert_path 三个核心函数，支持 Windows 驱动器路径、WSL /mnt/ 路径和 WSL 网络路径之间的相互转换。项目地址：https://github.com/overstart/wslpath-fish
allowed-tools: Bash(fish)
---

# wslpath-fish - WSL/Windows 路径转换插件

## 功能描述

wslpath-fish 是一个 Fish shell 插件，用于在 Windows 路径和 WSL 路径之间快速转换。提供三个核心函数：

- **to_wsl** - Windows 路径转 WSL 路径
  - 输入：Windows 路径（如 `C:\Users\test\file.txt`）
  - 输出：WSL 路径（如 `/mnt/c/Users/test/file.txt`）

- **to_windows** - WSL 路径转 Windows 路径
  - 输入：WSL /mnt/ 路径（如 `/mnt/c/Users/test/file.txt`）
  - 输出：Windows 路径（如 `C:\Users\test\file.txt`）
  - 输入：WSL 内部路径（如 `/etc/config/`）
  - 输出：WSL 网络路径（如 `\\wsl.localhost\archlinux\etc\config\`）

- **convert_path** - 自动检测并转换路径
  - 自动识别输入路径格式并执行相应转换

## 使用方法

### to_wsl - Windows 路径转 WSL 路径

```bash
# 基本用法
to_wsl "C:\Users\test\file.txt"
# 输出: /mnt/c/Users/test/file.txt

to_wsl "D:\project\code"
# 输出: /mnt/d/project/code
```

### to_windows - WSL 路径转 Windows 路径

```bash
# 转换 /mnt/ 驱动器路径
to_windows "/mnt/c/Users/test/file.txt"
# 输出: C:\Users\test\file.txt

# 转换 WSL 内部路径为 WSL 网络路径
to_windows "/etc/config/"
# 输出: \\wsl.localhost\archlinux\etc\config\

to_windows "/home/user/documents"
# 输出: \\wsl.localhost\archlinux\home\user\documents
```

### convert_path - 自动检测并转换

```bash
# Windows 路径 -> WSL 路径
convert_path "C:\test"
# 输出: /mnt/c/test

# WSL 路径 -> Windows 路径
convert_path "/mnt/c/test"
# 输出: C:\test

# WSL 内部路径 -> WSL 网络路径
convert_path "/etc/config/"
# 输出: \\wsl.localhost\archlinux\etc\config\
```

## 路径格式支持

### Windows 路径格式
- `C:\path\to\file`
- `D:\project\code`
- 支持的驱动器：A-Z

### WSL 路径格式
- `/mnt/c/path/to/file` - Windows 驱动器映射路径
- `/etc/config/` - WSL 内部路径

### WSL 网络路径格式
- `\\wsl.localhost\<发行版名称>\path\to\file`
- 用于从 Windows 访问 WSL 文件系统

## 转换规则

### to_wsl 转换规则
1. 驱动器盘符转换：从 `C:` → `/mnt/c/`（自动转换为小写）
2. 路径分隔符转换：`\` → `/`
3. 前缀添加：自动添加 `/mnt/` 前缀
4. 智能检测：如果输入已经是 WSL 路径格式，会原样返回

### to_windows 转换规则
1. 驱动器路径转换：
   - 驱动器盘符转换：从 `/mnt/c/` → `C:`（自动转换为大写）
   - 路径分隔符转换：`/` → `\`
   - 前缀移除：自动移除 `/mnt/` 前缀

2. WSL 内部路径转换：
   - 转换为 WSL 网络路径格式：`\\wsl.localhost\<发行版名称>\<路径>`
   - 路径分隔符转换：`/` → `\`
   - 发行版名称从 `WSL_DISTRO_NAME` 环境变量获取

### convert_path 转换规则
1. 检测 `/mnt/[a-z]/` 格式 → 调用 to_windows
2. 检测 `/` 开头（WSL 内部路径）→ 调用 to_windows
3. 检测 `[A-Za-z]:` 格式 → 调用 to_wsl
4. 其他格式 → 返回错误

## 使用场景

### 1. 在 WSL 中访问 Windows 文件

```bash
# 转换 Windows 路径后访问文件
to_wsl "C:\Users\username\Documents\file.txt"
# /mnt/c/Users/username/Documents/file.txt

# 在命令中使用
cat $(to_wsl "C:\Users\test\config.txt")
```

### 2. 在 Windows 中访问 WSL 文件

```bash
# 转换 WSL 内部路径为网络路径
to_windows "/etc/config/"
# \\wsl.localhost\archlinux\etc\config\

# 在 Windows 资源管理器中打开
explorer.exe $(to_windows "/home/user/documents")
```

### 3. 在脚本中统一路径格式

```bash
# 脚本中使用转换函数
wsl_path=$(to_wsl "$windows_path")
echo "WSL path: $wsl_path"
```

### 4. 跨平台开发工具

```bash
# 编辑器中使用
editor $(to_wsl "C:\project\file.js")

# Git 操作中
git add $(to_wsl "C:\project\newfile.txt")
```

### 5. 批量文件处理

```bash
# 批量转换路径
for file in "C:\dir1\file1.txt" "D:\dir2\file2.txt"
    wsl_file=$(to_wsl "$file")
    echo "$wsl_file"
end
```

## WSL 网络路径格式说明

`to_windows` 函数支持将 WSL 内部路径（如 `/etc/config/`）转换为 Windows WSL 网络路径格式。

**格式**：`\\wsl.localhost\<发行版名称>\<路径>`

**示例**：
```bash
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

- 函数已安装在 Fish shell 中，可直接使用，无需 source
- 如果输入已经是目标格式，函数会原样返回
- 无效的路径格式会返回错误信息
- 自动处理路径分隔符转换
- 驱动器盘符自动转换为正确的大小写
- 支持的驱动器盘符：A-Z
- `to_windows` 函数需要 `WSL_DISTRO_NAME` 环境变量来转换 WSL 内部路径
- 不支持网络路径（如 `\\server\share`）

## 错误处理

```bash
# 无效格式
to_wsl "invalid_path"
# 输出: Invalid Windows path format. Expected C:\...

# 已经是 WSL 路径
to_wsl "/mnt/c/Users/test/file.txt"
# 输出: /mnt/c/Users/test/file.txt

# WSL_DISTRO_NAME 未设置
to_windows "/etc/config/"
# 输出: Failed to get WSL distribution name. Please set WSL_DISTRO_NAME environment variable.
```

## 相关命令

wslpath-fish 插件提供以下三个核心函数：

- **`to_wsl`** - Windows 路径转 WSL 路径
  ```bash
  to_wsl "C:\Users\test\file.txt"
  # 输出: /mnt/c/Users/test/file.txt
  ```

- **`to_windows`** - WSL 路径转 Windows 路径
  ```bash
  # 转换 /mnt/ 驱动器路径
  to_windows "/mnt/c/Users/test/file.txt"
  # 输出: C:\Users\test\file.txt

  # 转换 WSL 内部路径为 WSL 网络路径
  to_windows "/etc/config/"
  # 输出: \\wsl.localhost\archlinux\etc\config\
  ```

- **`convert_path`** - 自动检测并转换路径
  ```bash
  convert_path "C:\test"           # 输出: /mnt/c/test
  convert_path "/mnt/c/test"       # 输出: C:\test
  convert_path "/etc/config/"      # 输出: \\wsl.localhost\archlinux\etc\config\
  ```

## 安装

### CLI 技能安装（推荐）

```bash
npx skills install overstart/wslpath-fish
```

### 手动安装

使用 Fisher 插件管理器安装：

```bash
fisher install overstart/wslpath-fish
```

或者手动安装：

```bash
# 克隆仓库
git clone https://github.com/overstart/wslpath-fish.git

# 复制函数文件到 Fish 配置目录
mkdir -p ~/.config/fish/functions
cp wslpath-fish/functions/to_wsl.fish ~/.config/fish/functions/
cp wslpath-fish/functions/to_windows.fish ~/.config/fish/functions/
cp wslpath-fish/functions/convert_path.fish ~/.config/fish/functions/

# 重新加载 Fish 配置
source ~/.config/fish/config.fish
```

### 验证安装

```bash
# 检查函数是否可用
type to_wsl
type to_windows
type convert_path

# 测试转换
to_wsl "C:\Users\test\file.txt"
to_windows "/mnt/c/Users/test/file.txt"
convert_path "C:\test"
```

## 项目信息

- **项目名称**：wslpath-fish
- **项目地址**：https://github.com/overstart/wslpath-fish
- **NPM 包**：@overstart/wslpath-fish
- **许可证**：MIT
- **语言**：Fish shell

## 示例

### 基础示例

```bash
# Windows 路径转 WSL 路径
to_wsl "C:\Users\10103\Documents\file.md"
# /mnt/c/Users/10103/Documents/file.md

# WSL 路径转 Windows 路径
to_windows "/mnt/d/projects/myapp"
# D:\projects\myapp

# WSL 内部路径转 WSL 网络路径
to_windows "/etc/config/"
# \\wsl.localhost\archlinux\etc\config\

# 自动检测并转换
convert_path "C:\test"
# /mnt/c/test

convert_path "/mnt/c/test"
# C:\test
```

### 实际应用示例

```bash
# 在 WSL 中读取 Windows 文件
cat $(to_wsl "C:\Users\username\Documents\note.md")

# 在 WSL 中运行 Windows 程序
/mnt/c/Program\ Files/MyApp/app.exe $(to_wsl "D:\data\input.txt")

# 配置文件管理
cp $(to_wsl "C:\config\settings.json") ~/.config/myapp/settings.json

# 日志文件分析
tail -f $(to_wsl "C:\logs\application.log")

# 在 Windows 资源管理器中打开 WSL 目录
explorer.exe $(to_windows "/home/user/projects")

# 自动转换路径
convert_path "C:\Users\test\file.txt" | xargs cat
```

## 常见问题

**Q: 为什么需要这个插件？**
A: WSL 和 Windows 使用不同的路径格式，这个插件帮助你在两种格式之间自动转换，无需手动修改路径。

**Q: 支持网络路径吗？**
A: 当前版本不支持 Windows 网络路径（如 `\\server\share`），仅支持本地驱动器路径和 WSL 内部路径。

**Q: 路径中有空格怎么办？**
A: 使用引号包裹路径即可：
```bash
to_wsl "C:\Program Files\MyApp\config.ini"
```

**Q: 可以在 bash 中使用吗？**
A: 不可以，这是 Fish shell 专用函数。bash 用户可以使用 `wslpath` 命令。

**Q: 需要安装或配置吗？**
A: 不需要，函数已经安装在 Fish shell 插件目录中，可以直接使用。

**Q: WSL 网络路径有什么用？**
A: WSL 网络路径允许从 Windows 访问 WSL 文件系统，可以在 Windows 资源管理器、应用程序和命令行中使用。

**Q: 如何获取 WSL 发行版名称？**
A: 可以通过 `echo $WSL_DISTRO_NAME` 查看，或者在 Windows 中运行 `wsl -l -v` 查看。

## 更多信息

- 完整文档：https://github.com/overstart/wslpath-fish
- 提交问题：https://github.com/overstart/wslpath-fish/issues
- 贡献代码：欢迎提交 Pull Request