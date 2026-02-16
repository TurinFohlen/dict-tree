#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: test_api
# description: 测试DeepSeek API是否可用的最小脚本
# usage: test-api
# version: 1.0.0
# author: TurinFohlen
# dependencies: requests
# tags: 测试, API, deepseek
# === END METADATA ===

import os
import requests
import sys

def test_api():
    api_key = os.getenv('DEEPSEEK_API_KEY')
    if not api_key:
        print("❌ 环境变量 DEEPSEEK_API_KEY 未设置")
        sys.exit(1)

    print(f"🔑 使用的API密钥: {api_key[:4]}...{api_key[-4:]}")

    url = "https://api.deepseek.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "deepseek-chat",
        "messages": [{"role": "user", "content": "Hello, are you working?"}],
        "temperature": 0.7,
        "max_tokens": 100
    }

    try:
        print("📡 发送请求...")
        response = requests.post(url, headers=headers, json=payload, timeout=10)
        print(f"📥 状态码: {response.status_code}")

        if response.status_code == 200:
            result = response.json()
            reply = result['choices'][0]['message']['content']
            print(f"✅ 成功！API回复: {reply}")
        else:
            print(f"❌ 请求失败，响应内容: {response.text}")
    except Exception as e:
        print(f"❌ 发生异常: {e}")

if __name__ == "__main__":
    test_api()

