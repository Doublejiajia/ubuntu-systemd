FROM ubuntu:22.04

# 安装 systemd 和 busybox
RUN apt-get update && apt-get install -y systemd systemd-sysv busybox

# 清理 apt 缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置 systemd 为 init 系统
STOPSIGNAL SIGRTMIN+3

# 创建必要的目录
RUN mkdir -p /run/systemd &&     systemctl set-default multi-user.target

# 创建健康检查页面
RUN mkdir -p /srv/www && printf '%s
' 'ubuntu 22.04 on koyeb free instance' > /srv/www/index.html

# 暴露端口
EXPOSE 8000

# 启动 systemd 和 HTTP 服务器
CMD ["sh", "-c", "exec busybox httpd -f -p 0.0.0.0:${PORT} -h /srv/www"]
