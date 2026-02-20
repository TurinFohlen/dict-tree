# 🌳 dict-tree: 智能命令行字典树

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

`dict-tree` 是一个智能的命令行工具管理器和查询引擎。它通过统一的元数据注释块自动扫描、索引和搜索你所有的脚本和系统命令，并支持通过 AI（如 DeepSeek、Gemini、Claude）解释命令的用法。

无论你是拥有大量自定义脚本的开发者，还是想更高效学习 Linux 命令的新手，`dict-tree` 都能让你的命令行生活井井有条。

---

## ✨ 特性

- **自动发现与索引**：扫描指定目录，自动提取脚本头部的元数据（名称、描述、用法、标签等），构建可搜索的字典树。
- **快速搜索**：支持前缀匹配、标签搜索、关键词搜索，瞬间找到你需要的命令。
- **AI 智能解释**：集成 DeepSeek、Gemini、Claude 等 AI 提供商，输入 `explain <命令>` 即可获得详细的用法说明和最佳实践。
- **多 AI 提供商动态切换**：通过 `-p` 参数临时切换 AI 后端，无需修改配置。
- **安全密钥管理**：AI 密钥可临时输入（仅存内存），也可通过环境变量设置，兼顾便捷与隐私。
- **递归扫描**：自动穿透子目录，不放过任何一个脚本。
- **可扩展性强**：只需在脚本头部添加标准化的元数据注释块，即可被自动收录，支持 Bash、Python、Ruby 等多种语言。
- **轻量级**：纯 Python + Bash 实现，依赖少，运行快。

---

## 🚀 快速开始

### 1. 克隆仓库
```bash
git clone git@github.com:TurinFohlen/dict-tree.git
cd dict-tree
```

2. 安装依赖

```bash
pip install requests       # 必需，用于调用 AI API
# 如果使用 Gemini，还需安装 google-generativeai
# pip install google-generativeai
# 如果使用 Claude，还需安装 anthropic
# pip install anthropic
```

3. 赋予执行权限

```bash
chmod +x cmdtree
```

4. 首次运行：扫描你自己的脚本目录

```bash
./cmdtree scan ~/bin          # 假设你的脚本放在 ~/bin
```

如果没有脚本目录，可以先扫描 dict-tree 自身测试：

```bash
./cmdtree scan .
```

5. 搜索命令

```bash
./cmdtree search ls            # 精确匹配
./cmdtree search "文件管理"     # 按标签搜索
./cmdtree search "how to copy" # 自然语言（若 AI 启用）
```

6. 使用 AI 解释命令（可选）

```bash
./cmdtree explain ls -p deepseek   # 使用 DeepSeek 解释 ls
```

系统会提示输入 API 密钥（输入时不显示），密钥仅保存在内存中。

---

📖 详细用法

命令结构

```
cmdtree <命令> [参数]
```

子命令 功能 示例
scan [目录] 扫描目录并建立/更新索引 cmdtree scan ~/scripts
search <关键词> 搜索命令 cmdtree search git
explain [-p 提供商] <命令> 用 AI 解释命令 cmdtree explain -p gemini ls
stats 显示索引统计信息 cmdtree stats
help 显示帮助 cmdtree help

环境变量与配置

· 默认 AI 提供商：AI_PROVIDER（可选 deepseek/gemini/claude，默认为 deepseek）
· API 密钥：可通过环境变量设置（如 DEEPSEEK_API_KEY），也可在运行时临时输入（推荐，更安全）。
· 扫描默认目录：可在 cmdtree 脚本中修改 DEFAULT_SCAN_DIR。

如何为你的脚本添加元数据

在任何脚本（Bash、Python 等）的头部添加以下格式的注释块：

```bash
#!/bin/bash
# === BEGIN METADATA ===
# name: 脚本名
# description: 简短描述
# usage: 用法示例
# tags: 标签1,标签2
# === END METADATA ===
```

例如 hello.sh：

```bash
#!/bin/bash
# === BEGIN METADATA ===
# name: hello
# description: 打印问候语
# usage: hello [名字]
# tags: 基本,示例
# === END METADATA ===
echo "Hello, ${1:-World}!"
```

之后运行 cmdtree scan 所在目录，即可被自动收录。

---

🔧 高级功能

多 AI 提供商支持

· DeepSeek：设置 DEEPSEEK_API_KEY 或运行时输入。
· Gemini：安装 google-generativeai，设置 GEMINI_API_KEY。
· Claude：安装 anthropic，设置 ANTHROPIC_API_KEY。

临时切换提供商：

```bash
cmdtree explain -p gemini curl
```

递归扫描子目录

scan 命令默认递归扫描所有子目录。如果你只想扫描当前目录，可修改 file_scanner.py 中的 recursive 参数（目前为固定 True）。

手动添加系统命令

对于系统内置命令（如 ls、grep），它们本身没有元数据注释。你可以通过创建占位元数据文件来收录它们（例如放在 ~/system_commands 下），参考 generate_system_commands.sh 脚本。

---

🤝 贡献指南

欢迎任何形式的贡献！你可以：

· 提交问题：在 GitHub Issues 中报告 bug 或提出新功能建议。
· 改进代码：Fork 仓库，创建新分支，提交 Pull Request。
· 完善文档：修正错别字，补充示例，翻译成其他语言。
· 添加新 AI 提供商：在 ai_providers/ 目录下新建一个 Python 文件，实现 AIProvider 接口（参考 deepseek.py），并在 query_engine.py 的类名映射中添加对应条目。

开发流程：

1. Fork 本仓库。
2. 创建你的特性分支 (git checkout -b feature/amazing-feature)。
3. 提交修改 (git commit -m 'Add some amazing feature')。
4. 推送到分支 (git push origin feature/amazing-feature)。
5. 打开一个 Pull Request。

请确保代码风格一致，并添加必要的注释（当然，我们推崇自解释代码 😉）。

---

📜 许可证

本项目基于 MIT 许可证开源，详情见 LICENSE 文件。

---

💬 联系我们

如果你有任何问题或建议，欢迎通过 GitHub Issues 与我们交流。
也欢迎关注项目动态，点亮 ⭐ 支持一下！

Happy commanding! 🚀
