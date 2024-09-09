if type -p redis-server; then
    echo "redis has been installed."
else

#安装依赖
yum install cpp binutils glibc-kernheaders glibc-common glibc-devel gcc make wget -y
#解压并安装
wget http://download.redis.io/releases/redis-7.0.5.tar.gz
tar zxvf redis-7.0.5.tar.gz
rm -rf /usr/local/redis-7.0.5
cp -r redis-7.0.5 /usr/local/
cd /usr/local/redis-7.0.5 && make && make install
#修改配置文件
sed -i '309s/daemonize no/daemonize yes/' /usr/local/redis-7.0.5/redis.conf
sed -i '87s/bind 127.0.0.1 -::1/#bind 127.0.0.1 -::1/' /usr/local/redis-7.0.5/redis.conf
sed -i '111s/protected-mode yes/protected-mode no/' /usr/local/redis-7.0.5/redis.conf
#设置密码
sed -i '1036s/# requirepass foobared/requirepass Tuners2012!@#/' /usr/local/redis-7.0.5/redis.conf
#创建文件
mkdir -p /etc/redis
chmod -R 777 /etc/redis
#(在默认的配置文件路劲中放置配置文件)
rm -rf /etc/redis/6379.conf
cp -r /usr/local/redis-7.0.5/redis.conf /etc/redis/
chmod -R 777 /etc/redis/redis.conf
#修改文件名
mv /etc/redis/redis.conf /etc/redis/6379.conf
rm -rf /etc/init.d/redisd
cp -r /usr/local/redis-7.0.5/utils/redis_init_script /etc/init.d/
#修改文件名
mv /etc/init.d/redis_init_script /etc/init.d/redisd
service redisd start
#设置开机自启
chkconfig redisd on
#redis-cli
netstat -ntpl|grep redis
#关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service
echo "Redis 部署完成！"
fi