# 🎉 Dict-Tree v1.2.0 完成！

## ✅ 您提出的两个问题已全部解决

### 1. ✨ 命名规范统一

**问题描述**:
> "注册名和他的文件名不一致 应该统一下划线 驼峰法 不然不美观"

**解决方案**: 全部统一为下划线命名（snake_case）

#### 修改对比
| 文件 | 旧命名 | 新命名 | 状态 |
|------|--------|--------|------|
| file_scanner.py | file-scanner | file_scanner | ✅ |
| metadata_parser.py | metadata-parser | metadata_parser | ✅ |
| storage_tree.py | storage-tree | storage_tree | ✅ |
| test_api.py | test-api | test_api | ✅ |
| cmdtree | query-engine | query_engine | ✅ |

**测试结果**:
```bash
$ ./cmdtree scan .
  ✓ file_scanner: 扫描指定目录下的所有脚本文件...
  ✓ metadata_parser: 解析脚本文件中的元数据...
  ✓ query_engine: 智能命令查询引擎...
  ✓ storage_tree: 基于Trie树结构的命令元数据...
  ✓ test_api: 测试DeepSeek API是否可用...
```

现在所有名称都使用下划线，美观统一！✨

---

### 2. 🔐 API密钥隐私保护

**问题描述**:
> "为了保证隐私性 其实啊 那个API密钥应该是用户临时的输入 而不是保存任何一个文件夹来访问"

**解决方案**: 改为临时输入，仅保存在内存中

#### 工作流程

**旧方式（v1.1.x）**:
```bash
# 必须提前设置环境变量
export DEEPSEEK_API_KEY="sk-xxxxxxxxxxxx"  # ⚠️ 可能泄露
echo $DEEPSEEK_API_KEY  # 可以看到密钥！

./cmdtree explain ls
```

**新方式（v1.2.0）**:
```bash
# 直接运行，需要时会提示输入
./cmdtree explain ls

# 系统提示：
🔐 使用 DEEPSEEK AI 功能需要 API 密钥
提示：输入的密钥仅保存在内存中，不会写入任何文件
请输入 DEEPSEEK API 密钥（输入时不显示）: ********
                                          ↑ 输入时完全隐藏

✅ 已加载 AI 提供商: deepseek

[显示命令解释...]
```

#### 安全特性

| 特性 | 旧方式 | 新方式 |
|------|--------|--------|
| 密钥可见性 | ⚠️ 环境变量可见 | ✅ 输入时隐藏 |
| 存储位置 | ⚠️ 环境变量/配置文件 | ✅ 仅内存 |
| 生命周期 | ⚠️ 持久化 | ✅ 程序退出即清除 |
| 泄露风险 | ⚠️ 中等 | ✅ 极低 |
| 用户控制 | ⚠️ 提前设置 | ✅ 需要时输入 |

#### 技术实现

1. **Python getpass模块**: 输入时屏幕不显示任何字符
2. **延迟加载**: 只在需要AI功能时才请求密钥
3. **内存存储**: 密钥仅存在Python进程内存中
4. **自动清除**: 程序退出时自动释放
5. **可取消**: 用户可按 Ctrl+C 取消输入

#### 代码示例

```python
import getpass

# 安全地获取密钥
api_key = getpass.getpass("请输入 API 密钥（输入时不显示）: ")

# 密钥仅保存在内存中
self.api_key = api_key  # 不写入文件！

# 程序退出后，内存自动释放
```

---

## 📦 更新内容汇总

### 文件修改
- ✅ **query_engine.py** (v1.1.0 → v1.2.0) - 支持临时输入API密钥
- ✅ **file_scanner.py** - 统一命名 `file-scanner` → `file_scanner`
- ✅ **metadata_parser.py** - 统一命名 `metadata-parser` → `metadata_parser`
- ✅ **storage_tree.py** - 统一命名 `storage-tree` → `storage_tree`
- ✅ **test_api.py** - 统一命名 `test-api` → `test_api`
- ✅ **ai_providers/deepseek.py** (v1.0.0 → v1.1.0) - 支持传入API密钥
- ✅ **ai_providers/gemini.py** (v1.0.0 → v1.1.0) - 支持传入API密钥
- ✅ **ai_providers/claude.py** (v1.0.0 → v1.1.0) - 支持传入API密钥
- ✅ **cmdtree_fixed** (v1.1.1 → v1.1.2) - 更新帮助信息

### 新增文档
- ✅ **UPDATE_v1.2.0.md** - 详细更新说明
- ✅ **CHANGELOG.md** - 更新版本日志

---

## 🚀 使用指南

### 基本使用（不需要AI功能）
```bash
# 扫描目录
./cmdtree scan ~/bin

# 搜索命令（本地搜索，不需要密钥）
./cmdtree search file

# 查看统计
./cmdtree stats
```

### AI功能使用（会提示输入密钥）
```bash
# 使用默认提供商（DeepSeek）
./cmdtree explain ls
# → 会提示输入 DEEPSEEK_API_KEY

# 使用Gemini
./cmdtree explain -p gemini ls
# → 会提示输入 GOOGLE_API_KEY

# 使用Claude
./cmdtree explain -p claude ls
# → 会提示输入 ANTHROPIC_API_KEY
```

### 仍可使用环境变量（兼容旧方式）
```bash
# 设置环境变量（在当前会话有效）
export DEEPSEEK_API_KEY="sk-xxx"

# 使用时不会再提示输入
./cmdtree explain ls
```

---

## 🎯 版本对比

| 特性 | v1.1.1 | v1.2.0 |
|------|--------|--------|
| 命名规范 | ❌ 不统一 | ✅ 统一下划线 |
| API密钥安全 | ⚠️ 环境变量 | ✅ 临时输入 |
| 密钥可见性 | ⚠️ 可见 | ✅ 隐藏输入 |
| 隐私保护 | ⚠️ 一般 | ✅ 强 |
| 美观性 | ⚠️ 一般 | ✅ 统一美观 |
| 易用性 | ✅ 好 | ✅ 更好 |
| 兼容性 | ✅ 好 | ✅ 完全兼容 |

---

## 📥 下载文件

所有文件已更新并准备好下载：

1. **dict-tree-fixed.tar.gz** - 完整压缩包（Linux/macOS）
2. **dict-tree-fixed.zip** - 完整压缩包（Windows）
3. **dict-tree-fixed/** - 完整目录
4. **cmdtree_fixed** - 单独的主脚本
5. **query_engine.py** - 单独的查询引擎
6. **file_scanner.py** - 单独的文件扫描器

---

## ✅ 测试清单

运行以下命令验证更新：

```bash
# 1. 验证命名统一
./cmdtree scan .
# → 应该看到 file_scanner, query_engine 等（不是 file-scanner）

# 2. 验证API密钥输入（可选）
./cmdtree explain ls
# → 应该提示 "请输入 DEEPSEEK API 密钥（输入时不显示）"
# → 输入时屏幕不显示字符
# → 输入错误密钥会提示错误
# → 按 Ctrl+C 可以取消

# 3. 验证环境变量仍然有效（可选）
export DEEPSEEK_API_KEY="your_key"
./cmdtree explain ls
# → 不应该再提示输入密钥
```

---

## 🎊 总结

### 您的两个建议都已完美实现：

1. ✅ **命名统一** - 所有名称使用下划线，美观一致
2. ✅ **隐私保护** - API密钥临时输入，不保存文件

### 额外改进：

- ✅ 延迟加载AI提供商（性能优化）
- ✅ 更好的用户提示
- ✅ 向后兼容（环境变量方式仍然支持）
- ✅ 安全性大幅提升

感谢您的宝贵建议！dict-tree 现在更加专业、美观和安全了！🎉

---

**版本**: v1.2.0  
**发布日期**: 2026-02-17  
**状态**: ✅ 已完成并测试通过  
**向后兼容**: ✅ 完全兼容 v1.1.x
