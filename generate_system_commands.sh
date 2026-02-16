#!/data/data/com.termux/files/usr/bin/bash
# === BEGIN METADATA ===
# name: generate_system_commands
# description: 为常用系统命令生成元数据文件，方便 cmdtree 收录
# usage: ./generate_system_commands.sh
# version: 1.0.0
# author: TurinFohlen
# tags: 工具, 元数据生成
# === END METADATA ===

# 目标目录
TARGET_DIR="$HOME/system_commands"

# 创建目录
mkdir -p "$TARGET_DIR"
echo "📁 目标目录: $TARGET_DIR"

# 定义命令列表（格式：name|description|usage|tag1,tag2,...）
commands=(
    # ===== 基本文件/目录操作 =====
    "ls|列出目录内容|ls [选项] [文件...]|文件管理,目录"
    "cd|切换当前工作目录|cd [目录]|导航,目录"
    "pwd|显示当前工作目录的绝对路径|pwd|导航,目录"
    "cp|复制文件或目录|cp [选项] 源 目标|文件管理,复制"
    "mv|移动或重命名文件/目录|mv [选项] 源 目标|文件管理,移动"
    "rm|删除文件或目录|rm [选项] 文件...|文件管理,删除"
    "mkdir|创建目录|mkdir [选项] 目录...|文件管理,创建目录"
    "rmdir|删除空目录|rmdir [选项] 目录...|文件管理,删除目录"
    "touch|创建空文件或更新时间戳|touch [选项] 文件...|文件管理,时间戳"
    "ln|创建硬链接或符号链接|ln [选项] 目标 [链接名]|文件管理,链接"
    "tree|以树状结构列出目录内容|tree [选项] [目录]|文件管理,目录"

    # ===== 查看/文本处理 =====
    "cat|连接文件并打印到标准输出|cat [选项] [文件...]|文本处理,查看"
    "tac|反向显示文件内容|tac [文件...]|文本处理,查看"
    "less|分页查看文件内容|less [选项] 文件...|文本处理,分页查看"
    "more|分页显示文本|more [选项] 文件...|文本处理,分页查看"
    "head|显示文件开头若干行|head [选项] [文件...]|文本处理,查看"
    "tail|显示文件结尾若干行|tail [选项] [文件...]|文本处理,查看"
    "nl|给文件内容加行号|nl [选项] [文件...]|文本处理,查看"
    "wc|统计行数、单词数和字节数|wc [选项] [文件...]|文本处理,统计"
    "grep|在文件中搜索匹配指定模式的行|grep [选项] 模式 [文件...]|文本处理,搜索"
    "egrep|使用扩展正则进行搜索|egrep [选项] 模式 [文件...]|文本处理,搜索"
    "fgrep|按字面量字符串搜索|fgrep [选项] 字符串 [文件...]|文本处理,搜索"
    "sed|流编辑器，按行处理文本|sed [选项] '脚本' [文件...]|文本处理,编辑"
    "awk|基于模式匹配的文本处理工具|awk '程序' [文件...]|文本处理,分析"
    "cut|剪切每行中指定的字段|cut [选项] [文件...]|文本处理,字段"
    "tr|替换或删除字符|tr [选项] 集合1 [集合2]|文本处理,替换"
    "sort|对文本行排序|sort [选项] [文件...]|文本处理,排序"
    "uniq|报告或省略重复行|uniq [选项] [输入 [输出]]|文本处理,去重"
    "xargs|从标准输入构造并执行命令行|xargs [选项] [命令]|文本处理,管道"

    # ===== 文件信息 =====
    "stat|显示文件或文件系统状态|stat [选项] 文件...|文件管理,信息"
    "file|根据魔数判断文件类型|file [选项] 文件...|文件管理,信息"
    "du|估计文件空间使用情况|du [选项] [文件...]|磁盘,监控"
    "df|报告文件系统磁盘空间使用情况|df [选项] [文件...]|磁盘,监控"
    "find|在目录树中搜索文件|find [路径...] [表达式]|文件搜索,查找"
    "locate|按数据库快速查找文件|locate [模式...]|文件搜索,查找"
    "updatedb|更新 locate 使用的文件数据库|updatedb [选项]|文件搜索,维护"

    # ===== 比较/补丁 =====
    "diff|逐行比较文件差异|diff [选项] 文件1 文件2|文本处理,比较"
    "patch|将补丁应用到文件|patch [选项] [文件]|文本处理,补丁"

    # ===== 压缩/归档 =====
    "tar|归档实用程序|tar [选项] [文件...]|压缩,归档"
    "gzip|压缩或解压文件|gzip [选项] [文件...]|压缩"
    "gunzip|解压 gzip 文件|gunzip [选项] 文件...|压缩,解压"
    "zip|打包并压缩文件|zip [选项] 压缩包 文件...|压缩,归档"
    "unzip|解压 zip 压缩包|unzip [选项] 压缩包|压缩,解压"
    "bzip2|使用 bzip2 算法压缩文件|bzip2 [选项] 文件...|压缩"
    "bunzip2|解压 bzip2 文件|bunzip2 [选项] 文件...|压缩,解压"
    "xz|使用 xz 算法压缩文件|xz [选项] 文件...|压缩"
    "unxz|解压 xz 文件|unxz [选项] 文件...|压缩,解压"
    "7z|7-Zip 压缩/解压工具|7z [选项] 命令 [参数...]|压缩,归档"

    # ===== 进程与作业控制 =====
    "ps|报告当前进程快照|ps [选项]|进程管理"
    "top|动态显示进程活动|top [选项]|进程管理,监控"
    "htop|交互式进程查看器|htop [选项]|进程管理,监控"
    "kill|向进程发送信号|kill [选项] PID...|进程管理"
    "pkill|按名称向进程发送信号|pkill [选项] 模式|进程管理"
    "pgrep|按名称查找进程 ID|pgrep [选项] 模式|进程管理"
    "nice|设置命令的优先级|nice [选项] 命令 [参数...]|进程管理,优先级"
    "renice|改变正在运行进程的优先级|renice 优先级 PID...|进程管理,优先级"
    "jobs|列出当前 shell 的后台作业|jobs [选项]|进程管理,作业控制"
    "fg|将作业调到前台|fg [%作业号]|进程管理,作业控制"
    "bg|将作业放到后台运行|bg [%作业号]|进程管理,作业控制"

    # ===== 系统信息 =====
    "uname|显示系统信息|uname [选项]|系统,信息"
    "hostname|显示或设置主机名|hostname [选项] [名称]|系统,信息"
    "whoami|显示当前用户名称|whoami|系统,用户"
    "id|显示用户和组身份信息|id [选项] [用户]|系统,用户"
    "uptime|显示系统运行时间和负载|uptime|系统,监控"
    "free|显示内存使用情况|free [选项]|系统,监控"
    "env|显示当前环境变量|env|系统,环境变量"
    "printenv|打印指定环境变量|printenv [变量...]|系统,环境变量"
    "termux-info|显示 Termux 环境信息|termux-info|termux,信息"

    # ===== 时间与日期 =====
    "date|显示或设置系统日期和时间|date [选项] [+格式]|时间,基本"
    "sleep|暂停指定时间|sleep 时间|时间,等待"
    "time|计时命令执行耗时|time 命令 [参数...]|时间,性能"

    # ===== 网络与远程访问 =====
    "ping|测试网络连通性|ping [选项] 目标|网络,诊断"
    "traceroute|跟踪数据包路由|traceroute [选项] 目标|网络,诊断"
    "ip|显示和配置网络接口|ip [选项] 对象 命令|网络,配置"
    "ssh|OpenSSH 远程登录客户端|ssh [选项] [用户@]主机 [命令]|网络,远程"
    "scp|通过 SSH 复制文件|scp [选项] 源 目标|网络,远程,文件传输"
    "sftp|基于 SSH 的文件传输|sftp [选项] [用户@]主机|网络,远程,文件传输"
    "wget|非交互式网络下载器|wget [选项] URL...|网络,下载"
    "curl|传输数据的命令行工具|curl [选项] URL|网络,传输"
    "nc|Netcat，多功能网络工具|nc [选项] 主机 端口|网络,调试"
    "nmap|网络端口与服务扫描器|nmap [选项] 目标|网络,安全"

    # ===== 包管理（Termux） =====
    "pkg|Termux 高级包管理前端|pkg [命令] [包...]|termux,包管理"
    "apt|APT 包管理工具|apt [命令] [包...]|termux,包管理"
    "apt-get|APT 低级包管理工具|apt-get [命令] [包...]|termux,包管理"
    "apt-cache|查询 APT 软件包缓存|apt-cache [命令] [参数...]|termux,包管理"
    "dpkg|Debian 软件包管理器|dpkg [选项] 包...|termux,包管理"

    # ===== Termux 特有命令（系统集成） =====
    "termux-setup-storage|请求访问外部存储并创建绑定目录|termux-setup-storage|termux,存储"
    "termux-change-repo|图形化更换 Termux 源|termux-change-repo|termux,镜像源"
    "termux-open|使用系统应用打开文件|termux-open [选项] 文件|termux,集成"
    "termux-open-url|使用系统浏览器打开 URL|termux-open-url URL|termux,集成"
    "termux-reload-settings|重新加载 Termux 设置|termux-reload-settings|termux,设置"
    "termux-wake-lock|保持 CPU 唤醒|termux-wake-lock|termux,电源"
    "termux-wake-unlock|释放唤醒锁|termux-wake-unlock|termux,电源"
    "termux-notification|发送系统通知|termux-notification [选项]|termux,通知"
    "termux-notification-remove|移除指定通知|termux-notification-remove [选项]|termux,通知"
    "termux-toast|显示短暂 Toast 消息|termux-toast [选项] 文本|termux,提示"
    "termux-vibrate|使设备震动|termux-vibrate [选项]|termux,硬件"
    "termux-battery-status|显示电池状态信息|termux-battery-status|termux,硬件"
    "termux-location|获取位置信息|termux-location [选项]|termux,硬件"
    "termux-sensor|读取传感器数据|termux-sensor [选项]|termux,硬件"
    "termux-camera-photo|调用相机拍照并保存|termux-camera-photo [选项] 文件|termux,硬件"
    "termux-microphone-record|录制音频到文件|termux-microphone-record [选项]|termux,硬件"
    "termux-clipboard-get|读取系统剪贴板内容|termux-clipboard-get|termux,剪贴板"
    "termux-clipboard-set|设置系统剪贴板内容|termux-clipboard-set [文本]|termux,剪贴板"
    "termux-download|通过系统下载管理器下载文件|termux-download [选项] URL|termux,下载"
    "termux-media-player|播放音频或视频文件|termux-media-player 命令 [参数...]|termux,多媒体"
    "termux-media-scan|通知系统媒体库扫描文件|termux-media-scan [文件...]|termux,多媒体"
    "termux-share|通过系统分享面板分享内容|termux-share [选项] [文件]|termux,分享"
    "termux-usb|与 USB 设备交互|termux-usb [选项] 设备|termux,硬件"
    "termux-volume|控制音量通道|termux-volume 通道 值|termux,音量"
    "termux-wifi-connectioninfo|显示当前 Wi-Fi 连接信息|termux-wifi-connectioninfo|termux,网络"
    "termux-wifi-enable|启用或禁用 Wi-Fi|termux-wifi-enable true|termux,网络"
    "termux-wifi-scaninfo|显示 Wi-Fi 扫描结果|termux-wifi-scaninfo|termux,网络"
    "termux-sms-send|发送短信|termux-sms-send [选项] 电话号 文本|termux,短信"
    "termux-sms-list|列出短信|termux-sms-list [选项]|termux,短信"
    "termux-sms-inbox|列出收件箱短信|termux-sms-inbox [选项]|termux,短信"
    "termux-telephony-call|发起电话呼叫|termux-telephony-call 电话号|termux,电话"
    "termux-telephony-cellinfo|查看基站信息|termux-telephony-cellinfo|termux,电话"
    "termux-telephony-deviceinfo|查看设备电话信息|termux-telephony-deviceinfo|termux,电话"
    "termux-tts-engines|列出 TTS 引擎|termux-tts-engines|termux,语音"
    "termux-tts-speak|使用 TTS 朗读文本|termux-tts-speak [选项] 文本|termux,语音"
    "termux-job-scheduler|管理 Termux 后台任务|termux-job-scheduler [选项]|termux,任务"
    "termux-broadcast|发送 Android 广播|termux-broadcast [选项]|termux,系统"
    "termux-dialog|显示交互式对话框|termux-dialog [选项]|termux,界面"

    # ===== Shell 与环境 =====
    "echo|显示一行文本|echo [选项] [字符串...]|基本"
    "printf|格式化输出文本|printf 格式 [参数...]|基本,格式化"
    "alias|定义或显示别名|alias [名称[=值]...]|shell"
    "unalias|取消别名|unalias 名称...|shell"
    "export|设置环境变量|export [名称[=值]...]|shell,环境变量"
    "set|设置或显示 Shell 选项和位置参数|set [选项] [参数...]|shell"
    "unset|删除变量或函数|unset 名称...|shell"
    "history|显示命令历史|history [选项]|shell,历史"
    "source|在当前 shell 中执行脚本|source 文件|shell"
    ".|在当前 shell 中执行脚本|. 文件|shell"
    "type|显示命令类型|type 名称...|shell,调试"
    "which|显示命令的完整路径|which 命令...|shell,路径"
    "hash|管理可执行文件路径哈希表|hash [选项] [命令]|shell,性能"
    "clear|清屏|clear|shell,界面"
    "reset|重置终端|reset|shell,界面"
    "read|从标准输入读取一行|read [选项] 变量...|shell,输入"

    # ===== 权限与所有权 =====
    "chmod|修改文件权限|chmod [选项] 模式 文件...|权限管理"
    "chown|修改文件所有者和组|chown [选项] 所有者[:组] 文件...|权限管理"
    "chgrp|修改文件所属组|chgrp [选项] 组 文件...|权限管理"

    # ===== 额外常用命令（补充）=====
    "cal|显示日历|cal [选项] [月份] [年份]|基本,时间"
    "bc|任意精度计算器|bc [选项] [文件...]|基本,计算"
    "expr|计算表达式|expr 表达式|基本,计算"
    "test|条件测试|test 表达式|shell,条件"
    "[|条件测试（test 别名）|[ 表达式 ]|shell,条件"
    "nohup|在后台运行命令，忽略挂断信号|nohup 命令 [参数...]|进程管理"
    "crontab|管理定时任务|crontab [选项] [文件]|计划任务"
    "logger|向系统日志写入消息|logger [选项] [消息]|日志"
    "watch|周期执行命令|watch [选项] 命令|监控"
    "script|记录终端会话到文件|script [选项] [文件]|终端"
    "nano|简单易用的文本编辑器|nano [选项] [文件...]|编辑器"
    "vim|Vi 增强版文本编辑器|vim [选项] [文件...]|编辑器"
    "python3|Python 3 解释器|python3 [选项] [脚本]|编程,解释器"
    "git|分布式版本控制系统|git [选项] 命令 [参数...]|版本控制"
    "make|自动化构建工具|make [选项] [目标]|构建"
    "gcc|GNU C 编译器|gcc [选项] 文件...|编程,编译"
)

# 遍历并生成文件
for cmd in "${commands[@]}"; do
    IFS='|' read -r name desc usage tags <<< "$cmd"
    filename="$TARGET_DIR/${name}.meta"
    cat > "$filename" << EOF
#!/bin/bash
# === BEGIN METADATA ===
# name: $name
# description: $desc
# usage: $usage
# tags: $tags
# === END METADATA ===
# 此文件为元数据占位文件，不包含实际代码
EOF
    echo "  ✓ 生成 $filename"
done

echo ""
echo "✅ 所有元数据文件已生成在 $TARGET_DIR"
echo "👉 现在运行以下命令将它们收录到字典树："
echo "   cmdtree scan ~/system_commands"


