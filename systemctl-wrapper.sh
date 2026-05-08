#!/bin/sh
# systemctl 包装脚本，用于在 systemd namespace 中执行 systemctl 命令

# 检查是否已经在 systemd namespace 中
if [ -f /run/systemd/container ]; then
    # 已经在 systemd namespace 中，直接执行
    exec /bin/systemctl "$@"
else
    # 不在 systemd namespace 中，使用 unshare 进入 systemd namespace
    exec unshare --pid --fork --mount-proc --kill-child -- sh -c "nsenter -t 1 -m -p /bin/systemctl $*"
fi
