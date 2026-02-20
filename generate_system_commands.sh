#!/data/data/com.termux/files/usr/bin/bash
# === BEGIN METADATA ===
# name: generate_system_commands
# description: 为常用系统命令生成元数据文件，方便 cmdtree 收录
# usage: ./generate_system_commands.sh
# version: 1.0.2
# author: TurinFohlen
# tags: 工具, 元数据生成
# === END METADATA ===

# 目标目录
TARGET_DIR="$HOME/dict-tree/data/0/1/2/3/4/5/6/7/8/9/system_commands"

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
    # ===== Git 版本控制 =====
"git|分布式版本控制系统|git [选项] 命令 [参数...]|版本控制,git"
"git init|初始化一个新的 Git 仓库|git init [目录]|版本控制,git,初始化"
"git clone|克隆远程仓库到本地|git clone <仓库地址> [目录]|版本控制,git,克隆"
"git add|添加文件内容到暂存区|git add [文件...]|版本控制,git,暂存"
"git commit|记录暂存区的修改到仓库|git commit -m \"提交信息\"|版本控制,git,提交"
"git status|查看工作区和暂存区的状态|git status|版本控制,git,状态"
"git log|显示提交日志|git log [选项]|版本控制,git,日志"
"git diff|显示工作区与暂存区/提交的差异|git diff [选项]|版本控制,git,差异"
"git branch|管理分支|git branch [选项] [分支名]|版本控制,git,分支"
"git checkout|切换分支或恢复工作区文件|git checkout <分支名/文件>|版本控制,git,切换"
"git merge|合并一个分支到当前分支|git merge <分支名>|版本控制,git,合并"
"git pull|从远程仓库拉取并合并|git pull [远程名] [分支名]|版本控制,git,拉取"
"git push|推送本地提交到远程仓库|git push [远程名] [分支名]|版本控制,git,推送"
"git remote|管理远程仓库|git remote [选项]|版本控制,git,远程"
"git fetch|从远程仓库下载对象和引用|git fetch [远程名] [分支名]|版本控制,git,获取"
"git reset|重置当前 HEAD 到指定状态|git reset [模式] [提交]|版本控制,git,重置"
"git revert|撤销一个提交（通过创建新提交）|git revert <提交>|版本控制,git,撤销"
"git stash|暂存未提交的修改|git stash [子命令]|版本控制,git,暂存"
"git tag|管理标签|git tag [选项] [标签名]|版本控制,git,标签"
"git rebase|变基操作|git rebase [基分支]|版本控制,git,变基"
"git cherry-pick|将指定提交应用到当前分支|git cherry-pick <提交>|版本控制,git,精选"
"git config|配置 Git 选项|git config [选项] 名称 [值]|版本控制,git,配置"
"git grep|在版本库中搜索文本|git grep <模式>|版本控制,git,搜索"
"git show|显示提交信息|git show <提交>|版本控制,git,查看"
"git rm|从工作区和索引中删除文件|git rm [文件...]|版本控制,git,删除"
"git mv|移动或重命名文件|git mv <源> <目标>|版本控制,git,移动"
"git archive|从指定提交创建归档|git archive [选项] <提交>|版本控制,git,归档"
"git blame|显示每行文件的最后修改者|git blame [文件]|版本控制,git,追溯"
"git bisect|二分查找引入错误的提交|git bisect <子命令>|版本控制,git,调试"
"git clean|删除未跟踪的文件|git clean [选项]|版本控制,git,清理"
"git reflog|管理引用日志|git reflog [子命令]|版本控制,git,日志"
# ===== C/C++ 工具链 =====
"gcc|GNU C 编译器|gcc [选项] 文件...|编程,c,编译"
"g++|GNU C++ 编译器|g++ [选项] 文件...|编程,c++,编译"
"clang|C 语言编译器 (LLVM)|clang [选项] 文件...|编程,c,编译"
"clang++|C++ 编译器 (LLVM)|clang++ [选项] 文件...|编程,c++,编译"
"make|自动化构建工具|make [选项] [目标]|构建"
"cmake|跨平台构建工具|cmake [选项] <源路径>|构建"
"gdb|GNU 调试器|gdb [选项] [可执行文件]|编程,调试"
"ld|GNU 链接器|ld [选项] 目标文件...|编程,链接"
"ar|创建、修改静态库|ar [选项] 存档文件 目标文件...|编程,库"
"nm|列出目标文件的符号|nm [选项] 文件...|编程,符号"
"objdump|显示目标文件信息|objdump [选项] 文件...|编程,反汇编"
"strip|剥离符号表|strip [选项] 文件...|编程,优化"
"cpp|C 预处理器|cpp [选项] 输入文件 [输出文件]|编程,c,预处理"

# ===== Python =====
"python|Python 解释器|python [选项] [脚本]|编程,解释器"
"python3|Python 3 解释器|python3 [选项] [脚本]|编程,解释器"
"pip|Python 包安装工具|pip [命令] [选项] [包名]|编程,包管理"
"pip3|Python 3 包安装工具|pip3 [命令] [选项] [包名]|编程,包管理"
"ipython|增强的 Python 交互式 shell|ipython [选项]|编程,解释器"
"jupyter|Jupyter Notebook 应用|jupyter [子命令] [选项]|编程,笔记本"
"jupyter-lab|JupyterLab 界面|jupyter-lab [选项]|编程,笔记本"
"pylint|Python 代码静态分析工具|pylint [选项] 模块或包|编程,静态分析"
"flake8|Python 代码风格检查工具|flake8 [选项] 文件或目录|编程,风格检查"
"black|Python 代码格式化工具|black [选项] 文件或目录|编程,格式化"
"mypy|Python 静态类型检查|mypy [选项] 文件或目录|编程,类型检查"
"pytest|Python 测试框架|pytest [选项] [文件或目录]|编程,测试"
"unittest|Python 单元测试框架|python -m unittest [选项] [测试...]|编程,测试"
"virtualenv|创建隔离的 Python 环境|virtualenv [选项] 目录|编程,虚拟环境"
"venv|创建轻量级虚拟环境|python3 -m venv 目录|编程,虚拟环境"
"pipenv|Python 依赖管理工具|pipenv [命令] [选项]|编程,依赖管理"
"poetry|Python 依赖管理和打包|poetry [命令] [选项]|编程,依赖管理"
"conda|跨平台的包和环境管理器|conda [命令] [选项]|编程,环境管理"

# ===== Java =====
"java|Java 应用启动器|java [选项] 类 [参数...]|编程,java"
"javac|Java 编译器|javac [选项] 源文件...|编程,java,编译"
"javadoc|生成 Java API 文档|javadoc [选项] [包名] 源文件...|编程,java,文档"
"jar|Java 归档工具|jar [选项] jar文件 [输入文件...]|编程,java,打包"
"jshell|Java REPL 工具|jshell [选项]|编程,java,交互式"
"jpackage|打包 Java 应用|jpackage [选项]|编程,java,打包"
"jlink|组装和优化运行时镜像|jlink [选项]|编程,java,运行时"
"jmod|创建和管理 JMOD 文件|jmod [命令] [选项] 文件|编程,java,模块"
"jconsole|Java 监控和管理控制台|jconsole [选项]|编程,java,监控"
"jvisualvm|Java 可视化虚拟机|jvisualvm [选项]|编程,java,监控"
"jps|列出 Java 进程|jps [选项]|编程,java,进程"
"jstat|JVM 统计监控|jstat [选项] vmid [间隔] [次数]|编程,java,监控"
"jstack|打印 Java 线程堆栈|jstack [选项] 进程ID|编程,java,调试"
"jmap|打印 Java 内存映射|jmap [选项] 进程ID|编程,java,内存"
"jhat|Java 堆分析工具|jhat [选项] 堆转储文件|编程,java,分析"
"jdb|Java 调试器|jdb [选项] [类名]|编程,java,调试"

# ===== Kotlin =====
"kotlin|Kotlin 应用启动器|kotlin [选项] 脚本或类 [参数...]|编程,kotlin"
"kotlinc|Kotlin 编译器|kotlinc [选项] 源文件...|编程,kotlin,编译"
"kotlinc-jvm|Kotlin/JVM 编译器|kotlinc-jvm [选项] 源文件...|编程,kotlin,jvm"
"kotlinc-js|Kotlin/JS 编译器|kotlinc-js [选项] 源文件...|编程,kotlin,js"
"kotlinc-native|Kotlin/Native 编译器|kotlinc-native [选项] 源文件...|编程,kotlin,native"
"kscript|Kotlin 脚本运行器|kscript [选项] 脚本文件 [参数...]|编程,kotlin,脚本"

# ===== Scala =====
"scala|Scala 解释器|scala [选项] [脚本或类] [参数...]|编程,scala"
"scalac|Scala 编译器|scalac [选项] 源文件...|编程,scala,编译"
"scaladoc|Scala API 文档生成器|scaladoc [选项] 源文件...|编程,scala,文档"
"scalap|Scala 类文件解码器|scalap [选项] 类名...|编程,scala,反编译"
"sbt|Scala 构建工具|sbt [选项] [命令]|编程,scala,构建"
"amm|Ammonite Scala REPL|amm [选项] [脚本文件]|编程,scala,repl"
"mill|Scala 构建工具|mill [选项] [目标]|编程,scala,构建"

# ===== Go =====
"go|Go 工具链|go <命令> [参数]|编程,go"
"gofmt|Go 代码格式化工具|gofmt [选项] [文件或目录]|编程,go,格式化"
"go run|编译并运行 Go 程序|go run [构建标志] Go文件... [参数...]|编程,go,运行"
"go build|编译 Go 包|go build [选项] [包名]|编程,go,编译"
"go install|编译并安装包|go install [选项] [包名]|编程,go,安装"
"go get|添加或更新依赖|go get [选项] [包路径]|编程,go,依赖"
"go mod|Go 模块管理|go mod <命令> [参数]|编程,go,模块"
"go test|运行测试|go test [选项] [包名]|编程,go,测试"
"go fmt|格式化 Go 代码|go fmt [包名]|编程,go,格式化"
"go vet|报告可疑的代码结构|go vet [选项] [包名]|编程,go,静态分析"
"go doc|显示文档|go doc [选项] [包名] [符号]|编程,go,文档"
"go env|显示 Go 环境变量|go env [变量名...]|编程,go,环境"
"go list|列出包|go list [选项] [包名]|编程,go,信息"
"go generate|生成 Go 文件|go generate [选项] [文件或包]|编程,go,代码生成"
"go clean|清理临时文件|go clean [选项] [包名]|编程,go,清理"
"go tool|运行指定的 Go 工具|go tool <工具名> [参数...]|编程,go,工具"

# ===== Rust =====
"rustc|Rust 编译器|rustc [选项] 源文件|编程,rust,编译"
"rustdoc|Rust 文档生成器|rustdoc [选项] 源文件|编程,rust,文档"
"rustfmt|Rust 代码格式化工具|rustfmt [选项] [文件或目录]|编程,rust,格式化"
"rustup|Rust 工具链安装器|rustup [命令] [选项]|编程,rust,工具链"
"cargo|Rust 包管理器|cargo [命令] [选项]|编程,rust,构建"
"cargo new|创建新 Rust 项目|cargo new <路径> [选项]|编程,rust,创建"
"cargo build|编译项目|cargo build [选项]|编程,rust,编译"
"cargo run|运行项目|cargo run [选项] [-- [参数...]]|编程,rust,运行"
"cargo test|运行测试|cargo test [选项] [测试名]|编程,rust,测试"
"cargo doc|生成文档|cargo doc [选项]|编程,rust,文档"
"cargo check|快速检查代码|cargo check [选项]|编程,rust,检查"
"cargo clean|清理目标目录|cargo clean [选项]|编程,rust,清理"
"cargo update|更新依赖|cargo update [选项]|编程,rust,更新"
"cargo publish|发布包到 crates.io|cargo publish [选项]|编程,rust,发布"
"cargo install|安装 Rust 二进制包|cargo install [选项] <包名>|编程,rust,安装"
"cargo uninstall|卸载 Rust 包|cargo uninstall <包名>|编程,rust,卸载"

# ===== JavaScript/Node.js =====
"node|Node.js JavaScript 运行时|node [选项] [脚本] [参数...]|编程,node"
"npm|Node.js 包管理器|npm [命令] [选项]|编程,node,包管理"
"npx|执行 Node 包中的命令|npx [选项] <命令> [参数...]|编程,node,执行"
"yarn|JavaScript 包管理器|yarn [命令] [选项]|编程,包管理"
"pnpm|快速的 Node.js 包管理器|pnpm [命令] [选项]|编程,node,包管理"
"bun|JavaScript 运行时和工具链|bun [命令] [选项]|编程,运行时"
"deno|JavaScript/TypeScript 运行时|deno [子命令] [选项]|编程,运行时"
"tsc|TypeScript 编译器|tsc [选项] [文件...]|编程,typescript,编译"
"ts-node|TypeScript 执行引擎|ts-node [选项] 脚本 [参数...]|编程,typescript,执行"
"webpack|模块打包器|webpack [选项] [入口]|构建,打包"
"babel|JavaScript 编译器|babel [选项] 文件或目录|编程,编译"
"eslint|JavaScript 代码检查工具|eslint [选项] [文件...]|编程,代码检查"
"prettier|代码格式化工具|prettier [选项] [文件...]|编程,格式化"
"jest|JavaScript 测试框架|jest [选项] [测试文件...]|编程,测试"
"mocha|JavaScript 测试框架|mocha [选项] [文件...]|编程,测试"
"nodemon|监控文件变化并重启应用|nodemon [选项] [脚本]|开发,工具"

# ===== TypeScript =====
"tsc|TypeScript 编译器|tsc [选项] [文件...]|编程,typescript,编译"
"ts-node|TypeScript 执行引擎|ts-node [选项] 脚本 [参数...]|编程,typescript,执行"
"tsc-watch|监视 TypeScript 编译|tsc-watch [选项]|编程,typescript,监视"

# ===== Ruby =====
"ruby|Ruby 解释器|ruby [选项] [脚本] [参数...]|编程,ruby"
"irb|Ruby 交互式 shell|irb [选项]|编程,ruby,交互"
"gem|Ruby 包管理器|gem [命令] [选项] [包名]|编程,ruby,包管理"
"bundle|Ruby 依赖管理|bundle [命令] [选项]|编程,ruby,依赖"
"rake|Ruby 构建工具|rake [选项] [任务]|编程,ruby,构建"
"rails|Ruby on Rails 框架|rails [命令] [选项] [参数...]|编程,ruby,框架"
"rackup|Rack 应用启动器|rackup [选项] [配置]|编程,ruby,web"
"rspec|Ruby 测试框架|rspec [选项] [文件或目录]|编程,ruby,测试"

# ===== PHP =====
"php|PHP 命令行接口|php [选项] [脚本] [参数...]|编程,php"
"php-fpm|PHP FastCGI 进程管理器|php-fpm [选项]|编程,php,服务器"
"composer|PHP 依赖管理器|composer [命令] [选项] [参数...]|编程,php,包管理"
"phpunit|PHP 测试框架|phpunit [选项] [测试文件...]|编程,php,测试"
"php-cs-fixer|PHP 代码格式化工 具|php-cs-fixer [命令] [选项]|编程,php,格式化"
"phpstan|PHP 静态分析工具|phpstan [命令] [选项] [路径]|编程,php,静态分析"
"psalm|PHP 静态分析工具|psalm [选项] [路径]|编程,php,静态分析"

# ===== Perl =====
"perl|Perl 解释器|perl [选项] [脚本] [参数...]|编程,perl"
"cpan|Perl 包管理器|cpan [模块名]|编程,perl,包管理"
"cpanm|Perl 包管理器（精简版）|cpanm [选项] 模块名|编程,perl,包管理"
"perldoc|Perl 文档查看器|perldoc [选项] 模块或函数|编程,perl,文档"

# ===== Lua =====
"lua|Lua 解释器|lua [选项] [脚本] [参数...]|编程,lua"
"luac|Lua 编译器|luac [选项] [文件...]|编程,lua,编译"
"luarocks|Lua 包管理器|luarocks [命令] [选项] [包名]|编程,lua,包管理"

# ===== Swift =====
"swift|Swift 编译器|swift [选项] [脚本或文件] [参数...]|编程,swift"
"swiftc|Swift 编译器|swiftc [选项] 文件...|编程,swift,编译"
"swift build|Swift 包管理器构建|swift build [选项]|编程,swift,构建"
"swift run|运行可执行包|swift run [选项] [可执行名] [参数...]|编程,swift,运行"
"swift test|运行测试|swift test [选项]|编程,swift,测试"
"swift package|Swift 包管理|swift package [命令] [选项]|编程,swift,包管理"

# ===== Kotlin =====
"kotlin|Kotlin 应用启动器|kotlin [选项] 脚本或类 [参数...]|编程,kotlin"
"kotlinc|Kotlin 编译器|kotlinc [选项] 源文件...|编程,kotlin,编译"

# ===== Dart =====
"dart|Dart 运行时|dart [选项] [脚本] [参数...]|编程,dart"
"dart compile|Dart 编译器|dart compile <目标> [选项] 输入文件|编程,dart,编译"
"dart run|运行 Dart 程序|dart run [选项] [脚本] [参数...]|编程,dart,运行"
"dart pub|Dart 包管理器|dart pub [命令] [选项]|编程,dart,包管理"
"dart analyze|静态分析代码|dart analyze [选项] [路径]|编程,dart,分析"
"dart format|格式化代码|dart format [选项] [路径]|编程,dart,格式化"
"dart test|运行测试|dart test [选项] [路径]|编程,dart,测试"

# ===== R =====
"R|R 统计计算环境|R [选项] [文件]|编程,r,统计"
"Rscript|R 脚本执行器|Rscript [选项] 脚本 [参数...]|编程,r,脚本"
"R CMD|R 工具集|R CMD <命令> [选项]|编程,r,工具"

# ===== Julia =====
"julia|Julia 编程语言|julia [选项] [脚本] [参数...]|编程,julia"
"juliaup|Julia 版本管理器|juliaup [命令] [选项]|编程,julia,版本管理"

# ===== Shell 脚本相关 =====
"bash|Bourne Again SHell|bash [选项] [脚本] [参数...]|shell,脚本"
"sh|Bourne shell|sh [选项] [脚本] [参数...]|shell,脚本"
"zsh|Z shell|zsh [选项] [脚本] [参数...]|shell,脚本"
"fish|friendly interactive shell|fish [选项] [脚本] [参数...]|shell,脚本"
"ksh|KornShell|ksh [选项] [脚本] [参数...]|shell,脚本"
"dash|Debian Almquist shell|dash [选项] [脚本] [参数...]|shell,脚本"

# ===== 编译工具链通用 =====
"make|自动化构建工具|make [选项] [目标]|构建"
"cmake|跨平台构建工具|cmake [选项] <源路径>|构建"
"ninja|小型构建系统|ninja [选项] [目标]|构建"
"autoconf|生成配置脚本|autoconf [选项] [模板文件]|构建,配置"
"automake|生成 Makefile|automake [选项] [Makefile.am]|构建"
"configure|配置构建选项|./configure [选项]|构建,配置"
"libtool|通用库支持脚本|libtool [选项] [命令]|构建,库"
"pkg-config|查询库的编译参数|pkg-config [选项] <库名>|构建,依赖"
"gprof|性能分析工具|gprof [选项] [可执行文件] [数据文件]|编程,性能分析"
"valgrind|内存调试工具|valgrind [选项] 程序 [参数...]|编程,调试,内存"

# ===== 虚拟机与容器 =====
"docker|容器化平台|docker [命令] [选项]|容器,虚拟化"
"docker-compose|多容器应用定义|docker-compose [命令] [选项]|容器,编排"
"podman|无守护进程容器引擎|podman [命令] [选项]|容器"
"kubectl|Kubernetes 命令行工具|kubectl [命令] [选项]|容器,编排"
"minikube|本地 Kubernetes 集群|minikube [命令] [选项]|容器,开发"
"helm|Kubernetes 包管理器|helm [命令] [选项]|容器,包管理"
"vagrant|虚拟机环境管理|vagrant [命令] [选项]|虚拟化"
"terraform|基础设施即代码|terraform [命令] [选项]|基础设施"
"ansible|自动化运维工具|ansible [选项]|自动化,运维"
"ansible-playbook|运行 playbook|ansible-playbook [选项] playbook.yml|自动化,运维"

    # ===== Shell 操作符（重定向）=====
    ">|覆盖重定向（无视 noclobber）|cmd >| 文件|shell,重定向"
    ">|覆盖输出重定向（覆盖目标文件）|cmd > 文件|shell,重定向"
    ">>|追加输出重定向|cmd >> 文件|shell,重定向"
    "<|从文件重定向输入|cmd < 文件|shell,重定向"
    "2>|将标准错误重定向到文件|cmd 2> 文件|shell,重定向,错误"
    "2>>|将标准错误追加重定向到文件|cmd 2>> 文件|shell,重定向,错误"
    "&>|将标准输出和标准错误重定向到同一文件|cmd &> 文件|shell,重定向,错误"
    ">&|将标准输出重定向到指定文件描述符|cmd 1>&2|shell,重定向,描述符"
    "<<|Here 文本重定向（到命令的标准输入）|cmd << EOF ... EOF|shell,重定向,here-doc"
    "<<-|忽略缩进的 Here 文本|cmd <<- EOF ... EOF|shell,重定向,here-doc"
    "<(|进程替换（把子命令输出当作文件）|cmd <(其他命令)|shell,进程替换"
    ">(|进程替换（把输出写给子命令）|cmd >(其他命令)|shell,进程替换"

    # ===== Shell 操作符（管道与连接）=====
    "| |管道，将前一命令的输出作为后一命令的输入|cmd1 | cmd2|shell,管道"
    "|||逻辑或，前一命令失败时才执行后一命令|cmd1 || cmd2|shell,逻辑"
    "&&|逻辑与，前一命令成功时才执行后一命令|cmd1 && cmd2|shell,逻辑"
    ";|顺序执行多条命令|cmd1; cmd2; cmd3|shell,顺序执行"
    "&&||组合控制（成功才继续/失败才补救）|cmd1 && cmd2 || cmd3|shell,逻辑,流程控制"
    "|| true|忽略前一命令错误（常见模式）|cmd || true|shell,错误处理"

    # ===== Shell 操作符（分组与子 shell）=====
    "()|在子 shell 中执行一组命令| ( cmd1; cmd2 )|shell,子shell"
    "{}|在当前 shell 中分组执行命令|{ cmd1; cmd2; }|shell,分组"
    "$()|命令替换，用命令输出替换|var=$(cmd)|shell,命令替换"
    "``|反引号命令替换（旧语法，不推荐）|var=`cmd`|shell,命令替换"

    # ===== Shell 操作符（通配与扩展）=====
    "*|通配符，匹配任意长度字符串|ls *|shell,通配"
    "?|通配符，匹配单个任意字符|ls ?.txt|shell,通配"
    "[]|字符集合匹配|ls [ab]*.txt|shell,通配"
    "{..}|大括号展开|echo file{1..3}.txt|shell,展开"
    "~|当前用户主目录|cd ~|shell,路径"
    "~user|指定用户主目录|cd ~root|shell,路径"
    "$VAR|变量引用|echo $PATH|shell,变量"
    "${VAR}|变量引用（安全写法）|echo ${HOME}|shell,变量"

    # ===== Shell 操作符（测试与比较）=====
    "==|字符串相等比较（[[ 中有效）|[[ $a == $b ]]|shell,比较"
    "!=|字符串不等比较|[[ $a != $b ]]|shell,比较"
    "-eq|整数相等|[ $a -eq $b ]|shell,比较,整数"
    "-ne|整数不等|[ $a -ne $b ]|shell,比较,整数"
    "-gt|大于|[ $a -gt $b ]|shell,比较,整数"
    "-lt|小于|[ $a -lt $b ]|shell,比较,整数"
    "-ge|大于等于|[ $a -ge $b ]|shell,比较,整数"
    "-le|小于等于|[ $a -le $b ]|shell,比较,整数"
    "-z|字符串长度为 0|[ -z "$str" ]|shell,比较,字符串"
    "-n|字符串长度非 0|[ -n "$str" ]|shell,比较,字符串"
    "-f|为普通文件|[ -f 文件 ]|shell,文件测试"
    "-d|为目录|[ -d 目录 ]|shell,文件测试"
    "-e|文件存在|[ -e 路径 ]|shell,文件测试"
    "-s|文件大小非 0|[ -s 文件 ]|shell,文件测试"
    "-r|可读|[ -r 文件 ]|shell,权限"
    "-w|可写|[ -w 文件 ]|shell,权限"
    "-x|可执行|[ -x 文件 ]|shell,权限"

    # ===== Shell 操作符（参数/特殊变量）=====
    "$0|当前脚本名称|echo $0|shell,参数"
    "$1..$9|位置参数|echo $1|shell,参数"
    "$@|所有参数（保持分隔）|echo "$@"|shell,参数"
    "$*|所有参数（合并成一个）|echo "$*"|shell,参数"
    "$?|上一条命令的退出状态|echo $?|shell,状态码"
    "$$|当前 shell 进程 ID|echo $$|shell,进程"
    "$!|最近一个后台进程的 PID|echo $!|shell,进程"
    "$#|参数个数|echo $#|shell,参数"

    # ===== Shell 操作符（模式匹配与替换）=====
    "${var%pattern}|从末尾最短匹配删除|${file%.txt}|shell,参数展开"
    "${var%%pattern}|从末尾最长匹配删除|${path%%/*}|shell,参数展开"
    "${var#pattern}|从开头最短匹配删除|${path#/home/}|shell,参数展开"
    "${var##pattern}|从开头最长匹配删除|${path##*/}|shell,参数展开"
    "${var/pat/repl}|替换第一个匹配|${str/foo/bar}|shell,参数展开"
    "${var//pat/repl}|替换所有匹配|${str//foo/bar}|shell,参数展开"
    "${var:-default}|若未设置或为空，用默认值|${NAME:-guest}|shell,参数展开"
    "${var:=default}|未设置时赋默认值|${NAME:=guest}|shell,参数展开"
    "${var:+alt}|若已设置则用替代值|${NAME:+set}|shell,参数展开"
    "${var:?msg}|未设置时报错并退出|${NAME:?must set NAME}|shell,参数展开"






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
echo "   cmdtree scan $HOME/dict-tree/data/0/1/2/3/4/5/6/7/8/9/system_commands"

echo "   cd \"$TARGET_DIR\" && for f in *.meta; do mv \"\$f\" \"\${f%.meta}.sh\"; done && chmod +x *.sh && cmdtree scan ."
