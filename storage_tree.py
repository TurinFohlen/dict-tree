#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: storage_tree
# description: 基于Trie树结构的命令元数据存储系统
# version: 1.0.0
# author: TurinFohlen
# dependencies: json
# tags: 存储, 字典树, 索引
# === END METADATA ===

import json
from pathlib import Path
from typing import List, Dict, Optional
from collections import defaultdict

class TrieNode:
    """Trie树节点"""
    def __init__(self):
        self.children = {}
        self.is_end = False
        self.command_data = None

class StorageTree:
    """
    命令元数据存储树
    使用Trie树实现命令名称的快速前缀匹配
    同时维护标签和描述的倒排索引
    """
    
    def __init__(self, storage_file: str = "~/.command_index.json"):
        self.root = TrieNode()
        self.storage_file = Path(storage_file).expanduser()
        self.tag_index = defaultdict(list)  # 标签倒排索引
        self.description_index = defaultdict(list)  # 描述词倒排索引
        self.all_commands = []  # 所有命令的列表
    
    def insert_command(self, metadata: Dict):
        """
        插入命令到Trie树
        由文件扫描器（节点1）写入数据
        
        Args:
            metadata: 命令元数据字典
        """
        command_name = metadata.get('name', '')
        if not command_name:
            return
        
        # 插入到Trie树
        node = self.root
        for char in command_name:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        
        node.is_end = True
        node.command_data = metadata
        
        # 构建标签索引
        if 'tags' in metadata:
            for tag in metadata['tags']:
                self.tag_index[tag.lower()].append(command_name)
        
        # 构建描述词索引（简单分词）
        if 'description' in metadata:
            words = metadata['description'].lower().split()
            for word in words:
                self.description_index[word].append(command_name)
        
        # 添加到全量列表
        self.all_commands.append(metadata)
    
    def search_by_prefix(self, prefix: str) -> List[Dict]:
        """根据前缀搜索命令"""
        node = self.root
        for char in prefix:
            if char not in node.children:
                return []
            node = node.children[char]
        
        # 收集所有匹配的命令
        results = []
        self._collect_commands(node, results)
        return results
    
    def _collect_commands(self, node: TrieNode, results: List):
        """递归收集节点下的所有命令"""
        if node.is_end:
            results.append(node.command_data)
        
        for child in node.children.values():
            self._collect_commands(child, results)
    
    def search_by_tag(self, tag: str) -> List[Dict]:
        """根据标签搜索命令"""
        command_names = self.tag_index.get(tag.lower(), [])
        return [self.get_command(name) for name in command_names]
    
    def search_by_keyword(self, keyword: str) -> List[Dict]:
        """根据关键词在描述中搜索"""
        command_names = self.description_index.get(keyword.lower(), [])
        return [self.get_command(name) for name in command_names]
    
    def get_command(self, name: str) -> Optional[Dict]:
        """获取特定命令的完整信息"""
        node = self.root
        for char in name:
            if char not in node.children:
                return None
            node = node.children[char]
        
        return node.command_data if node.is_end else None
    
    def save_to_disk(self):
        """持久化存储到磁盘"""
        data = {
            'commands': self.all_commands,
            'tag_index': dict(self.tag_index),
            'description_index': dict(self.description_index)
        }
        
        with open(self.storage_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"💾 已保存 {len(self.all_commands)} 条命令到 {self.storage_file}")
    
    def load_from_disk(self):
        """从磁盘加载数据"""
        if not self.storage_file.exists():
            print("⚠️  索引文件不存在，将创建新索引")
            return
        
        with open(self.storage_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # 重建Trie树
        for cmd in data['commands']:
            self.insert_command(cmd)
        
        print(f"📂 已加载 {len(self.all_commands)} 条命令")
    
    def get_statistics(self) -> Dict:
        """获取存储统计信息"""
        return {
            'total_commands': len(self.all_commands),
            'total_tags': len(self.tag_index),
            'storage_file': str(self.storage_file)
        }
