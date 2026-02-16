# 📝 Dict-Tree 更新日志

## 2026-02-17 - v1.2.0 更新 🔐

### ✅ 主要改进

#### 1. 统一命名规范
- **问题**: 文件名使用下划线，元数据使用连字符，不一致
- **解决**: 全部统一为下划线命名
- **影响文件**:
  - `file_scanner.py`: `file-scanner` → `file_scanner`
  - `metadata_parser.py`: `metadata-parser` → `metadata_parser`
  - `storage_tree.py`: `storage-tree` → `storage_tree`
  - `test_api.py`: `test-api` → `test_api`

#### 2. API密钥安全改进 ⭐
- **旧方式**: 需要设置环境变量（如 `export DEEPSEEK_API_KEY="..."`）
- **新方式**: 临时输入，仅保存在内存中
- **安全特性**:
  - ✅ 使用 `getpass` 模块，输入时不显示
  - ✅ 密钥仅存储在内存中
  - ✅ 不写入任何文件或日志
  - ✅ 程序退出后自动清除
  - ✅ 用户可按 Ctrl+C 取消

#### 3. 优化用户体验
- 延迟加载AI提供商（只在需要时才请求密钥）
- 更清晰的提示信息
- 支持环境变量和临时输入两种方式（向后兼容）

### 🔄 已更新文件
- `query_engine.py` (v1.2.0) - 支持临时输入API密钥
- `ai_providers/deepseek.py` (v1.1.0) - 支持传入API密钥
- `ai_providers/gemini.py` (v1.1.0) - 支持传入API密钥
- `ai_providers/claude.py` (v1.1.0) - 支持传入API密钥
- `cmdtree_fixed` (v1.1.2) - 更新帮助信息
- 所有Python文件 - 统一命名规范

### 📋 使用示例
```bash
# 新方式：临时输入（推荐）
./cmdtree explain ls
# 🔐 使用 DEEPSEEK AI 功能需要 API 密钥
# 请输入 DEEPSEEK API 密钥（输入时不显示）: ********

# 旧方式：环境变量（仍然支持）
export DEEPSEEK_API_KEY="sk-xxx"
./cmdtree explain ls
```

---

## 2026-02-17 - v1.1.1 更新

### ✅ 已修复
1. **ModuleNotFoundError** - 完全解决模块导入问题
2. **跨平台兼容性** - 从Termux专用改为通用bash脚本
3. **路径机制** - 正确设置PYTHONPATH和sys.path

### 🔄 已更新

#### file_scanner.py (v1.1.0)
**主要改进**：
- ✅ 添加 `.resolve()` 确保使用绝对路径
- ✅ 添加 `is_dir()` 检查，更严格的验证
- ✅ 跳过符号链接，避免循环和重复
- ✅ 添加 `try-except` 异常处理
- ✅ 捕获 `PermissionError` 和其他异常
- ✅ 扫描过程更加健壮，不会因单个文件出错而中断

**新增功能**：
```python
# 1. 更严格的目录验证
if not dir_path.is_dir():
    raise NotADirectoryError(f"路径不是目录: {directory}")

# 2. 跳过符号链接
if not file_path.is_file() or file_path.is_symlink():
    continue

# 3. 异常处理
except PermissionError:
    print(f"  ⚠ 权限不足，跳过: {file_path}")
except Exception as e:
    print(f"  ⚠ 处理文件时出错 {file_path}: {e}")
```

#### cmdtree (v1.1.1)
**主要修复**：
- ✅ 跨平台Shebang: `#!/usr/bin/env bash`
- ✅ 设置PYTHONPATH环境变量
- ✅ Python代码中添加绝对路径
- ✅ 移除不必要的子Shell

### 📦 文件清单

**核心文件**：
- `cmdtree_fixed` - 修复后的主脚本 ⭐
- `file_scanner.py` - 更新的文件扫描器 (v1.1.0)
- `query_engine.py` - 查询引擎（无需修改）
- `storage_tree.py` - 存储树（无需修改）
- `metadata_parser.py` - 元数据解析器（无需修改）

**文档文件**：
- `README_FIX.md` - 修复总结
- `DEBUG_REPORT.md` - 详细调试报告
- `INSTALL_GUIDE.md` - 安装指南
- `QUICK_FIX.md` - 快速参考卡
- `COMPARISON.md` - 修复前后对比
- `CHANGELOG.md` - 本文件

### 🔧 如何应用更新

#### 方法1: 完整替换（推荐）
```bash
# 1. 备份原文件
cp cmdtree cmdtree.backup
cp file_scanner.py file_scanner.py.backup

# 2. 应用更新
cp cmdtree_fixed cmdtree
chmod +x cmdtree

# 3. file_scanner.py 已经是最新版本，无需额外操作

# 4. 测试
./cmdtree scan .
./cmdtree search query
```

#### 方法2: 手动更新
如果你修改过原文件，可以参考修复内容手动更新：

**cmdtree 主要修改点**：
1. 第1行: `#!/usr/bin/env bash`
2. 在每个cmd_*函数开头添加：
   ```bash
   export PYTHONPATH="$SCRIPT_DIR:$PYTHONPATH"
   ```
3. 在Python代码开头添加：
   ```python
   import sys
   script_dir = "$SCRIPT_DIR"
   if script_dir not in sys.path:
       sys.path.insert(0, script_dir)
   ```

**file_scanner.py 主要修改点**：
1. 第6行版本号: `1.1.0`
2. 第45行: 添加 `.resolve()`
3. 第48-49行: 添加 `is_dir()` 检查
4. 第66-75行: 添加异常处理

### ⚠️ 重要提示

1. **Python版本要求**: Python 3.6+
2. **权限要求**: cmdtree需要可执行权限 (`chmod +x cmdtree`)
3. **依赖要求**: 所有Python模块需要在同一目录
4. **AI功能**: 需要设置相应的API Key环境变量

### 🧪 测试清单

运行以下命令验证更新：
```bash
# 1. 基本功能
./cmdtree help

# 2. 扫描功能（测试file_scanner更新）
./cmdtree scan .

# 3. 搜索功能（测试模块导入修复）
./cmdtree search query

# 4. 统计功能
./cmdtree stats
```

**预期结果**：
- ✅ 无 `ModuleNotFoundError` 错误
- ✅ 扫描时跳过无权限文件而不中断
- ✅ 扫描时跳过符号链接
- ✅ 所有命令正常运行

### 🐛 已知问题

无

### 📞 反馈

如果发现问题，请提供：
1. 错误信息
2. Python版本 (`python3 --version`)
3. 操作系统信息
4. 执行的完整命令

---

**版本**: v1.1.1  
**更新日期**: 2026-02-17  
**状态**: ✅ 稳定版
