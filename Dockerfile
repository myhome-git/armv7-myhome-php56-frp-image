# 选择 ARMv7 基础镜像
FROM arm32v7/debian:bullseye  

#MAINTAINER Your Name <your.email@example.com>
LABEL maintainer="admin@myhome.top"

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      php5-fpm \
      php5-cli \
      php5-mysql \
      php5-gd \
      php5-curl \
      php5-intl \
      php5-mcrypt \
      php5-xdebug \
      php5-dev \ 
      php-pear \
      wget && \
    rm -rf /var/lib/apt/lists/*

# 安装 PDO 和 PDO_MySQL (确保它们已启用)
RUN php5enmod pdo && php5enmod pdo_mysql

# 配置 PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /etc/php5/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 100M/g' /etc/php5/fpm/php.ini

# 设置 PHP-FPM 监听端口
EXPOSE 9000

# 设置工作目录
WORKDIR /var/www/html

# 启动 PHP-FPM
CMD ["/usr/sbin/php5-fpm", "-F"]

# 可选：复制 frpc 配置文件 (需要你手动创建 frpc.ini)
# COPY frpc.ini /etc/frp/frpc.ini

# 可选：启动 frpc (需要在 frpc.ini 中配置服务器地址)
# CMD ["/usr/bin/frpc", "-c", "/etc/frp/frpc.ini"]
