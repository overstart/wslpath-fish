---
name: to_wsl
description: 将 Windows 路径转换为 WSL 路径格式的 Fish shell 函数。这是 wslpath-fish 插件的一部分，用于在 WSL 环境中访问 Windows 文件，或在跨平台开发中统一路径格式。项目地址：https://github.com/overstart/wslpath-fish
allowed-tools: Bash(fish)
---

# to_wsl - Windows 路径转 WSL 路径

## 功能描述

`to_wsl` 是 Fish shell 插件 [wslpath-fish](https://github.com/overstart/wslpath-fish) 中的核心函数，用于将 Windows 路径格式转换为 WSL 路径格式。

- **输入**：Windows 路径（如 `C:\Users\test\file.txt`）
- **输出**：WSL 路径（如 `/mnt/c/Users/test/file.txt`）

## 使用方法

### 基本用法

```bash
# 直接使用函数
to_wsl "C:\Users\test\file.txt"
# 输出: /mnt/c/Users/test/file.txt

to_wsl "D:\project\code"
# 输出: /mnt/d/project/code
```

### 在命令中使用

```bash
# 结合其他命令使用
cat $(to_wsl "C:\Users\10103\Documents\file.txt")

# 编辑文件
vim $(to_wsl "C:\project\config.json")

# 复制文件
cp $(to_wsl "C:\source\file.txt") ~/backup/
```

## 路径格式

### Windows 路径格式
- `C:\path\to\file`
- `D:\project\code`
- 支持的驱动器：A-Z

### WSL 路径格式
- `/mnt/c/path/to/file`
- `/mnt/d/project/code`

## 转换规则

1. **驱动器盘符转换**：从 `C:` → `/mnt/c/`（自动转换为小写）
2. **路径分隔符转换**：`\` → `/`
3. **前缀添加**：自动添加 `/mnt/` 前缀
4. **智能检测**：如果输入已经是 WSL 路径格式，会原样返回

## 使用场景

### 1. 在 WSL 中访问 Windows 文件

```bash
# 转换 Windows 路径后访问文件
to_wsl "C:\Users\username\Documents\file.txt"
# /mnt/c/Users/username/Documents/file.txt

# 在命令中使用
cat $(to_wsl "C:\Users\test\config.txt")
```

### 2. 在脚本中统一路径格式

```bash
# 脚本中使用转换函数
wsl_path=$(to_wsl "$windows_path")
echo "WSL path: $wsl_path"
```

### 3. 跨平台开发工具

```bash
# 编辑器中使用
editor $(to_wsl "C:\project\file.js")

# Git 操作中
git add $(to_wsl "C:\project\newfile.txt")
```

### 4. 批量文件处理

```bash
# 批量转换路径
for file in "C:\dir1\file1.txt" "D:\dir2\file2.txt"
    wsl_file=$(to_wsl "$file")
    echo "$wsl_file"
end
```

## 注意事项

- 函数已安装在 Fish shell 中，可直接使用，无需 source
- 如果输入已经是 WSL 路径格式，函数会原样返回
- 无效的路径格式会返回错误信息
- 自动处理路径分隔符转换
- 驱动器盘符自动转换为小写
- 支持的驱动器盘符：A-Z

## 错误处理

```bash
# 无效格式
to_wsl "invalid_path"
# 输出: Invalid Windows path format. Expected C:\...

# 已经是 WSL 路径
to_wsl "/mnt/c/Users/test/file.txt"
# 输出: /mnt/c/Users/test/file.txt

# 缺少路径
to_wsl "C:"
# 输出: Invalid Windows path format. Expected C:\...
```

## 相关命令

wslpath-fish 插件还提供以下相关函数：

- **`to_windows`** - WSL 路径转 Windows 路径
  ```bash
  to_windows "/mnt/c/Users/test/file.txt"
  # 输出: C:\Users\test\file.txt
  ```

- **`convert_path`** - 自动检测并转换路径
  ```bash
  convert_path "C:\test"           # 输出: /mnt/c/test
  convert_path "/mnt/c/test"       # 输出: C:\test
  ```

## 安装

### 验证安装

```bash
# 检查函数是否可用
type to_wsl

# 测试转换
to_wsl "C:\Users\test\file.txt"
```

### 安装方法

函数已安装在 Fish shell 插件目录中，无需额外配置。

如果需要重新安装或更新，可以从 GitHub 仓库获取：

```bash
# 克隆仓库
git clone https://github.com/overstart/wslpath-fish.git

# 复制函数文件到 Fish 配置目录
mkdir -p ~/.config/fish/functions
cp wslpath-fish/to_wsl.fish ~/.config/fish/functions/
cp wslpath-fish/to_windows.fish ~/.config/fish/functions/
cp wslpath-fish/convert_path.fish ~/.config/fish/functions/

# 重新加载 Fish 配置
source ~/.config/fish/config.fish
```

## 项目信息

- **项目名称**：wslpath-fish
- **项目地址**：https://github.com/overstart/wslpath-fish
- **许可证**：MIT
- **语言**：Fish shell

## 示例

### 基础示例

```bash
# 转换文件路径
to_wsl "C:\Users\10103\Documents\file.md"
# /mnt/c/Users/10103/Documents/file.md

# 转换目录路径
to_wsl "D:\projects\myapp"
# /mnt/d/projects/myapp

# 不同驱动器
to_wsl "E:\data\backup.zip"
# /mnt/e/data/backup.zip
```

### 实际应用示例

```bash
# 在 iflow 中读取 Windows 文件
cat $(to_wsl "C:\Users\username\Documents\note.md")

# 在 WSL 中运行 Windows 程序
/mnt/c/Program\ Files/MyApp/app.exe $(to_wsl "D:\data\input.txt")

# 配置文件管理
cp $(to_wsl "C:\config\settings.json") ~/.config/myapp/settings.json

# 日志文件分析
tail -f $(to_wsl "C:\logs\application.log")
```

## 常见问题

**Q: 为什么需要这个函数？**
A: WSL 和 Windows 使用不同的路径格式，这个函数帮助你在两种格式之间自动转换，无需手动修改路径。

**Q: 支持网络路径吗？**
A: 当前版本不支持网络路径（如 `\\server\share`），仅支持本地驱动器路径。

**Q: 路径中有空格怎么办？**
A: 使用引号包裹路径即可：
```bash
to_wsl "C:\Program Files\MyApp\config.ini"
```

**Q: 可以在 bash 中使用吗？**
A: 不可以，这是 Fish shell 专用函数。bash 用户可以使用 `wslpath` 命令。

**Q: 需要安装或配置吗？**
A: 不需要，函数已经安装在 Fish shell 插件目录中，可以直接使用。

## 更多信息

- 完整文档：https://github.com/overstart/wslpath-fish
- 提交问题：https://github.com/overstart/wslpath-fish/issues
- 贡献代码：欢迎提交 Pull Request