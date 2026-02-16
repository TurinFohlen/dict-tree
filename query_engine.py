#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: query_engine
# description: 智能命令查询引擎，支持多AI提供商动态加载
# usage: query_engine <query>
# version: 1.2.0
# author: TurinFohlen
# dependencies: storage_tree, importlib, ai_providers.base
# tags: 查询, AI, 引擎
# === END METADATA ===

import os
import importlib
import getpass
from typing import List, Dict, Optional
from storage_tree import StorageTree

class QueryEngine:
    def __init__(self, storage: StorageTree = None, api_key: str = None):
        """
        初始化查询引擎
        
        Args:
            storage: 存储树实例
            api_key: API密钥（可选，如不提供则在需要时提示输入）
        """
        self.storage = storage or StorageTree()
        self.storage.load_from_disk()
        self.api_key = api_key  # 临时存储在内存中
        self.ai_provider = None  # 延迟加载
        
    def _ensure_ai_provider(self):
        """确保AI提供商已加载（需要时才加载）"""
        if self.ai_provider is not None:
            return True
            
        provider_name = os.getenv('AI_PROVIDER', 'deepseek').lower()
        
        # 类名映射
        class_name_map = {
            'deepseek': 'DeepSeekProvider',
            'gemini': 'GeminiProvider',
            'claude': 'ClaudeProvider',
        }
        
        if provider_name not in class_name_map:
            print(f"⚠️ 未知的 AI 提供商: {provider_name}")
            return False
        
        # 如果没有API密钥，提示用户输入
        if not self.api_key:
            print(f"\n🔐 使用 {provider_name.upper()} AI 功能需要 API 密钥")
            print("提示：输入的密钥仅保存在内存中，不会写入任何文件")
            try:
                self.api_key = getpass.getpass(f"请输入 {provider_name.upper()} API 密钥（输入时不显示）: ")
                if not self.api_key or not self.api_key.strip():
                    print("❌ 未输入 API 密钥，AI 功能将被禁用")
                    return False
            except KeyboardInterrupt:
                print("\n❌ 已取消，AI 功能将被禁用")
                return False
        
        module_name = f"ai_providers.{provider_name}"
        class_name = class_name_map[provider_name]
        
        try:
            module = importlib.import_module(module_name)
            provider_class = getattr(module, class_name)
            # 传入API密钥到提供商
            self.ai_provider = provider_class(api_key=self.api_key)
            print(f"✅ 已加载 AI 提供商: {provider_name}")
            return True
        except Exception as e:
            print(f"⚠️ 无法加载 AI 提供商 {provider_name}：{e}")
            return False

    def query(self, query_text: str, use_ai: bool = True) -> List[Dict]:
        """执行查询"""
        results = []

        # 1. 精确前缀匹配
        prefix_results = self.storage.search_by_prefix(query_text)
        if prefix_results:
            results.extend(self._mark_results(prefix_results, 'exact_match'))

        # 2. 标签匹配
        tag_results = self.storage.search_by_tag(query_text)
        results.extend(self._mark_results(tag_results, 'tag_match'))

        # 3. 关键词匹配
        keyword_results = self.storage.search_by_keyword(query_text)
        results.extend(self._mark_results(keyword_results, 'keyword_match'))

        # 4. AI语义搜索（如果启用且没有结果）
        if use_ai and not results:
            if self._ensure_ai_provider():
                ai_results = self._ai_semantic_search(query_text)
                results.extend(ai_results)

        return self._deduplicate_and_rank(results)

    def _mark_results(self, results: List[Dict], match_type: str) -> List[Dict]:
        marked = []
        for r in results:
            if r:
                r_copy = r.copy()
                r_copy['match_type'] = match_type
                marked.append(r_copy)
        return marked

    def _ai_semantic_search(self, query: str) -> List[Dict]:
        if not self.ai_provider:
            return []
        try:
            commands_summary = self._build_commands_summary()
            prompt = f"""你是一个命令行工具专家。用户想要找一个命令来完成某个任务。

用户的需求：{query}

可用的命令列表：
{commands_summary}

请分析用户的需求，从命令列表中选出最相关的3个命令（按相关度排序），并简要说明推荐理由。
用JSON格式返回，格式如下：
{{"recommendations": [
  {{"command": "命令名", "reason": "推荐理由"}},
  ...
]}}"""
            response = self.ai_provider.generate(prompt, max_tokens=500)
            import json
            recs = json.loads(response)['recommendations']
            results = []
            for rec in recs:
                cmd = self.storage.get_command(rec['command'])
                if cmd:
                    cmd = cmd.copy()
                    cmd['match_type'] = 'ai_recommendation'
                    cmd['ai_reason'] = rec['reason']
                    results.append(cmd)
            return results
        except Exception as e:
            print(f"⚠️ AI 语义搜索失败: {e}")
            return []

    def _build_commands_summary(self) -> str:
        summary_lines = []
        for cmd in self.storage.all_commands[:50]:
            name = cmd.get('name', '')
            desc = cmd.get('description', '')
            tags = ', '.join(cmd.get('tags', []))
            summary_lines.append(f"- {name}: {desc} [{tags}]")
        return '\n'.join(summary_lines)

    def _deduplicate_and_rank(self, results: List[Dict]) -> List[Dict]:
        priority = {
            'exact_match': 0,
            'tag_match': 1,
            'keyword_match': 2,
            'ai_recommendation': 3
        }
        seen = {}
        for r in results:
            name = r['name']
            if name not in seen or priority[r['match_type']] < priority[seen[name]['match_type']]:
                seen[name] = r
        unique = list(seen.values())
        unique.sort(key=lambda x: priority[x['match_type']])
        return unique

    def explain_command(self, command_name: str) -> Optional[str]:
        """解释命令（需要时才加载AI提供商）"""
        cmd = self.storage.get_command(command_name)
        if not cmd:
            return None
        
        if not self._ensure_ai_provider():
            return "AI 服务未配置或用户取消输入"
        
        try:
            return self.ai_provider.explain_command(command_name, cmd)
        except Exception as e:
            return f"AI 解释失败：{e}"

    def get_command(self, name: str) -> Optional[Dict]:
        return self.storage.get_command(name)
