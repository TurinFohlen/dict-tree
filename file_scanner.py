#!/usr/bin/env python3
# === BEGIN METADATA ===
# name: file-scanner
# description: 扫描指定目录下的所有脚本文件并提取元数据
# usage: file-scanner <directory>
# version: 1.0.0
# author: TurinFohlen
# dependencies: metadata-parser
# tags: 文件扫描, 索引
# === END METADATA ===

import os
from pathlib import Path
from typing import List, Dict
from metadata_parser import MetadataParser  # 使用节点2的元数据解析器

class FileScanner:
    """扫描文件系统中的可执行脚本并提取元数据"""
    
    # 支持的脚本扩展名
    SCRIPT_EXTENSIONS = {'.sh', '.bash', '.py', '.rb', '.js', '.ts', '.pl', '.lua'}
    
    def __init__(self, parser: MetadataParser = None):
        """
        初始化文件扫描器
        
        Args:
            parser: 元数据解析器实例（使用节点2提供的解析能力）
        """
        self.parser = parser or MetadataParser()
        self.scanned_files = []
        self.valid_commands = []
    
    def scan_directory(self, directory: str, recursive: bool = True) -> List[Dict]:
        """
        扫描目录下的所有脚本文件
        
        Args:
            directory: 要扫描的目录路径
            recursive: 是否递归扫描子目录
            
        Returns:
            包含有效元数据的命令列表
        """
        dir_path = Path(directory).expanduser()
        
        if not dir_path.exists():
            raise FileNotFoundError(f"目录不存在: {directory}")
        
        print(f"🔍 开始扫描目录: {dir_path}")
        
        # 遍历目录
        if recursive:
            files = dir_path.rglob('*')
        else:
            files = dir_path.glob('*')
        
        for file_path in files:
            if self._is_script_file(file_path):
                self._process_file(file_path)
        
        print(f"✅ 扫描完成！发现 {len(self.scanned_files)} 个脚本文件")
        print(f"📦 提取到 {len(self.valid_commands)} 个有效命令")
        
        return self.valid_commands
    
    def _is_script_file(self, filepath: Path) -> bool:
        """检查文件是否为可执行脚本"""
        if not filepath.is_file():
            return False
        
        # 检查扩展名
        if filepath.suffix.lower() in self.SCRIPT_EXTENSIONS:
            return True
        
        # 检查是否有执行权限且无扩展名（Unix风格命令）
        if not filepath.suffix and os.access(filepath, os.X_OK):
            return True
        
        return False
    
    def _process_file(self, filepath: Path):
        """处理单个脚本文件"""
        self.scanned_files.append(filepath)
        
        # 使用元数据解析器（节点2）解析文件
        metadata = self.parser.parse_file(filepath)
        
        if metadata and self.parser.validate_metadata(metadata):
            self.valid_commands.append(metadata)
            print(f"  ✓ {metadata['name']}: {metadata['description']}")
        else:
            print(f"  ⚠ {filepath.name}: 无有效元数据")
    
    def get_statistics(self) -> Dict:
        """获取扫描统计信息"""
        return {
            'total_files': len(self.scanned_files),
            'valid_commands': len(self.valid_commands),
            'coverage_rate': f"{len(self.valid_commands)/len(self.scanned_files)*100:.1f}%" 
                if self.scanned_files else "0%"
        }
