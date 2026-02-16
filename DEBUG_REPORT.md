# Dict-Tree ModuleNotFoundError 调试报告

## 📋 问题摘要
**错误类型**: `ModuleNotFoundError: No module named 'query_engine'`
**影响范围**: cmdtree的search、explain、stats命令均无法正常工作

---

## 🔍 根本原因分析（基于CSR图）

### 节点1: 问题现象
```
ModuleNotFoundError: No module named 'query_engine'
```

### 节点2: cmdtree脚本问题
**问题1 - Termux专用Shebang**
```bash
#!/data/data/com.termux/files/usr/bin/bash  # ❌ 仅在Termux环境有效
```
- 该路径仅存在于Android Termux环境
- 在标准Linux/macOS系统上会导致脚本无法执行

**问题2 - 子Shell导致的路径丢失**
```bash
(
    cd "$SCRIPT_DIR"
    python3 << PYEOF
sys.path.insert(0, ".")  # ❌ "."指的是子shell的当前目录
```
- 使用`()`创建子shell会导致环境变量和工作目录隔离
- `cd "$SCRIPT_DIR"`的效果在子shell结束后丢失
- `sys.path.insert(0, ".")`添加的是相对路径，不够可靠

**问题3 - 缺少PYTHONPATH设置**
- 脚本未设置`PYTHONPATH`环境变量
- Python解释器无法找到脚本目录中的模块

### 节点3: query_engine模块
✅ **模块本身没有问题**
- 代码结构正确
- 语法无误
- 依赖关系清晰

### 节点4: Python路径机制
**Python模块搜索顺序**:
1. 当前工作目录
2. PYTHONPATH环境变量指定的目录
3. 标准库目录
4. site-packages目录

**问题所在**: cmdtree脚本没有正确配置上述任何一项

---

## 🔧 修复方案（节点5 → 节点6）

### 修复1: 使用标准Shebang
```bash
#!/usr/bin/env bash  # ✅ 跨平台兼容
```
- 使用`env`自动查找系统bash路径
- 兼容Linux、macOS、Termux等环境

### 修复2: 设置PYTHONPATH环境变量
```bash
export PYTHONPATH="$SCRIPT_DIR:$PYTHONPATH"
```
- 将脚本目录添加到Python模块搜索路径
- 确保所有Python导入都能找到模块

### 修复3: 在Python代码中添加绝对路径
```python
import sys
import os
script_dir = "$SCRIPT_DIR"  # Bash变量会被展开
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)
```
- 双重保险：即使PYTHONPATH失效，Python代码仍能正确导入
- 使用绝对路径而非相对路径

### 修复4: 移除不必要的子Shell和cd命令
```bash
# 旧版本
(
    cd "$SCRIPT_DIR"
    python3 << PYEOF
    ...
)

# 新版本
export PYTHONPATH="$SCRIPT_DIR:$PYTHONPATH"
python3 << PYEOF
...
PYEOF
```

---

## ✅ 验证步骤

### 1. 检查文件权限
```bash
chmod +x cmdtree_fixed
```

### 2. 测试stats命令（不需要索引文件）
```bash
./cmdtree_fixed stats
```

### 3. 测试scan命令
```bash
./cmdtree_fixed scan /tmp/dict-tree
```

### 4. 测试search命令
```bash
./cmdtree_fixed search query
```

### 5. 调试模式（如果还有问题）
```bash
# 在cmdtree_fixed开头添加调试输出
set -x  # 显示每条执行的命令
export PYTHONPATH="$SCRIPT_DIR:$PYTHONPATH"
echo "DEBUG: SCRIPT_DIR=$SCRIPT_DIR"
echo "DEBUG: PYTHONPATH=$PYTHONPATH"
```

---

## 📊 修复前后对比

| 项目 | 修复前 | 修复后 |
|------|--------|--------|
| Shebang | Termux专用 | 跨平台兼容 |
| PYTHONPATH | 未设置 | 正确设置 |
| 路径插入 | 相对路径`.` | 绝对路径`$SCRIPT_DIR` |
| 子Shell | 使用`()` | 直接执行 |
| 可移植性 | 仅Termux | 所有Unix系统 |

---

## 🎯 最终交付清单

- [x] **cmdtree_fixed**: 修复后的主脚本
- [x] **调试报告**: 本文档
- [x] **验证步骤**: 上述测试命令
- [ ] **替换原文件**: `mv cmdtree_fixed cmdtree`（用户自行决定）

---

## 💡 最佳实践建议

### 1. 脚本开发规范
- 始终使用`#!/usr/bin/env bash`而非硬编码路径
- 在脚本开头获取并保存脚本目录的绝对路径
- 对于需要导入的Python脚本，始终设置PYTHONPATH

### 2. Python导入规范
- 在脚本中明确添加模块路径到sys.path
- 优先使用绝对路径而非相对路径
- 在开发阶段添加调试输出确认路径正确

### 3. 跨平台兼容性
- 避免使用平台特定的路径（如Termux路径）
- 测试脚本在不同环境下的表现
- 使用环境变量和相对路径提高可移植性

---

## 🔗 相关文件

- **原脚本**: `/tmp/dict-tree/cmdtree`
- **修复版本**: `/tmp/dict-tree/cmdtree_fixed`
- **Python模块**: `/tmp/dict-tree/query_engine.py`
- **其他模块**: `file_scanner.py`, `storage_tree.py`, `metadata_parser.py`

---

## 📞 进一步帮助

如果修复后仍然遇到问题：

1. **检查Python版本**: `python3 --version` (需要3.6+)
2. **验证模块存在**: `ls -la /tmp/dict-tree/*.py`
3. **手动测试导入**: 
   ```bash
   cd /tmp/dict-tree
   python3 -c "import query_engine; print('导入成功')"
   ```
4. **查看详细错误**: 在Python代码中添加`import traceback; traceback.print_exc()`

---

生成时间: 2026-02-17
版本: 1.0
状态: ✅ 已完成
