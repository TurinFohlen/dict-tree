# 🚀 Dict-Tree 快速修复参考卡

## 问题
```
ModuleNotFoundError: No module named 'query_engine'
```

## 根本原因
1. ❌ Termux专用路径 → 不跨平台
2. ❌ 子Shell `()` → 环境变量丢失
3. ❌ 相对路径 `.` → 不可靠
4. ❌ 缺PYTHONPATH → Python找不到模块

## 一键修复
```bash
# 1. 进入项目目录
cd /path/to/dict-tree

# 2. 备份原文件
cp cmdtree cmdtree.backup

# 3. 使用修复版
cp cmdtree_fixed cmdtree
chmod +x cmdtree

# 4. 测试
./cmdtree help
./cmdtree scan .
./cmdtree search query
```

## 核心修改
```bash
# 1. Shebang改为跨平台
#!/usr/bin/env bash

# 2. 每个函数开头添加
export PYTHONPATH="$SCRIPT_DIR:$PYTHONPATH"

# 3. Python代码开头添加
import sys
script_dir = "$SCRIPT_DIR"
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)
```

## 验证成功的标志
✅ 无 ModuleNotFoundError  
✅ 能看到 "⚠️ 未加载 AI 提供商"  
✅ scan命令正常运行  
✅ search命令正常运行  

## 如果还有问题
```bash
# 手动测试导入
cd /path/to/dict-tree
python3 -c "import sys; sys.path.insert(0, '.'); import query_engine; print('OK')"

# 查看Python路径
python3 -c "import sys; print('\n'.join(sys.path))"
```

## 文件位置
- `cmdtree_fixed` - 修复后的脚本
- `DEBUG_REPORT.md` - 详细分析
- `INSTALL_GUIDE.md` - 完整指南
- 本文件 - 快速参考

---
版本: v1.1.1 (Fixed) | 日期: 2026-02-17
