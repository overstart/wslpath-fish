/**
 * @overstart/to-wsl-skill
 *
 * wslpath-fish 是一个 Fish shell 插件，用于在 Windows 路径和 WSL 路径之间快速转换
 *
 * 这是一个 CLI 技能包，提供 Windows 和 WSL 路径之间的转换功能。
 *
 * @see https://github.com/overstart/wslpath-fish
 */
module.exports = {
  name: 'wslpath-fish',
  description: 'wslpath-fish 是一个 Fish shell 插件，用于在 Windows 路径和 WSL 路径之间快速转换。提供 to_wsl、to_windows 和 convert_path 三个核心函数',
  version: require('./package.json').version,
  homepage: 'https://github.com/overstart/wslpath-fish',
  repository: 'https://github.com/overstart/wslpath-fish',
  author: 'overstart',
  license: 'MIT'
};