FROM ubuntu:22.04

# 安装 systemd、busybox 和 util-linux（包含 unshare）
RUN apt-get update && apt-get install -y systemd systemd-sysv busybox util-linux

# 清理 apt 缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 复制 systemctl 包装脚本
COPY systemctl-wrapper.sh /usr/local/bin/systemctl
RUN chmod +x /usr/local/bin/systemctl

# 设置 systemd 为 init 系统
STOPSIGNAL SIGRTMIN+3

# 创建必要的目录
RUN mkdir -p /run/systemd

# 设置默认目标为 multi-user.target
RUN systemctl set-default multi-user.target

# 创建健康检查页面
RUN mkdir -p /srv/www && echo 'ubuntu 22.04 on koyeb free instance' > /srv/www/index.html

# 暴露端口
EXPOSE 8000

# 使用 unshare 启动 systemd，并在后台运行 HTTP 服务器
CMD ["sh", "-c", "unshare --pid --fork --mount-proc --kill-child -- /lib/systemd/systemd --system & exec busybox httpd -f -p 0.0.0.0:${PORT} -h /srv/www"]
