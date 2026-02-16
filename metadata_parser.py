#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: metadata-parser
# description: 解析脚本文件中的元数据注释块
# version: 1.0.0
# author: TurinFohlen
# dependencies: re
# tags: 元数据, 解析
# === END METADATA ===

import re
from typing import Dict, Optional
from pathlib import Path

class MetadataParser:
    """解析符合统一元数据规范的脚本文件"""
    
    # 支持的注释符号映射
    COMMENT_SYMBOLS = {
        '.sh': '#',
        '.bash': '#',
        '.py': '#',
        '.rb': '#',
        '.js': '//',
        '.ts': '//',
        '.pl': '#',
        '.lua': '--',
    }
    
    def __init__(self):
        self.metadata_fields = [
            'name', 'description', 'usage', 'version', 
            'author', 'dependencies', 'tags'
        ]
    
    def parse_file(self, filepath: Path) -> Optional[Dict[str, str]]:
        """
        解析单个脚本文件的元数据
        
        Args:
            filepath: 脚本文件路径
            
        Returns:
            包含元数据的字典，如果解析失败返回None
        """
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 获取文件扩展名对应的注释符号
            ext = filepath.suffix.lower()
            comment_sym = self.COMMENT_SYMBOLS.get(ext, '#')
            
            # 构建元数据块的正则模式
            begin_marker = f"{comment_sym} === BEGIN METADATA ==="
            end_marker = f"{comment_sym} === END METADATA ==="
            
            # 提取元数据块
            pattern = f"{re.escape(begin_marker)}(.*?){re.escape(end_marker)}"
            match = re.search(pattern, content, re.DOTALL)
            
            if not match:
                return None
            
            metadata_block = match.group(1)
            metadata = {'filepath': str(filepath)}
            
            # 解析每个字段
            for field in self.metadata_fields:
                field_pattern = f"{comment_sym} {field}:\\s*(.+?)(?:\n|$)"
                field_match = re.search(field_pattern, metadata_block)
                if field_match:
                    metadata[field] = field_match.group(1).strip()
            
            # 处理依赖和标签（转为列表）
            if 'dependencies' in metadata:
                metadata['dependencies'] = [
                    dep.strip() for dep in metadata['dependencies'].split(',')
                ]
            if 'tags' in metadata:
                metadata['tags'] = [
                    tag.strip() for tag in metadata['tags'].split(',')
                ]
            
            return metadata
            
        except Exception as e:
            print(f"解析文件 {filepath} 时出错: {e}")
            return None
    
    def validate_metadata(self, metadata: Dict) -> bool:
        """验证元数据是否包含必需字段"""
        required_fields = ['name', 'description']
        return all(field in metadata for field in required_fields)