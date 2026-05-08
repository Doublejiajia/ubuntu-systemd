FROM ubuntu:22.04

# 安装 systemd
RUN apt-get update && apt-get install -y systemd systemd-sysv

# 清理 apt 缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置 systemd 为 init 系统
STOPSIGNAL SIGRTMIN+3

# 创建必要的目录
RUN mkdir -p /run/systemd &&     systemctl set-default multi-user.target

# 暴露 SSH 端口（如果需要）
EXPOSE 22

# 启动 systemd
CMD ["/sbin/init"]
