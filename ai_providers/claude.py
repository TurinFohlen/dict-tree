#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: claude
# description: Anthropic Claude API 的 AI 提供商实现
# usage: 由 query_engine 动态加载，用于命令解释和文本生成
# version: 1.0.0
# author: TurinFohlen
# dependencies: anthropic, ai_provider_base
# tags: AI, claude, 提供商
# === END METADATA ===

import os
import sys
from .base import AIProvider

try:
    import anthropic
except ImportError:
    anthropic = None

class ClaudeProvider(AIProvider):
    def __init__(self):
        if anthropic is None:
            raise ImportError("请先安装 anthropic: pip install anthropic")
        self.api_key = os.getenv('ANTHROPIC_API_KEY')
        if not self.api_key:
            raise ValueError("ANTHROPIC_API_KEY 环境变量未设置")
        self.client = anthropic.Anthropic(api_key=self.api_key)
        self.model = os.getenv('CLAUDE_MODEL', 'claude-3-haiku-20240307')  # 可配置

    def generate(self, prompt: str, **kwargs) -> str:
        response = self.client.messages.create(
            model=self.model,
            max_tokens=kwargs.get('max_tokens', 500),
            temperature=kwargs.get('temperature', 0.7),
            messages=[{"role": "user", "content": prompt}]
        )
        return response.content[0].text

    def explain_command(self, cmd_name: str, cmd_info: dict) -> str:
        prompt = f"请详细解释命令 {cmd_name} 的用法和最佳实践。\n命令信息：{cmd_info}"
        return self.generate(prompt)
