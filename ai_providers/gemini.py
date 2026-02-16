#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: gemini
# description: Google Gemini API 的 AI 提供商实现
# usage: 由 query_engine 动态加载，用于命令解释和文本生成
# version: 1.0.0
# author: TurinFohlen
# dependencies: google-generativeai, ai_provider_base
# tags: AI, gemini, 提供商
# === END METADATA ===

import os
import sys
from .base import AIProvider

try:
    import google.generativeai as genai
except ImportError:
    genai = None

class GeminiProvider(AIProvider):
    def __init__(self):
        if genai is None:
            raise ImportError("请先安装 google-generativeai: pip install google-generativeai")
        genai.configure(api_key=os.getenv('GEMINI_API_KEY'))
        self.model = genai.GenerativeModel('gemini-pro')

    def generate(self, prompt: str, **kwargs) -> str:
        response = self.model.generate_content(prompt)
        return response.text

    def explain_command(self, cmd_name: str, cmd_info: dict) -> str:
        prompt = f"请详细解释命令 {cmd_name} 的用法和最佳实践。\n命令信息：{cmd_info}"
        return self.generate(prompt)
