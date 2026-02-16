# 📝 Dict-Tree v1.2.0 更新说明

## 🎯 本次更新重点

### 1. ✅ 统一命名规范
**问题**: 文件名使用下划线（`file_scanner.py`），但元数据中使用连字符（`file-scanner`）
**解决**: 全部统一为下划线命名

#### 修改详情
```diff
# file_scanner.py
- # name: file-scanner
+ # name: file_scanner

# metadata_parser.py  
- # name: metadata-parser
+ # name: metadata_parser

# storage_tree.py
- # name: storage-tree
+ # name: storage_tree

# test_api.py
- # name: test-api
+ # name: test_api
```

### 2. 🔐 API密钥安全改进
**问题**: 之前需要将API密钥保存在环境变量中，存在安全隐患
**解决**: 改为临时输入，仅保存在内存中，不写入任何文件

#### 新的工作方式
```
用户运行: cmdtree explain ls

系统提示: 🔐 使用 DEEPSEEK AI 功能需要 API 密钥
         提示：输入的密钥仅保存在内存中，不会写入任何文件
         请输入 DEEPSEEK API 密钥（输入时不显示）: ********

[密钥验证通过]
✅ 已加载 AI 提供商: deepseek

[显示命令解释...]
```

#### 技术实现
- 使用Python的 `getpass` 模块安全输入（输入时不显示）
- API密钥仅存储在内存中，程序退出后自动清除
- 延迟加载AI提供商，只在需要时才请求密钥
- 支持传入密钥或从环境变量读取（兼容两种方式）

---

## 📊 版本对比

| 功能 | v1.1.1 | v1.2.0 |
|------|--------|--------|
| 命名规范 | 不统一（混用 `-` 和 `_`） | ✅ 统一使用 `_` |
| API密钥存储 | 环境变量（有安全隐患） | ✅ 临时输入（内存中） |
| 密钥输入方式 | 提前设置 | ✅ 需要时提示 |
| 密钥可见性 | 在环境变量中可见 | ✅ 输入时隐藏 |
| 隐私保护 | ⚠️ 较弱 | ✅ 强 |

---

## 🔧 更新的文件

### 核心模块
- ✅ `query_engine.py` (v1.2.0) - 支持临时输入API密钥
- ✅ `file_scanner.py` (v1.1.0) - 统一命名
- ✅ `metadata_parser.py` - 统一命名
- ✅ `storage_tree.py` - 统一命名
- ✅ `test_api.py` - 统一命名

### AI提供商
- ✅ `ai_providers/deepseek.py` (v1.1.0) - 支持传入API密钥
- ✅ `ai_providers/gemini.py` (v1.1.0) - 支持传入API密钥
- ✅ `ai_providers/claude.py` (v1.1.0) - 支持传入API密钥

### 脚本
- ✅ `cmdtree_fixed` (v1.1.2) - 更新帮助信息

---

## 🚀 如何使用新版本

### 方法1: 不设置环境变量（推荐）
```bash
# 直接使用，需要时会提示输入
./cmdtree explain ls

# 系统会提示：
# 🔐 使用 DEEPSEEK AI 功能需要 API 密钥
# 请输入 DEEPSEEK API 密钥（输入时不显示）: 
```

### 方法2: 仍可使用环境变量（兼容旧方式）
```bash
# 设置环境变量
export DEEPSEEK_API_KEY="sk-xxx"
export AI_PROVIDER="deepseek"

# 使用时不会再次提示
./cmdtree explain ls
```

### 方法3: 切换提供商
```bash
# 使用Gemini
./cmdtree explain -p gemini ls
# 会提示输入 GEMINI API 密钥

# 使用Claude
./cmdtree explain -p claude ls
# 会提示输入 CLAUDE API 密钥
```

---

## 🔒 安全特性

### API密钥保护
1. **输入时隐藏**: 使用 `getpass`，输入时屏幕不显示任何字符
2. **仅存内存**: 密钥只保存在Python进程的内存中
3. **不写文件**: 绝不将密钥写入配置文件、日志或磁盘
4. **自动清除**: 程序退出时，密钥随内存释放而清除
5. **可取消**: 用户可以按 Ctrl+C 取消输入，不会强制要求

### 使用建议
```bash
# ✅ 推荐：每次使用时临时输入
./cmdtree explain ls

# ⚠️ 不推荐：将密钥写入 .bashrc 或 .zshrc
# 这样密钥会保存在文件中，降低安全性

# ✅ 可接受：在当前会话中临时设置（会话结束后自动清除）
export DEEPSEEK_API_KEY="sk-xxx"
./cmdtree explain ls
```

---

## 📋 更新步骤

### 步骤1: 备份现有版本（可选）
```bash
cp -r dict-tree-fixed dict-tree-fixed.backup
```

### 步骤2: 下载新版本
选择以下任一方式：
- 下载 `dict-tree-fixed.tar.gz` (Linux/macOS)
- 下载 `dict-tree-fixed.zip` (Windows)
- 下载完整目录

### 步骤3: 解压并替换
```bash
# .tar.gz
tar -xzf dict-tree-fixed.tar.gz

# .zip
unzip dict-tree-fixed.zip

# 进入目录
cd dict-tree-fixed
```

### 步骤4: 测试新功能
```bash
# 测试命名统一（应该看到统一的下划线命名）
./cmdtree_fixed scan .

# 测试API密钥输入（会提示输入密钥）
./cmdtree_fixed explain ls
```

---

## ⚠️ 注意事项

### 1. 环境变量仍然有效
如果你之前设置了环境变量，新版本仍然会优先使用：
```bash
export DEEPSEEK_API_KEY="sk-xxx"
./cmdtree explain ls  # 不会提示输入，直接使用环境变量
```

### 2. 密钥输入一次即可
在同一次命令执行中，只需要输入一次密钥：
```bash
./cmdtree explain ls    # 提示输入密钥
# [输入密钥]
# [显示ls的解释]

# 如果再次调用，会在同一会话中保持密钥
```

但是每次运行 `cmdtree` 都需要重新输入（这是设计的安全特性）

### 3. 取消输入
按 `Ctrl+C` 可以取消输入，程序会继续运行，但AI功能将被禁用。

---

## 🐛 故障排除

### Q1: 输入密钥后仍然提示错误
**检查**:
```bash
# 确认密钥格式正确
# DeepSeek: sk-xxxxxxxx
# Gemini: AIza-xxxxxxxx  
# Claude: sk-ant-xxxxxxxx

# 测试密钥是否有效
python3 -c "
from ai_providers.deepseek import DeepSeekProvider
p = DeepSeekProvider(api_key='your_key')
print(p.generate('test'))
"
```

### Q2: 看不到输入的字符是正常的吗？
**是的**！这是安全特性，输入时屏幕不会显示任何字符，包括 `*` 号。只管输入后按回车即可。

### Q3: 如何避免每次都输入密钥？
**方式1**: 设置临时环境变量（推荐）
```bash
export DEEPSEEK_API_KEY="sk-xxx"
```

**方式2**: 写入shell配置（不推荐，但方便）
```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
echo 'export DEEPSEEK_API_KEY="sk-xxx"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🎉 总结

v1.2.0 版本主要改进了两个方面：

1. **美观性** - 统一命名规范，所有名称都使用下划线
2. **安全性** - API密钥临时输入，不保存到文件，保护隐私

这些改进让 dict-tree 更加专业和安全！

---

**版本**: v1.2.0  
**更新日期**: 2026-02-17  
**状态**: ✅ 已测试通过  
**向后兼容**: ✅ 完全兼容 v1.1.x
